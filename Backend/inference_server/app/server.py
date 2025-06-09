from flask import Flask, request, jsonify
from database import init_db
from routes import app as api
import numpy as np
import cv2
from inference import preprocess_image, make_inference

app = Flask(__name__)
db_connection = init_db(app) # Inicializa la base de datos

# Registra las rutas
app.register_blueprint(api)

@app.route('/infer', methods=['POST'])
def infer():
    """Recibe una imagen en formato multipart y devuelve la predicción en JSON."""
    if 'image' not in request.files:
        return jsonify({"error": "No image part"}), 400

    file = request.files['image']
    
    # Verifica si el archivo es válido  
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    print(f"Imagen recibida: {file.filename}")

    # Lee la imagen y la convierte en un formato que OpenCV pueda procesar
    img = file.read()
    np_arr = np.frombuffer(img, np.uint8)
    frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    # Preprocesa la imagen
    landmarks = preprocess_image(frame)

    # Hace la inferencia
    result = make_inference(landmarks)

    # Envia el resultado en formato JSON
    return jsonify(result)

@app.route('/')
def index():
    return 'Servidor Flask en funcionamiento'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
