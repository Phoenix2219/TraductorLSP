import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/translator/presentation/provider/translator_provider.dart';
import 'package:sign_language_translator/shared/widgets/blur_container.dart';
import 'package:sign_language_translator/shared/widgets/blur_app_bar.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  late TranslatorProvider _provider;
  late ScrollController _scrollController; 
  Timer? frameTimer;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<TranslatorProvider>(context, listen: false);
    _scrollController = ScrollController(); 

    // Inicia la cámara y la captura en tiempo real
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _provider.initializeCamera();
      startRealTimeCapture();
    });
  }

  // Empieza la captura en tiempo real de frames de la cámara
  void startRealTimeCapture() {
    frameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      // Captura una imagen de la cámara en memoria sin guardarla en disco
      await _provider.takePictureAndSendToBackend();
    });
  }

  // Detiene la captura de frames
  void stopRealTimeCapture() {
    frameTimer?.cancel(); // Detiene el temporizador
  }

  @override
  void dispose() {
    stopRealTimeCapture(); // Detiene la captura en tiempo real
    _scrollController.dispose(); // Libera el controlador de scroll
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).padding.bottom;
    final idUsuario = context.select<AuthenticationProvider, int?>((prov) => prov.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.2),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(CupertinoIcons.back, size: 30)),
        title: "Traductor LSG",
        centerTitle: true,
      ),
      body: Consumer<TranslatorProvider>(
        builder: (context, provider, child) {
          if (provider.isCameraInitialized) {
            final size = MediaQuery.of(context).size;

            // Controla la posición de scroll cuando cambia el buffer
            if (provider.translationBuffer.isNotEmpty && _scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }

            return Stack(
              children: [
                // Esto aplica el transform si isFlipped es verdadero
                Transform(
                  alignment: Alignment.center,
                  transform: provider.isFlipped ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: 100,
                        child: CameraPreview(provider.cameraController!),
                      ),
                    ),
                  ),
                ),

                // Muestra la traducción en tiempo real en la parte inferior
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      buildSideButtons(colorScheme),

                      // Traducción en tiempo real
                      BlurContainer(
                        padding: EdgeInsets.only(bottom: bottom > 10 && provider.translationBuffer.isEmpty ? bottom - 5 : 0),
                        backgroundColor: colorScheme.surface.withOpacity(0.5),
                        borderRadius: 0.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(16),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: provider.translationResult,
                                  style: TextStyle(color: colorScheme.onSurface, fontSize: 24, fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: provider.confidenceResult.isNotEmpty ? "  --  " : "",
                                  style: TextStyle(color: colorScheme.onSurface, fontSize: 24, fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: provider.confidenceResult,
                                  style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center, // Alineación del texto
                          ),
                        ),
                      ),

                      // Traducción acumulada
                      if (provider.translationBuffer.isNotEmpty)
                        BlurContainer(
                          padding: EdgeInsets.only(bottom: bottom > 10 ? bottom - 5 : 0),
                          backgroundColor: colorScheme.surfaceBright.withOpacity(0.7),
                          borderRadius: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [

                                // Botón de guardar buffer
                                if (idUsuario != null && idUsuario != 0)
                                  IconButton(
                                    tooltip: "Guardar Traducción",
                                    icon: const Icon(
                                      Icons.save,
                                      color: Colors.blue,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      provider.saveTranslationBuffer(context, idUsuario);
                                    },
                                  ),

                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _scrollController,
                                    child: Text(
                                      provider.translationBuffer, // Muestra el buffer acumulado
                                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 18, fontWeight: FontWeight.w500),
                                      maxLines: 1, // Limita la cantidad de líneas
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8.0),

                                // Botón de limpiar buffer
                                IconButton(
                                  tooltip: "Limpiar Traducción",
                                  icon: Icon(
                                    Icons.backspace_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    provider.clearTranslationBuffer();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(provider.errorMessage.isEmpty ? 'Cargando cámara...' : 'Inicialización de cámara'),
            );
          }
        },
      ),
    );
  }

  Widget buildSideButtons(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
      child: Column(
        children: [
          // Botón de cambiar cámara
          BlurContainer(
            backgroundColor: colorScheme.onSecondary.withOpacity(0.5),
            child: IconButton(
              tooltip: "Cambiar Cámara",
              icon: Icon(Icons.cameraswitch, size: 25, color: colorScheme.onSurface),
              onPressed: () async {
                // Cambia entre las cámaras disponibles
                await _provider.switchCamera();
              },
            ),
          ),
      
          const SizedBox(height: 10),
      
          // Botón de invertir perspectiva
          BlurContainer(
            backgroundColor: colorScheme.onSecondary.withOpacity(0.5),
            child: IconButton(
              tooltip: "Invertir Cámara",
              icon: Icon(Icons.flip, size: 25, color: colorScheme.onSurface),
              onPressed: () {
                // Cambia la perspectiva de la cámara (invierte horizontalmente)
                _provider.toggleFlip();
              },
            ),
          ),
      
          const SizedBox(height: 10),
      
          // Botón de silenciar
          BlurContainer(
            backgroundColor: colorScheme.onSecondary.withOpacity(0.5),
            child: IconButton(
              tooltip: "Silenciar / Escuchar",
              icon: Icon(_provider.isMuted ? Icons.volume_off : Icons.volume_up, color: colorScheme.onSurface, size: 25),
              onPressed: () {
                setState(() {
                  _provider.isMuted =
                      !_provider.isMuted; // Cambia el estado de mute
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
