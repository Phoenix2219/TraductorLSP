import os
import numpy as np
from PIL import Image
import mediapipe as mp
import cv2

# Inicializa el modelo de detección de manos de MediaPipe
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.5)
 
# Define las rutas para los datos y el conjunto de datos
base_dir = os.path.dirname(os.path.abspath(__file__))
data_dir = os.path.join(base_dir, 'data')  # Ruta de los videos e imágenes
output_dir = os.path.join(base_dir, 'sign_language_dataset')  # Ruta para el dataset generado
labels_file = os.path.join(output_dir, 'labels.txt')  # Archivo para guardar etiquetas

# Cantidad fija de puntos clave (21 puntos por cada mano)
NUM_HAND_LANDMARKS = 21  # Cada mano tiene 21 puntos clave

def create_dataset():
    dataset = []  # Lista para almacenar los landmarks detectados
    labels = []   # Lista para almacenar las etiquetas de las señas

    # Verifica si el directorio de datos existe
    if not os.path.exists(data_dir):
        print(f"Error: El directorio de datos '{data_dir}' no existe.")
        return

    # Crea el directorio de salida si no existe
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Recorre las carpetas de las señas
    for sign_name in os.listdir(data_dir):
        sign_path = os.path.join(data_dir, sign_name)
        if os.path.isdir(sign_path):
            # Procesa los archivos de video
            for video_name in os.listdir(sign_path):
                video_path = os.path.join(sign_path, video_name)
                if video_name.endswith('.avi'):
                    cap = cv2.VideoCapture(video_path)
                    if not cap.isOpened():
                        print(f"Error al abrir el video: {video_path}")
                        continue

                    # Lee el video frame por frame
                    while cap.isOpened():
                        ret, frame = cap.read()
                        if not ret:
                            break

                        # Convierte el frame a RGB y procesa con MediaPipe
                        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                        results = hands.process(frame_rgb)

                        # Rellenar con ceros en caso de no detectar puntos
                        landmarks = np.zeros((NUM_HAND_LANDMARKS * 2, 3))  # Solo 2 manos

                        # Asigna puntos detectados a las manos
                        if results.multi_hand_landmarks:
                            for i, hand_landmarks in enumerate(results.multi_hand_landmarks):
                                landmarks_data = np.array([(lm.x, lm.y, lm.z) for lm in hand_landmarks.landmark])
                                
                                # Asigna los puntos clave a las posiciones correspondientes en función de si es la primera o segunda mano.
                                if i == 0:  # Primera mano
                                    landmarks[:NUM_HAND_LANDMARKS] = landmarks_data
                                elif i == 1:  # Segunda mano
                                    landmarks[NUM_HAND_LANDMARKS:] = landmarks_data

                        # Verificación de la detección de puntos
                        if np.count_nonzero(landmarks) > 0:
                            print(f"Landmarks detectados para la seña '{sign_name}' en el video '{video_name}'")
                            dataset.append(landmarks.flatten())  # Agrega los puntos clave al dataset, convierte antes los puntos clave en un arreglo de 1 dimensión
                            labels.append(sign_name)  # Agrega la etiqueta de la seña
                        else:
                            print(f"Advertencia: Puntos clave incompletos en el video de la seña '{sign_name}'")
                    cap.release()

            # Procesa imágenes en la subcarpeta
            for image_name in os.listdir(sign_path):
                image_path = os.path.join(sign_path, image_name)
                if image_name.endswith(('.png', '.jpg', '.jpeg')):  # Verifica que sea una imagen
                    if not os.path.isfile(image_path):
                        print(f"Archivo de imagen no encontrado: {image_path}")
                        continue

                    try:
                        # Abre y procesa la imagen con MediaPipe
                        img = Image.open(image_path)
                        img = img.convert('RGB')  # Convierte la imagen a RGB
                        img_rgb = np.array(img)

                        results = hands.process(img_rgb)

                        # Rellenar con ceros en caso de no detectar puntos
                        landmarks = np.zeros((NUM_HAND_LANDMARKS * 2, 3))  # Solo 2 manos

                        # Asigna puntos detectados a las manos
                        if results.multi_hand_landmarks:
                            for i, hand_landmarks in enumerate(results.multi_hand_landmarks):
                                landmarks_data = np.array([(lm.x, lm.y, lm.z) for lm in hand_landmarks.landmark])
                                
                                # Asigna los puntos clave a las posiciones correspondientes en función de si es la primera o segunda mano.
                                if i == 0:  # Primera mano
                                    landmarks[:NUM_HAND_LANDMARKS] = landmarks_data
                                elif i == 1:  # Segunda mano
                                    landmarks[NUM_HAND_LANDMARKS:] = landmarks_data

                        # Verifica que los landmarks se hayan detectado correctamente
                        if np.count_nonzero(landmarks) > 0:
                            print(f"Landmarks detectados para la seña '{sign_name}' en la imagen '{image_name}'")
                            dataset.append(landmarks.flatten())  # Agrega los puntos clave al dataset
                            labels.append(sign_name)  # Agrega la etiqueta de la seña
                        else:
                            print(f"Advertencia: Puntos clave incompletos en la imagen de la seña '{sign_name}'")

                    except Exception as e:
                        print(f"Error al cargar la imagen: {image_path}. Error: {e}")

    # Verifica si se han detectado datos para guardar
    if len(dataset) > 0:
        dataset = np.vstack(dataset)  # Apila las matrices de landmarks verticalmente
        labels = np.array(labels)  # Convierte las etiquetas en un array

        # Asigna un índice a cada etiqueta
        label_to_index = {label: index for index, label in enumerate(sorted(set(labels)))}
        indices = np.array([label_to_index[label] for label in labels])

        # Guarda las etiquetas en un archivo
        with open(labels_file, 'w') as f:
            for label in sorted(label_to_index.keys()):
                f.write(f"{label}\n")
        print(f"Archivo de etiquetas guardado en '{labels_file}'.")

        # Guarda el dataset en un archivo .npz
        np.savez(os.path.join(output_dir, 'sign_language_dataset.npz'), dataset=dataset, labels=indices)
        print("Dataset creado y guardado correctamente.")
    else:
        print("Error: El dataset está vacío. No se puede guardar.")

if __name__ == "__main__":
    create_dataset()
