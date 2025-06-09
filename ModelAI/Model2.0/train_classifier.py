import os
import numpy as np
import tensorflow as tf

# Define la constante de los puntos clave
NUM_HAND_LANDMARKS = 21  # Cada mano tiene 21 puntos clave

# Define la carpeta base y las rutas
base_dir = os.path.dirname(os.path.abspath(__file__))  
data_dir = os.path.join(base_dir, 'sign_language_dataset', 'sign_language_dataset.npz')  
model_dir = os.path.join(base_dir, 'sign_language_model')
labels_file = os.path.join(base_dir, 'sign_language_dataset', 'labels.txt')

def load_dataset():
    if not os.path.exists(data_dir):
        print(f"Error: El archivo de dataset '{data_dir}' no existe.")
        return None, None

    data = np.load(data_dir)
    dataset = data['dataset']
    labels = data['labels']
    return dataset, labels

def create_model(num_classes):
    model = tf.keras.Sequential([  # Define el modelo secuencial
        tf.keras.layers.Input(shape=(NUM_HAND_LANDMARKS * 2 * 3,)),  # Ajusta la forma de entrada a la cantidad de puntos clave (42 puntos clave por 3 coordenadas)
        tf.keras.layers.Dense(512, activation='relu'), # 512 neuronas, Capas de neuronas densas, RELU para introducir no linealidades (para que no vaya aprendiendo de forma lineal sino haga relaciones complejas)
        tf.keras.layers.Dense(256, activation='relu'), # 256 neuronas
        tf.keras.layers.Dense(128, activation='relu'), # 128 neuronas
        tf.keras.layers.Dense(num_classes, activation='softmax')  # Salida con activación softmax (Para que las salidas sean probabilidades)
    ])

    model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
    return model

def train_model(dataset, labels, model=None):
    num_classes = len(set(labels))  # Determina el número de clases

    if model is None:
        model = create_model(num_classes)  # Crea el modelo si no se pasa uno existente

    print("Tipo de labels:", type(labels))
    print("Shape de labels:", labels.shape)
    print("Valores únicos en labels:", np.unique(labels))
    print("Tipo de datos en labels:", labels.dtype)
    print("Máximo valor en labels:", np.max(labels))

    dataset = np.array(dataset, dtype=np.float32)
    labels = np.array(labels, dtype=np.int32)

    # Entrenamiento del modelo
    model.fit(dataset, labels, epochs=50, validation_split=0.2, batch_size=32) # 50 epocas (repeticiones), 20% de los datos se usará para validación, se procesan 32 muestras a la vez

    os.makedirs(model_dir, exist_ok=True)  
    # Guarda el modelo en formato .keras
    model.save(os.path.join(model_dir, 'sign_language_model.keras'))
    print("Modelo entrenado y guardado correctamente en formato .keras.")

    # Convierte el modelo a TFLite
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()

    # Guarda el modelo TFLite
    with open(os.path.join(model_dir, 'sign_language_model.tflite'), 'wb') as f:
        f.write(tflite_model)
    print("Modelo exportado a TFLite correctamente.")


def main():
    dataset, labels = load_dataset()
    if dataset is not None and labels is not None:
        choice = input("Deseas entrenar desde cero (0) o continuar un modelo existente (1)? ")
        if choice == '0':
            train_model(dataset, labels)
        else:
            print("Modelo existente cargado. ¡Listo para realizar predicciones!")
    else:
        print("No se pudo cargar el dataset.")

if __name__ == "__main__":
    main()
