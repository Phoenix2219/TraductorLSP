import os
import cv2
import numpy as np
import tensorflow as tf
import mediapipe as mp
import pyttsx3  # Para la conversión de texto a voz
import threading  # Para manejar la ejecución en hilos

# Definiciones
NUM_HAND_LANDMARKS = 21  # Cada mano tiene 21 puntos clave

# Inicializa el modelo de detección de manos de MediaPipe
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.5)
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles

# Ruta del modelo .keras
model_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sign_language_model', 'sign_language_model.keras')

# Carga el modelo Keras
model = tf.keras.models.load_model(model_path)

# Carga las etiquetas
labels_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sign_language_dataset', 'labels.txt')
with open(labels_file, 'r') as f:
    labels = f.read().splitlines()

# Inicializa el motor de voz
engine_voice = pyttsx3.init()

# Configura el motor de voz
engine_voice.setProperty('rate', 150)    # Velocidad de habla
engine_voice.setProperty('volume', 0.9)  # Volumen

def speak(text):
    """Convierte texto en voz.""" 
    engine_voice.say(text)  # Inicia la nueva frase
    engine_voice.runAndWait()  # Espera a que termine de hablar

def preprocess_frame(frame):
    """Procesa el frame y devuelve los landmarks detectados."""
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = hands.process(frame_rgb)
    
    # Rellena con ceros en caso de no detectar puntos
    landmarks = np.zeros((NUM_HAND_LANDMARKS * 2, 3))  # Para 2 manos, cada una con 21 puntos y 3 ejes x, y, z
    
    # Asigna los puntos detectados a las manos
    if results.multi_hand_landmarks:
        for i, hand_landmarks in enumerate(results.multi_hand_landmarks):
            landmarks_data = np.array([(lm.x, lm.y, lm.z) for lm in hand_landmarks.landmark])
                                
            # Asigna los puntos clave a las posiciones correspondientes en función de si es la primera o segunda mano.
            if i == 0:  # Primera mano
                landmarks[:NUM_HAND_LANDMARKS] = landmarks_data
            elif i == 1:  # Segunda mano
                landmarks[NUM_HAND_LANDMARKS:] = landmarks_data
    
    return landmarks.flatten(), results

def make_inference(frame, landmarks):
    """Hace la inferencia sobre el frame y la predicción."""
    if np.count_nonzero(landmarks) > 0:
        # Normaliza la entrada
        landmarks = landmarks.reshape(1, -1)  # Redimensiona a la forma esperada por el modelo (1 fila, y la cantidad de columnas detectadas)
        
        # Realiza la inferencia usando el modelo Keras
        predictions = model.predict(landmarks)
        
        # Obtiene la clase con mayor probabilidad
        predicted_class = np.argmax(predictions, axis=1)[0]
        predicted_label = labels[predicted_class]
        
        # Obtiene el porcentaje de certeza
        confidence = np.max(predictions) * 100
        
        # Predicción con porcentaje
        prediction_text = f"{predicted_label} ({confidence:.2f}%)"
        
        # Ejecuta la voz en un hilo separado
        thread = threading.Thread(target=speak, args=(predicted_label,))
        thread.start()
        
        return predicted_label, confidence
    else:
        return "No se detectó la mano", 0.0

def start_inference():
    """Inicia el video en tiempo real y procesa los frames para inferencia."""
    cap = cv2.VideoCapture(0)  # Captura de video desde la cámara
    if not cap.isOpened():
        print("Error: No se pudo abrir la cámara.")
        return
    
    # Factor de padding
    padding_factor = 20 

    while True:
        ret, frame = cap.read()
        if not ret:
            print("Error al leer el frame.")
            break

        # Realiza la inferencia y obtiene los landmarks
        landmarks, results = preprocess_frame(frame)
        prediction, confidence = make_inference(frame, landmarks)

        # Si se detectan manos, dibuja los landmarks y coloca la predicción sobre la mano
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                # Convierte los puntos de la mano a coordenadas de la imagen
                hand_landmark_list = [(int(lm.x * frame.shape[1]), int(lm.y * frame.shape[0])) for lm in hand_landmarks.landmark]
                
                # El punto clave 0 es la posición de la parte superior izquierda, 5 es la parte inferior derecha
                x_coords = [lm[0] for lm in hand_landmark_list]
                y_coords = [lm[1] for lm in hand_landmark_list]

                x1, y1 = min(x_coords), min(y_coords)  # Esquina superior izquierda
                x2, y2 = max(x_coords), max(y_coords)  # Esquina inferior derecha

                # Padding (margen) alrededor del rectángulo
                x1 -= padding_factor
                y1 -= padding_factor
                x2 += padding_factor
                y2 += padding_factor

                # Esto asegura de que las coordenadas no salgan fuera de los límites de la imagen
                x1, y1 = max(x1, 0), max(y1, 0)
                x2, y2 = min(x2, frame.shape[1] - 1), min(y2, frame.shape[0] - 1)

                # Dibuja el rectángulo alrededor de la mano
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 0), 4)
                
                # Muestra la predicción con el porcentaje de certeza
                cv2.putText(frame, f"{prediction} ({confidence:.2f}%)", 
                            (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1.3, (0, 0, 0), 3, cv2.LINE_AA)

                # Dibuja los puntos clave y las conexiones de la mano con colores predeterminados
                mp_drawing.draw_landmarks(  # Dibuja los puntos clave de la mano y las conexiones en el fotograma.
                    frame,  # El fotograma en el que se dibujarán los puntos clave y las conexiones de la mano.
                    hand_landmarks,  # Los puntos clave de la mano detectados por el modelo de MediaPipe.
                    mp_hands.HAND_CONNECTIONS,  # Las conexiones entre los puntos clave de la mano.
                    mp_drawing_styles.get_default_hand_landmarks_style(),  # Estilo predeterminado para los puntos clave.
                    mp_drawing_styles.get_default_hand_connections_style()  # Estilo predeterminado para las conexiones.
                )

        cv2.putText(frame, "Presiona 'q' para salir", 
                    (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 0), 2, cv2.LINE_AA)

        # Muestra el resultado de la inferencia
        cv2.imshow("Inferencia en tiempo real", frame)

        # Sale con la tecla 'q'
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    start_inference()
