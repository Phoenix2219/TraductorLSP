import pickle  # Importa el módulo "pickle" para serialización de objetos.
import cv2  # Importa la biblioteca "cv2" para procesamiento de imágenes y videos.
import mediapipe as mp  # Importa la biblioteca "mediapipe" para el análisis de imágenes.
import numpy as np  # Importa el módulo numpy para manipulación de arreglos.
import pyttsx3  # Importa pyttsx3 para la función de texto a voz.
import threading # Importa la librería para el uso de hilos

# Inicializa el motor de pyttsx3
engine_voice = pyttsx3.init()

# Se configuran propiedades del motor, como la velocidad y el volumen
engine_voice.setProperty('rate', 150)    # Velocidad de habla (default es 200)
engine_voice.setProperty('volume', 0.9)  # Volumen (default es 1.0)

def speak(text):
    try:
        # Pasa el texto al motor de pyttsx3
        engine_voice.say(text)
        # Ejecuta el comando para convertir el texto a voz
        engine_voice.runAndWait()
    except Exception:
        pass

# Carga el modelo entrenado desde el archivo 'model.p'.
model_dict = pickle.load(open('./model.p', 'rb'))
model = model_dict['model']

# Carga los datos para ajustar la longitud de lo que detecte
data_dict = pickle.load(open('./data.pickle', 'rb'))  # Carga los datos y las etiquetas desde el archivo 'data.pickle'.
data = np.asarray(data_dict['data'])  # Convierte los datos a un arreglo numpy.

# Inicia la captura de video desde la cámara web por defecto.
cap = cv2.VideoCapture(0)

# Inicializa el modelo de detección de manos de MediaPipe.
mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.3)

while True:  # Bucle infinito para procesar cada fotograma de video.

    data_aux = []  # Lista auxiliar para almacenar los puntos clave de la mano.
    x_ = []  # Lista para almacenar las coordenadas x de los puntos clave.
    y_ = []  # Lista para almacenar las coordenadas y de los puntos clave.

    ret, frame = cap.read()  # Captura un fotograma de la cámara.

    H, W, _ = frame.shape  # Obtiene las dimensiones del fotograma.

    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)  # Convierte el fotograma a formato RGB.

    results = hands.process(frame_rgb)  # Procesa el fotograma en busca de manos.
    if results.multi_hand_landmarks:  # Si se detectan manos en el fotograma.
        for hand_landmarks in results.multi_hand_landmarks: # Itera sobre los puntos clave de la mano detectados en el fotograma.
            mp_drawing.draw_landmarks(  # Dibuja los puntos clave de la mano y las conexiones en el fotograma.
                frame,  # El fotograma en el que se dibujarán los puntos clave y las conexiones de la mano.
                hand_landmarks,  # Los puntos clave de la mano detectados por el modelo de MediaPipe.
                mp_hands.HAND_CONNECTIONS, # Las conexiones entre los puntos clave de la mano. Define cómo se deben conectar los puntos clave para formar una mano.
                mp_drawing_styles.get_default_hand_landmarks_style(), # El estilo predeterminado para dibujar los puntos clave de la mano. Incluye colores y tamaños predefinidos.
                mp_drawing_styles.get_default_hand_connections_style() # El estilo predeterminado para dibujar las conexiones entre los puntos clave de la mano. Incluye colores y tamaños predefinidos.
            )

        for hand_landmarks in results.multi_hand_landmarks: # Itera sobre los puntos clave de la mano detectados en el fotograma.
            for i in range(len(hand_landmarks.landmark)):
                x = hand_landmarks.landmark[i].x  # Coordenada x del punto clave.
                y = hand_landmarks.landmark[i].y  # Coordenada y del punto clave.
                data_aux.append(x)  # Agrega la coordenada x a la lista auxiliar.
                data_aux.append(y)  # Agrega la coordenada y a la lista auxiliar.
                x_.append(x)  # Agrega la coordenada x a la lista de coordenadas x.
                y_.append(y)  # Agrega la coordenada y a la lista de coordenadas y.

        # Calcula las coordenadas del rectángulo que rodea la mano.
        x1 = int(min(x_) * W) - 10  # Calcula la coordenada x del punto superior izquierdo del rectángulo que rodea la mano.
        y1 = int(min(y_) * H) - 10  # Calcula la coordenada y del punto superior izquierdo del rectángulo que rodea la mano.
        x2 = int(max(x_) * W) - 10  # Calcula la coordenada x del punto inferior derecho del rectángulo que rodea la mano.
        y2 = int(max(y_) * H) - 10  # Calcula la coordenada y del punto inferior derecho del rectángulo que rodea la mano.

        # Obtiene la longitud máxima de todas las sublistas de data.
        max_length = max(len(sublist) for sublist in data)

        # Ajusta todas las sublistas para que tengan la misma longitud (rellenando con ceros).
        data_aux = data_aux + [0] * (max_length - len(data_aux))

        # Realiza una predicción utilizando el modelo entrenado.
        prediction = model.predict([np.asarray(data_aux)])  # Utiliza el modelo para predecir el gesto de la mano representado por los datos auxiliares.
        predicted_character = prediction[0]  # Obtiene el carácter predicho

        # Crear un hilo para ejecutar la función de hablar
        thread = threading.Thread(target=speak, args=(predicted_character,))
        thread.start()

        # Dibuja un rectángulo alrededor de la mano y muestra el carácter predicho.
        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 0), 4)  # Dibuja un rectángulo alrededor de la mano en el fotograma.
        cv2.putText(frame, predicted_character, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1.3, (0, 0, 0), 3,
                    cv2.LINE_AA)  # Muestra el carácter predicho cerca del rectángulo que rodea la mano.

    cv2.imshow('frame', frame)  # Muestra el fotograma procesado.

    if cv2.waitKey(1) == ord('e'):  # Espera una pequeña cantidad de tiempo antes de procesar el siguiente fotograma o si se presiona la tecla 'E' se sale del programa.

        break  # Sale del bucle.

cap.release()  # Libera los recursos de la cámara.
cv2.destroyAllWindows()  # Cierra todas las ventanas de visualización de imágenes.
