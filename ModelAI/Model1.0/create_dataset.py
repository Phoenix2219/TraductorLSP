import os  # Importa el módulo "os" para interactuar con el sistema operativo.
import pickle  # Importa el módulo "pickle" para serialización de objetos.

import mediapipe as mp  # Importa la biblioteca "mediapipe" para el análisis de imágenes.
import cv2  # Importa la biblioteca "cv2" para procesamiento de imágenes y videos.

# Inicializa el modelo de detección de manos de MediaPipe.
mp_hands = mp.solutions.hands  # Inicializa la detección de manos utilizando el modelo de detección de manos de MediaPipe.

mp_drawing = mp.solutions.drawing_utils  # Proporciona utilidades para dibujar sobre imágenes con MediaPipe.

mp_drawing_styles = mp.solutions.drawing_styles  # Proporciona estilos predefinidos para dibujar sobre imágenes con MediaPipe.

hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.3)  # Inicializa el modelo de detección de manos.


DATA_DIR = './data'  # Ruta al directorio donde se encuentran los datos.

data = []  # Lista para almacenar los datos de las manos.

labels = []  # Lista para almacenar las etiquetas asociadas a los datos.


# Itera sobre los directorios en el directorio de datos.
for dir_ in os.listdir(DATA_DIR):

    # Itera sobre los archivos de imagen en el directorio actual.
    for img_path in os.listdir(os.path.join(DATA_DIR, dir_)):

        data_aux = []  # Lista auxiliar para almacenar los puntos clave de la mano.

        img = cv2.imread(os.path.join(DATA_DIR, dir_, img_path))  # Lee la imagen.

        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)  # Convierte la imagen a formato RGB.


        results = hands.process(img_rgb)  # Procesa la imagen en busca de manos.

        if results.multi_hand_landmarks:  # Si se detectan manos en la imagen.

            for hand_landmarks in results.multi_hand_landmarks:  # Itera sobre los puntos clave de la mano detectados en el fotograma.

                # Itera sobre los puntos clave de la mano detectada.
                for i in range(len(hand_landmarks.landmark)):

                    x = hand_landmarks.landmark[i].x  # Coordenada x del punto clave.

                    y = hand_landmarks.landmark[i].y  # Coordenada y del punto clave.

                    data_aux.append(x)  # Agrega la coordenada x a la lista auxiliar.

                    data_aux.append(y)  # Agrega la coordenada y a la lista auxiliar.

            data.append(data_aux)  # Agrega los puntos clave de la mano a la lista de datos.

            labels.append(dir_)  # Agrega la etiqueta asociada a los datos.

# Obtiene la longitud máxima de todas las sublistas de data.
max_length = max(len(sublist) for sublist in data)

# Ajusta todas las sublistas para que tengan la misma longitud (rellenando con ceros).
data = [sublist + [0] * (max_length - len(sublist)) for sublist in data]

# Guarda los datos y las etiquetas en un archivo pickle.
f = open('data.pickle', 'wb')  # Abre un archivo llamado 'data.pickle' en modo de escritura binaria.

pickle.dump({'data': data, 'labels': labels}, f)  # Serializa los datos y las etiquetas en el archivo utilizando el módulo pickle.

f.close()  # Cierra el archivo después de escribir los datos.

