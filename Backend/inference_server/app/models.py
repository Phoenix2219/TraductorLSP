class ModeloAI:
    def __init__(self, id_modelo, version, contenido, fecha_entrenamiento, rol):
        self.id_modelo = id_modelo
        self.version = version
        self.contenido = contenido
        self.fecha_entrenamiento = fecha_entrenamiento
        self.rol = rol

class Usuario:
    def __init__(self, id_usuario, nombre, apellido, correo, contrasenia, rol):
        self.id_usuario = id_usuario
        self.nombre = nombre
        self.apellido = apellido
        self.correo = correo
        self.contrasenia = contrasenia
        self.rol = rol

class Traduccion:
    def __init__(self, id_traduccion, texto_traducido, gesto_capturado, fecha, precision, id_usuario, id_modelo):
        self.id_traduccion = id_traduccion
        self.texto_traducido = texto_traducido
        self.gesto_capturado = gesto_capturado
        self.fecha = fecha
        self.precision = precision
        self.id_usuario = id_usuario
        self.id_modelo = id_modelo
