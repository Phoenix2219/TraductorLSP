import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/saved_translations/presentation/provider/saved_translations_provider.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';
import 'package:intl/intl.dart';

class SavedTranslationsScreen extends StatelessWidget {
  const SavedTranslationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rol = context.select<AuthenticationProvider, String?>((prov) => prov.rol);
    final userID = context.select<AuthenticationProvider, int?>((prov) => prov.id);

    // Lista de colores
    final List<Color> colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.surfaceContainer,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
    ];

    final List<Color> textColors = [
      colorScheme.onPrimary,
      colorScheme.onSecondary,
      colorScheme.onTertiary,
      colorScheme.onSurfaceVariant,
      colorScheme.onPrimaryContainer,
      colorScheme.onSecondaryContainer,
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildTranslationsSuperAppBar(colorScheme, context),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: context.read<SavedTranslationsProvider>().fetchTranslations(userId: rol != null && rol == 'user' ? userID : null),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Consumer<SavedTranslationsProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    itemCount: provider.translations.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final translation = provider.translations[index];

                      // Selecciona un color en orden de la lista
                      Color color = colors[index % colors.length];
                      Color textColor = textColors[index % textColors.length];

                      return PlatformButton(
                        onPressed: () => _showOptionsDialog(context, translation),
                        backgroundColor: color,
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        physicalModel: true,
                        leading: IconButton(onPressed: () => _showEditDialog(context, translation), icon: Icon(Icons.edit, color: textColor)),
                        trailing: IconButton(onPressed: () => _showDeleteDialog(context, translation['id_traduccion']), icon: Icon(Icons.delete, color: colorScheme.error)),
                        title: buildTitle(textColor, translation),

                        subtitle: translation['fecha'] != null 
                          ? Text('Fecha: ${_formatearFecha(translation['fecha'])}', style: TextStyle(color: textColor)) 
                          : Container(),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llama a la función para refrescar las traducciones
          context.read<SavedTranslationsProvider>().fetchTranslations(userId: rol != null && rol == 'user' ? userID : null);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Función para formatear la fecha
  String _formatearFecha(String fechaString) {
    // Define el formato de la fecha que recibe
    final DateFormat formatoEntrada = DateFormat('EEE, dd MMM yyyy HH:mm:ss z');

    try {
      // Intenta parsear la fecha usando el formato definido
      DateTime fecha = formatoEntrada.parse(fechaString);
      
      // Si el parseo es exitoso, formatea la fecha en el formato deseado
      return DateFormat('dd/MM/yyyy').format(fecha);
    } catch (e) {
      // Si ocurre un error, devuelve la fecha original
      return fechaString;
    }
  }

  RichText buildTitle(Color textColor, Map<String, dynamic> translation) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Texto Traducido: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: "${translation['texto_traducido'] ?? ''}",
            style: TextStyle(color: textColor),
          ),
          const TextSpan(text: "\n\n"),
          TextSpan(
            text: "Gesto Capturado: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: "${translation['gesto_capturado'] ?? ''}",
            style: TextStyle(color: textColor),
          ),
          const TextSpan(text: "\n\n"),
          TextSpan(
            text: "Precisión: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: "${translation['precision']?.toString().substring(0, 5)}%",
            style: TextStyle(color: textColor),
          ),
          const TextSpan(text: "\n\n"),
          TextSpan(
            text: "ID Usuario: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: "${translation['id_usuario'] ?? ''}",
            style: TextStyle(color: textColor),
          ),
          const TextSpan(text: "\n\n"),
          TextSpan(
            text: "ID Modelo: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: "${translation['id_modelo'] ?? ''}",
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, Map<String, dynamic> translation) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Opciones'),
        content: const Text('Elige una opción:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Cierra el diálogo de opciones
              _showEditDialog(context, translation); // Abre el dialogo de edicion
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Cierra el diálogo de opciones
              _showDeleteDialog(context, translation['id_traduccion']); // Abre el diálogo de eliminación
            },
            child: const Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta traducción?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<SavedTranslationsProvider>().deleteTranslation(id);
              Navigator.of(ctx).pop(); // Cierra el diálogo de confirmación
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> translation) {
    final TextEditingController textoTraducidoController =
        TextEditingController(text: translation['texto_traducido']);
    final TextEditingController gestoCapturadoController =
        TextEditingController(text: translation['gesto_capturado']);
    final TextEditingController precisionController =
        TextEditingController(text: translation['precision']);
    final TextEditingController fechaController =
        TextEditingController(text: translation['fecha']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Traducción'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textoTraducidoController,
                decoration: const InputDecoration(labelText: 'Texto Traducido'),
              ),
              TextField(
                controller: gestoCapturadoController,
                decoration: const InputDecoration(labelText: 'Gesto Capturado'),
              ),
              TextField(
                controller: precisionController,
                decoration: const InputDecoration(labelText: 'Precisión'),
              ),
              TextField(
                controller: fechaController,
                decoration: const InputDecoration(labelText: 'Fecha'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final updatedTranslation = {
                'id_traduccion': translation['id_traduccion'],
                'texto_traducido': textoTraducidoController.text,
                'gesto_capturado': gestoCapturadoController.text,
                'precision': precisionController.text,
                'fecha': fechaController.text,
                'id_usuario': translation['id_usuario'],
                'id_modelo': translation['id_modelo']
              };

              context
                  .read<SavedTranslationsProvider>()
                  .updateTranslation(translation['id_traduccion'], updatedTranslation);
              Navigator.of(ctx).pop(); // Cierra el dialogo
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  SuperAppBar buildTranslationsSuperAppBar(ColorScheme colorScheme, BuildContext context) {
    return SuperAppBar(
      height: kToolbarHeight + 10,
      backgroundColor: colorScheme.surface.withOpacity(0.5),

      // Menu
      leading: Builder(
        builder: (BuildContext context) {
          return PlatformButton(
            tooltip: "Menú",
            margin: const EdgeInsets.only(left: 5.0),
            borderRadius: BorderRadius.circular(50.0),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: Icon(Icons.menu, color: colorScheme.onSurface),
          );
        },
      ),

      // Titulo
      title: Text(
        "Traducciones",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: colorScheme.onSurface),
      ),

      // Titulo cuando este expandido
      largeTitle: SuperLargeTitle(
        enabled: true,
        height: 75,
        textStyle: TextStyle(
          inherit: false,
          fontFamily: '.SF Pro Display',
          fontSize: 34.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.41,
          color: colorScheme.onSurface,
          overflow: TextOverflow.ellipsis,
        ),
        largeTitle: "Traducciones",
      ),

      // Deshabilita la barra de busqueda
      searchBar: SuperSearchBar(enabled: false),
    );
  }
}
