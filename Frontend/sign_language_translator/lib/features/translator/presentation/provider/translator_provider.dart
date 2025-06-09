import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:sign_language_translator/core/constants/constants.dart';

class TranslatorProvider with ChangeNotifier {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  int currentCameraIndex = 0;
  bool isCameraInitialized = false;
  String errorMessage = '';
  String translationResult = '';
  String confidenceResult = '';
  bool isFlipped = false; // Para determinar si la imagen debe ser invertida
  bool isMuted = false;
  FlutterTts flutterTts = FlutterTts(); 
  String translationBuffer = '';
  String confidenceBuffer = '';
  bool spaceAdded = false; 

  // Inicializa la cámara
  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        errorMessage = 'No se encontraron cámaras disponibles';
        notifyListeners();
        return;
      }

       if (cameraController != null) {
        await cameraController!.dispose();
      }

      cameraController = CameraController(
        cameras![currentCameraIndex], 
        ResolutionPreset.medium,
      );

      await cameraController!.initialize();
      isCameraInitialized = true;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al inicializar la cámara: $e';
      notifyListeners();
    }
  }

  // Cambia entre las cámaras disponibles
  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) {
      errorMessage = 'No hay más cámaras disponibles';
      notifyListeners();
      return;
    }

    // Desactiva la cámara actual
    await cameraController?.dispose();
    isCameraInitialized = false;
    notifyListeners();

    // Espera un breve momento para asegurarte de que la cámara se haya cerrado completamente
    await Future.delayed(const Duration(milliseconds: 500));

    // Cambia al siguiente índice de cámara
    currentCameraIndex = (currentCameraIndex + 1) % cameras!.length;

    // Reinicializa el controlador de la nueva cámara
    cameraController = CameraController(
      cameras![currentCameraIndex],
      ResolutionPreset.medium,
    );

    try {
      await cameraController!.initialize();
      isCameraInitialized = true;
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error al cambiar la cámara: $e';
      isCameraInitialized = false;
    }

    notifyListeners();
  }

  // Cambia la perspectiva de la imagen (invertir horizontalmente)
  void toggleFlip() {
    isFlipped = !isFlipped;
    notifyListeners();
  }

  // Captura la imagen y la envía al backend sin guardarla en disco
  Future<void> takePictureAndSendToBackend() async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        // Captura la imagen directamente en memoria
        XFile picture = await cameraController!.takePicture();
        Uint8List imageBytes = await picture.readAsBytes(); // Captura en memoria

        // Decodifica la imagen en memoria usando el paquete 'image'
        img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
        if (image == null) {
          errorMessage = 'Error al decodificar la imagen';
          notifyListeners();
          return;
        }

        // Si isFlipped es verdadero, invierte horizontalmente la imagen
        if (isFlipped) {
          image = flipImageHorizontally(image);  // Usamos la función para invertir la imagen
        }

        // Convertimos la imagen modificada a bytes para enviarla al servidor
        imageBytes = Uint8List.fromList(img.encodeJpg(image));

        // Envía la imagen al backend
        await sendImageToBackend(imageBytes);
      }
    } catch (e) {
      errorMessage = 'Error al capturar la imagen: $e';
      notifyListeners();
    }
  }

  // Método para invertir la imagen horizontalmente
  img.Image flipImageHorizontally(img.Image image) {
    img.Image flipped = img.Image(width: image.width, height: image.height);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        flipped.setPixel(image.width - x - 1, y, image.getPixel(x, y));
      }
    }
    return flipped;
  }

  // Envia imagen al backend
  Future<void> sendImageToBackend(Uint8List imageBytes) async {
    try {
      String url = '$baseAIUrl/infer';

      print("Enviando solicitud POST a $url con una imagen de ${imageBytes.lengthInBytes} bytes");

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Se agrega el archivo de imagen
      request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg'));

      print("Imagen añadida al request");

      var response = await request.send();

      print("Código de respuesta: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        print("Respuesta del servidor: ${responseData.body}");

        var decodedResponse = json.decode(responseData.body);
        translationResult = decodedResponse['prediction'] ?? 'Sin traducción';
        double confidenceDouble = decodedResponse['confidence'] ?? 0.0;
        confidenceResult = confidenceDouble > 0 ? "${decodedResponse['confidence'].toStringAsFixed(2)}%" : '';

        // Acumula la traducción en el buffer, agregando un espacio si es necesario
        updateTranslation(translationResult, confidenceDouble);

        // Reproduce sonido si no está silenciado y hay un resultado
        if (!isMuted && translationResult.isNotEmpty && translationResult != "No se detectó la mano" && translationResult != "Esperando traducción" && translationResult != "Sin traducción") {
          _speakTranslation(translationResult); 
        }

      } else {
        translationResult = 'Esperando traducción';
        print('Error en la traducción: Código ${response.statusCode}');
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al enviar la imagen: $e';
      notifyListeners();
    }
  }

  void updateTranslation(String translationResult, double confidenceDouble) {
    // Si no se detecta la mano y el espacio aún no ha sido agregado
    if (translationResult == "No se detectó la mano" && !spaceAdded) {
      translationBuffer += ' '; // Agrega un espacio solo si no se ha agregado antes
      confidenceBuffer += ' ';
      spaceAdded = true; // Marca que ya se ha agregado un espacio
    } 
    // Si se detecta una traducción, agrega el texto al buffer
    else if (translationResult != "No se detectó la mano") {
      translationBuffer += translationResult; 
      confidenceBuffer += confidenceDouble.toString();
      spaceAdded = false; // Resetea la bandera si se detecta una traducción válida
    }
    
    notifyListeners();
  }

  // Método para limpiar el buffer de traducción
  void clearTranslationBuffer() {
    translationBuffer = ''; 
    confidenceBuffer = '';
    notifyListeners();
  }

  // Método para guardar el buffer de traducción
Future<void> saveTranslationBuffer(BuildContext context, int idUser) async {
    // Extraemos los datos del buffer y preparamos los campos necesarios
    String textoTraducido = translationBuffer;
    String gestoCapturado = translationBuffer.trim().isNotEmpty 
        ? translationBuffer.trim().split(' ').last 
        : '';

    String precision = confidenceBuffer;
    String fecha = DateTime.now().toIso8601String().split('T').first; // Formato 'YYYY-MM-DD'
    int idUsuario = idUser;
    int idModelo = 2;

    // Si el buffer está vacío, no hace nada
    if (textoTraducido.isEmpty || precision.isEmpty) {
      showDialogMessage(context, "Aviso", "No hay datos para guardar.");
      return;
    }

    // Construye el cuerpo de la solicitud
    Map<String, dynamic> body = {
      "texto_traducido": textoTraducido,
      "gesto_capturado": gestoCapturado,
      "fecha": fecha,
      "precision": precision,
      "id_usuario": idUsuario,
      "id_modelo": idModelo
    };

    try {
      String url = '$baseAPIUrl/traducciones';

      // Solicitud POST al backend
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        
        if (context.mounted) {
          showDialogMessage(context, "Éxito", "Traducción guardada con éxito.");
        }

        clearTranslationBuffer(); // Limpiar el buffer tras guardar
      } else {

        if (context.mounted) {
          showDialogMessage(context, "Error", "Error al guardar la traducción.");
        }

        print('Error al guardar la traducción: ${response.body}');
      }
    } catch (e) {
      print('Error al enviar la traducción al backend: $e');
    }
  }


  // Método para reproducir el texto como voz en un hilo separado
  Future<void> _speakTranslation(String text) async {
    await Future.delayed(const Duration(milliseconds: 100));  // Para evitar bloqueo
    await flutterTts.speak(text);
  }

  showDialogMessage(BuildContext context, title, message) {
    // Muestra el popup de éxito
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el dialogo
                  },
                ),
              ],
            );
          },
        );
      }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
