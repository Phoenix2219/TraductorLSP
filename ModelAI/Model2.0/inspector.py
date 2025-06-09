import os
import tensorflow as tf

# Carga el modelo TFLite
base_dir = os.path.dirname(os.path.abspath(__file__))
model_dir = os.path.join(base_dir, 'sign_language_model')  # Ruta al directorio del modelo
model_p = os.path.join(model_dir, 'sign_language_model.tflite')  # Ruta al modelo
interpreter = tf.lite.Interpreter(model_path=model_p)
interpreter.allocate_tensors()

# Obtiene detalles de las tensores de entrada y salida
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("Detalles de la entrada:")
print(input_details)

print("\nDetalles de la salida:")
print(output_details)
