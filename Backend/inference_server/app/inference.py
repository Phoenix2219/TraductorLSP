import os
import cv2
import numpy as np
import tensorflow as tf
import mediapipe as mp

# Definiciones
NUM_HAND_LANDMARKS = 21  # Cada mano tiene 21 puntos clave

# Inicializa el modelo de detección de manos de MediaPipe
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.5)
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles

# Ruta del modelo .keras
model_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../sign_language_model', 'sign_language_model.keras')

# Carga el modelo Keras
model = tf.keras.models.load_model(model_path)

# Carga las etiquetas
labels_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../sign_language_model', 'labels.txt')
with open(labels_file, 'r') as f:
    labels = f.read().splitlines()

def preprocess_image(image):
    """Procesa la imagen enviada por Flutter y devuelve los landmarks detectados."""
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    results = hands.process(image_rgb)
    
    landmarks = np.zeros((NUM_HAND_LANDMARKS * 2, 3))  # Para 2 manos, cada una con 21 puntos
    
    if results.multi_hand_landmarks:
        for i, hand_landmarks in enumerate(results.multi_hand_landmarks):
            landmarks_data = np.array([(lm.x, lm.y, lm.z) for lm in hand_landmarks.landmark])
            if i == 0:
                landmarks[:NUM_HAND_LANDMARKS] = landmarks_data
            elif i == 1:
                landmarks[NUM_HAND_LANDMARKS:] = landmarks_data
    
    return landmarks.flatten()

def make_inference(landmarks):
    """Hace la inferencia usando el modelo Keras."""
    if np.count_nonzero(landmarks) > 0:
        landmarks = landmarks.reshape(1, -1)
        predictions = model.predict(landmarks)
        predicted_class = np.argmax(predictions, axis=1)[0]
        predicted_label = labels[predicted_class]
        confidence = np.max(predictions) * 100
        return {"prediction": predicted_label, "confidence": confidence}
    else:
        return {"prediction": "No se detectó la mano", "confidence": 0.0}
