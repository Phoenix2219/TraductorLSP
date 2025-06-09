import os
import cv2
import mediapipe as mp
import tkinter as tk
from tkinter import simpledialog, messagebox

# Inicializa MediaPipe para detección de manos y rostro
mp_hands = mp.solutions.hands  # Inicializa la solución para la detección de manos
mp_face = mp.solutions.face_mesh  # Inicializa la solución para la detección facial
hands = mp_hands.Hands()  # Inicializa el modelo de detección de manos
face = mp_face.FaceMesh(static_image_mode=False, max_num_faces=1, refine_landmarks=True, min_detection_confidence=0.5)  # Inicializa el modelo de malla facial
mp_drawing = mp.solutions.drawing_utils  # Inicializa las utilidades para dibujar
mp_drawing_styles = mp.solutions.drawing_styles  # Inicializa los estilos para el dibujo

# Carpeta base relativa
base_dir = os.path.dirname(os.path.abspath(__file__))  # Obtiene la ruta del directorio base

def collect_sign():
    root = tk.Tk()  # Inicializa la ventana de Tkinter
    root.withdraw()  # Oculta la ventana principal

    while True:
        sign_name = simpledialog.askstring(title="Recolector de Videos", prompt="Ingresa la descripción de la seña:")  # Solicita la descripción de la seña

        if sign_name is None:  # Comprueba si el usuario cancela
            return False  # Finaliza la función si se cancela

        # Crea la ruta donde se guarda el video dentro de "data/nombre_seña/"
        output_dir = os.path.join(base_dir, 'data', sign_name)  # Define la ruta de salida

        # Verifica si la seña ya existe
        if os.path.exists(output_dir):
            messagebox.showerror("Error", f"La seña '{sign_name}' ya existe. Por favor, ingresa otra.")  # Muestra un mensaje de error si la seña ya está registrada
            continue  # Vuelve a pedir el nombre de la seña
        else:
            break  # Sale del bucle si la seña no existe

    os.makedirs(output_dir, exist_ok=True)  # Crea el directorio para la nueva seña
    output_path = os.path.join(output_dir, f'{sign_name}.avi')  # Define la ruta del archivo de video

    # Inicializa la captura de video
    cap = cv2.VideoCapture(0)  # Abre la cámara
    recording = False  # Estado inicial de grabación
    out = None  # Inicializa el objeto de escritura de video

    while cap.isOpened():  # Bucle para la captura de video
        ret, frame = cap.read()  # Lee un fotograma de la cámara
        if not ret:  # Comprueba errores en la lectura
            break  # Finaliza el bucle si no se puede leer un fotograma

        # Convierte a RGB para MediaPipe
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)  # Convierte el fotograma a formato RGB
        
        # Procesa manos y rostro
        hands_results = hands.process(frame_rgb)  # Procesa la detección de manos
        face_results = face.process(frame_rgb)  # Procesa la detección de rostro

        # Coordenadas de manos detectadas
        hands_detected = hands_results.multi_hand_landmarks is not None  # Comprueba si se detectan manos

        if hands_detected:
            # Inicia grabación si se detectan manos y no está grabando
            if not recording:
                recording = True  # Cambia el estado a grabando
                out = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc(*'XVID'), 10, (640, 480))  # Inicializa el objeto de escritura de video
            out.write(frame)  # Escribe el fotograma en el archivo de video

            # Dibuja manos detectadas
            for hand_landmarks in hands_results.multi_hand_landmarks:
                mp_drawing.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)  # Dibuja las conexiones de las manos

        else:
            # Detiene la grabación si no se detectan manos
            if recording:
                recording = False  # Cambia el estado a no grabando
                if out:
                    out.release()  # Libera el objeto de escritura de video
                    out = None  # Reinicializa el objeto de escritura
                print(f"La seña '{sign_name}' ha sido grabada correctamente.")  # Muestra mensaje de éxito en consola
                break  # Sal del bucle de captura

        # Dibuja puntos del rostro en blanco
        if face_results.multi_face_landmarks:
            for face_landmarks in face_results.multi_face_landmarks:
                # Dibuja los puntos del rostro en blanco opaco
                mp_drawing.draw_landmarks(
                    image=frame,
                    landmark_list=face_landmarks,
                    connections=mp_face.FACEMESH_TESSELATION,
                    landmark_drawing_spec=mp_drawing.DrawingSpec(color=(255, 255, 255, 255), thickness=1, circle_radius=1),  # Dibuja puntos en color blanco opaco
                    connection_drawing_spec=mp_drawing.DrawingSpec(color=(255, 255, 255, 255), thickness=1))  # Dibuja conexiones en color blanco opaco
                # Dibuja contornos de la cara en blanco
                mp_drawing.draw_landmarks(
                    image=frame,
                    landmark_list=face_landmarks,
                    connections=mp_face.FACEMESH_CONTOURS,
                    landmark_drawing_spec=mp_drawing.DrawingSpec(color=(255, 255, 255, 255), thickness=1),  # Dibuja contornos en color blanco opaco
                    connection_drawing_spec=mp_drawing_styles.get_default_face_mesh_contours_style())  # Aplica estilo por defecto a los contornos

        # Muestra la ventana de la cámara
        cv2.imshow('Recolector de Senias', frame)  # Muestra el fotograma en la ventana

        if cv2.waitKey(1) & 0xFF == ord('q'):  # Verifica si se presiona la tecla 'q' para salir
            break  # Sale del bucle de captura

    if recording and out:
        out.release()  # Libera el objeto de escritura de video si estaba grabando

    cap.release()  # Libera la cámara
    cv2.destroyAllWindows()  # Cierra todas las ventanas de OpenCV

    return True  # Finaliza la función si se captura una seña válida

def ask_for_another_sign():
    # Pregunta si se desea recolectar otra seña
    root = tk.Tk()  # Inicializa la ventana de Tkinter
    root.withdraw()  # Oculta la ventana principal
    result = messagebox.askquestion("Recolector de Señas", "¿Deseas recolectar otra seña?")  # Muestra un cuadro de diálogo para la pregunta
    return result == 'yes'  # Devuelve verdadero si se elige recolectar otra seña

def main():
    collecting = True  # Estado de recolección inicial
    while collecting:
        if collect_sign():  # Inicia la recolección de una seña
            # Pregunta si se desea recolectar otra seña
            collecting = ask_for_another_sign()  # Actualiza el estado según la respuesta
        else:
            collecting = False  # Finaliza el bucle si no se captura una seña

if __name__ == "__main__":
    main()  # Ejecuta la función principal
