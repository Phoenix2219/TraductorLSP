# Traductor LSG
Diseño, Desarrollo E Implementación De  Un Sistema Traductor De Lengua  De Señas Guatemalteco En Tiempo Real  Por Medio De Inteligencia Artificial  Para Personas Con Discapacidad Auditiva

## Índice

- [Instalación de la App Android](#instalación-de-la-app-android)
- [Instrucciones para el Modelo AI](#instrucciones-para-el-modelo-ai)
- [Ejecución del Frontend en Flutter](#ejecución-del-frontend-en-flutter)
- [Ejecución del Backend](#ejecución-del-backend)
  
## Funcionalidades principales

- **Reconocimiento de señas en tiempo real**: Traducción automática de señas capturadas por la cámara a texto.
- **Interfaz de usuario**: Pantalla interactiva que muestra las traducciones en tiempo real.
- **Acceso de usuario**: Al iniciar puede requerir un usuario "admin" con la contraseña "admin" para acceder a toda la funcionalidad.

## Instalación de la App Android

### Prerrequisitos

- **Android Studio** o un dispositivo **Android** con habilitación de instalación de apps externas.
- **APK**: El archivo de la app se proporciona como un APK para instalación directa.

### Pasos para instalar la aplicación

1. **Descargar el APK**: 
   - Descargar el archivo APK directamente desde [aquí](app-release.apk) (Descargar app-release.apk) o compilar la app desde el código fuente utilizando Android Studio con Flutter.

2. **Habilitar instalación desde fuentes desconocidas (En caso no este habilitado aún)**:
   - Ir a **Configuración** -> **Seguridad** -> **Instalar aplicaciones desconocidas** (puede variar según la versión de Android).
   - Habilitar la opción para permitir la instalación desde tu navegador o la carpeta donde se ha descargado el APK.

3. **Instalar el APK**:
   - Abrir el archivo APK descargado en el dispositivo.
   - Tocar el botón de instalación y seguir las instrucciones en pantalla.

4. **Acceso de usuario**:
   - Al iniciar la app puede que pida para ingresar un usuario y contraseña.
   - Use las siguientes credenciales para acceder a todas las funcionalidades:
     - **Usuario**: `admin@admin.com`
     - **Contraseña**: `admin`
   
  - Credenciales de un usuario normal:
    - **Usuario**: `user@gmail.com`
    - **Contraseña**: `user` 

5. **Uso de la app**:
   - Una vez que haya iniciado sesión, podrá comenzar a usar la funcionalidad de traducción de lengua de señas en tiempo real colocando señas frente a la cámara, se podrá observar su traducción en tiempo real y con voz. Se pueden encontrar más instrucciones al tocar los botones dentro de la App.

## Requisitos adicionales

- La aplicación requiere un dispositivo con **cámara** para detectar las señas e **internet**.
- Asegúrate de que la aplicación tenga permisos para acceder a la cámara de tu dispositivo.

## Instrucciones para el Modelo AI
El modelo AI se encuentra en el directorio `ModelAI/Model2.0`. Para ejecutar el sistema de traducción basado en inteligencia artificial, hay que seguir los siguientes pasos:

### 1. Instalar dependencias

Primero, hay que asegurarse de que esté Python instalado. Luego, ejecutar el siguiente comando para instalar todas las dependencias del archivo `requirements.txt`:

```bash
pip install -r ModelAI/Model2.0/requirements.txt
```

### 2. Recolectar imágenes

Si se desea recolectar nuevas imágenes para el conjunto de datos, ejecutar el siguiente script:

```bash
python ModelAI/Model2.0/collect_imgs.py
```

### 3. Crear el conjunto de datos

Para generar el conjunto de datos a partir de las imágenes recolectadas, ejecutar el siguiente comando:

```bash
python ModelAI/Model2.0/create_dataset.py
```

### 4. Entrenar el modelo

Para entrenar el modelo de clasificación con el conjunto de datos generado, ejecutar el siguiente comando:

```bash
python ModelAI/Model2.0/train_classifier.py
```

### 5. Realizar inferencias o probar el modelo

Si se desea probar el modelo o realizar inferencias sobre un nuevo conjunto de datos, se puede ejecutar el siguiente script:

```bash
python ModelAI/Model2.0/inference_classifier.py
```

## Ejecución del Frontend en Flutter
El frontend de este proyecto está desarrollado en Flutter. Si se desea visualizar la interfaz gráfica y probar el sistema, se debe tener descargado [Flutter]([app-release.apk](https://docs.flutter.dev/get-started/install?_gl=1*qfiir3*_gcl_aw*R0NMLjE3MjkzMTkwNDIuQ2p3S0NBandqc2k0QmhCNUVpd0FGQUwwWUJ3ekpMUVJMYmpDX0R5NDdJMGpnU3lhdHlYYUZuVkFQbjc2WFlsTHhZN1RhUVl2cE5XT3dCb0N3U1VRQXZEX0J3RQ..*_gcl_dc*R0NMLjE3MjkzMTkwNDIuQ2p3S0NBandqc2k0QmhCNUVpd0FGQUwwWUJ3ekpMUVJMYmpDX0R5NDdJMGpnU3lhdHlYYUZuVkFQbjc2WFlsTHhZN1RhUVl2cE5XT3dCb0N3U1VRQXZEX0J3RQ..*_up*MQ..*_ga*MTM0ODE2Nzk3MS4xNzA0Nzc1Njgx*_ga_04YGWK0175*MTcyOTMxOTA0MS41OS4wLjE3MjkzMTkwNDEuMC4wLjA.&gclid=CjwKCAjwjsi4BhB5EiwAFAL0YBwzJLQRLbjC_Dy47I0jgSyatyXaFnVAPn76XYlLxY7TaQYvpNWOwBoCwSUQAvD_BwE&gclsrc=aw.ds)) y seguir estos pasos:

### 1. Dirigirse al directorio del frontend

Navegar al directorio del frontend:

```bash
cd Frontend/sign_language_translator
```

### 2. Instalar dependencias de Flutter

Instalar las dependencias necesarias ejecutando el siguiente comando:

```bash
flutter pub get
```

### 3. Ejecutar la aplicación Flutter

Para iniciar la aplicación en un dispositivo o emulador Android, ejecutar el siguiente comando:

```bash
flutter run
```

### Requisitos

- Flutter: Versión 3.24.3 o superior
- Dart: Versión 3.5.3 o superior
- Dispositivo Android: Debe estar conectado y configurado para depuración


## Ejecución del Backend
El backend de este sistema se encarga de procesar las inferencias y está desarrollado en Python. Seguir estos pasos para iniciar el servidor:

### 1. Instalar dependencias

Primero, hay que asegurarse de que esté Python instalado. Luego, ejecutar el siguiente comando para instalar todas las dependencias del archivo `requirements.txt`:

```bash
pip install -r Backend/inference_server/requirements.txt
```

### 2. Dirigirse al directorio del backend

Navegar al directorio del backend:

```bash
cd Backend/inference_server/app
```


### 3. Ejecutar el servidor

Para iniciar el servidor, ejecutar el siguiente script:

```bash
python server.py
```

### 4. Desplegar el servidor con Ngrok (Opcional para la app)

Para usar la app, es mejor usar el servicio de despliegue de [ngrok](https://dashboard.ngrok.com/get-started/setup/windows) y pasar esa url en las conexiones de la app para conectarse de manera segura.
En la consola POWERSHELL ejecutar ngrok:

```bash
ngrok http 5000
```

### 5. Crear la firma del apk

Los demas datos estan en Frontend/sign_language_translator/android/app/build.gradle y Frontend/sign_language_translator/android/key.properties

```bash
keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias keyAlias
```

