import jwt
import datetime
from flask import Blueprint, request, jsonify, current_app
from database import init_db
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
import bcrypt

app = Blueprint('api', __name__)

SECRET_KEY = 'apisecret'

def get_db_connection():
    return init_db(current_app)

# Rutas para el modelo AI
@app.route('/modelos', methods=['POST'])
def create_modelo():
    data = request.json
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('''INSERT INTO modeloai (version, contenido, fecha_entrenamiento, rol) 
                                  VALUES (%s, %s, %s, %s)''', 
                               (data['version'], data['contenido'], data['fecha_entrenamiento'], data['rol']))
                conn.commit()
        return jsonify({"message": "Modelo creado"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/modelos', methods=['GET'])
def get_modelos():
    try:
        with get_db_connection() as conn:
            with conn.cursor(dictionary=True) as cursor:
                cursor.execute('SELECT * FROM modeloai ORDER BY fecha_modificacion DESC')
                modelos = cursor.fetchall()
        return jsonify(modelos), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/modelos/<int:id>', methods=['PUT'])
def update_modelo(id):
    data = request.json
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('''UPDATE modeloai SET version=%s, contenido=%s, fecha_entrenamiento=%s, rol=%s 
                                  WHERE id_modelo=%s''', 
                               (data['version'], data['contenido'], data['fecha_entrenamiento'], data['rol'], id))
                conn.commit()
        return jsonify({"message": "Modelo actualizado"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/modelos/<int:id>', methods=['DELETE'])
def delete_modelo(id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('DELETE FROM modeloai WHERE id_modelo=%s', (id,))
                conn.commit()
        return jsonify({"message": "Modelo eliminado"}), 204
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Rutas para el usuario
@app.route('/usuarios', methods=['POST'])
def create_usuario():
    data = request.json
    correo = data['correo']
    password = data['contrasenia']
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('SELECT * FROM usuario WHERE correo = %s', (correo,))
                existing_user = cursor.fetchone()

                if existing_user:
                    return jsonify({"error": "El correo ya está registrado"}), 409

                cursor.execute('''INSERT INTO usuario (nombre, apellido, correo, contrasenia, rol) 
                                  VALUES (%s, %s, %s, %s, %s)''', 
                               (data['nombre'], data['apellido'], data['correo'], hashed_password, data['rol']))
                conn.commit()
        return jsonify({"message": "Usuario creado"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/usuarios', methods=['GET'])
def get_usuarios():
    try:
        with get_db_connection() as conn:
            with conn.cursor(dictionary=True) as cursor:
                cursor.execute('SELECT * FROM usuario ORDER BY fecha_modificacion DESC')
                usuarios = cursor.fetchall()
        return jsonify(usuarios), 200
    except Exception as e:
        return jsonify({"error": "Hubo un error inesperado en el servidor"}), 500

@app.route('/usuarios/<int:id>', methods=['PUT'])
def update_usuario(id):
    data = request.json
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('''UPDATE usuario SET nombre=%s, apellido=%s, correo=%s, rol=%s, imagen=%s  
                                  WHERE id_usuario=%s''', 
                               (data['nombre'], data['apellido'], data['correo'], data['rol'], data['imagen'], id))
                conn.commit()
        return jsonify({"message": "Usuario actualizado"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/usuarios/<int:id>', methods=['DELETE'])
def delete_usuario(id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('DELETE FROM usuario WHERE id_usuario=%s', (id,))
                conn.commit()
        return jsonify({"message": "Usuario eliminado"}), 204
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Función para generar un token JWT
def generate_token(usuario_id):
    token = jwt.encode({
        'id_usuario': usuario_id,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)  # Token expira en 1 hora
    }, SECRET_KEY, algorithm='HS256')
    return token

# Ruta de login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('SELECT * FROM usuario WHERE correo=%s', (data['correo'],))
                usuario = cursor.fetchone()

                if usuario:
                    stored_password = usuario[4]  # Contraseña almacenada

                    try:
                        # Intentamos comparar con bcrypt, si la contraseña es cifrada
                        if bcrypt.checkpw(data['contrasenia'].encode('utf-8'), stored_password.encode('utf-8')):
                            token = generate_token(usuario[0])
                            return jsonify({
                                "token": token, 
                                "id": usuario[0], 
                                "nombre": usuario[1], 
                                "apellido": usuario[2], 
                                "correo": usuario[3], 
                                "rol": usuario[5], 
                                "imagen": usuario[6]
                            }), 200
                    except ValueError:
                        # Si ocurre un ValueError es porque no es un hash de bcrypt
                        # Entonces comparamos directamente con la contraseña en texto claro
                        if stored_password == data['contrasenia']:
                            token = generate_token(usuario[0])
                            return jsonify({
                                "token": token, 
                                "id": usuario[0], 
                                "nombre": usuario[1], 
                                "apellido": usuario[2], 
                                "correo": usuario[3], 
                                "rol": usuario[5], 
                                "imagen": usuario[6]
                            }), 200
                            
        return jsonify({"message": "Credenciales inválidas"}), 401
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Ruta protegida
@app.route('/protected', methods=['GET'])
def protected():
    token = request.headers.get('Authorization').split(" ")[1]  # Se espera el formato 'Bearer <token>'
    try:
        data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return jsonify({"message": "Token válido", "id_usuario": data['id_usuario']}), 200
    except jwt.ExpiredSignatureError:
        return jsonify({"message": "Token expirado"}), 401
    except jwt.InvalidTokenError:
        return jsonify({"message": "Token inválido"}), 401

# Rutas para la traducción
@app.route('/traducciones', methods=['POST'])
def create_traduccion():
    data = request.json
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('''INSERT INTO traduccion (texto_traducido, gesto_capturado, fecha, `precision`, id_usuario, id_modelo) 
                                  VALUES (%s, %s, %s, %s, %s, %s)''', 
                               (data['texto_traducido'], data['gesto_capturado'], data['fecha'], data['precision'], data['id_usuario'], data['id_modelo']))
                conn.commit()
        return jsonify({"message": "Traducción creada"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/traducciones', methods=['GET'])
def get_traducciones():
    id_usuario = request.args.get('id_usuario')
    try:
        with get_db_connection() as conn:
            with conn.cursor(dictionary=True) as cursor:
                if id_usuario:
                    cursor.execute('SELECT * FROM traduccion WHERE id_usuario = %s ORDER BY fecha_modificacion DESC', (id_usuario,))
                else:
                    cursor.execute('SELECT * FROM traduccion ORDER BY fecha_modificacion DESC')
                traducciones = cursor.fetchall()
        return jsonify(traducciones), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/traducciones/<int:id>', methods=['PUT'])
def update_traduccion(id):
    data = request.json
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('''UPDATE traduccion SET texto_traducido=%s, gesto_capturado=%s, fecha=%s, `precision`=%s, id_usuario=%s, id_modelo=%s 
                                  WHERE id_traduccion=%s''', 
                               (data['texto_traducido'], data['gesto_capturado'], data['fecha'], data['precision'], data['id_usuario'], data['id_modelo'], id))
                conn.commit()
        return jsonify({"message": "Traducción actualizada"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/traducciones/<int:id>', methods=['DELETE'])
def delete_traduccion(id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('DELETE FROM traduccion WHERE id_traduccion=%s', (id,))
                conn.commit()
        return jsonify({"message": "Traducción eliminada"}), 204
    except Exception as e:
        return jsonify({"error": str(e)}), 500

