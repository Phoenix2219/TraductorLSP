import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/support/presentation/provider/support_provider.dart';
import 'package:sign_language_translator/main.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  // Controladores para los campos del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      _nameController.text = "${authProvider.nombre?.toCapitalized ?? ''} ${authProvider.apellido?.toCapitalized ?? ''}";
      _emailController.text = authProvider.correo ?? '';
    });
    
  }

  @override
  void dispose() {
    // Libera los controladores al cerrar la pantalla
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_subjectController.text.isNotEmpty && _emailController.text.isNotEmpty && _nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      Provider.of<SupportProvider>(context, listen: false).sendEmail(_subjectController.text, _emailController.text, _nameController.text, _descriptionController.text);

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Formulario enviado.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        ),
      );
      
      // Limpia los campos después del envío
      _subjectController.clear();
      _descriptionController.clear();

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Llena los campos primero!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildTranslationsSuperAppBar(colorScheme, context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formulario de Soporte y Ayuda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),

              // Campo para el nombre
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo para el correo electrónico
              TextField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Campo para el tema del problema
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Tema del Problema',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo para la descripción del problema
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Descripción del Problema',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botón de envío
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SuperAppBar buildTranslationsSuperAppBar(ColorScheme colorScheme, BuildContext context) {
    return SuperAppBar(
      height: kToolbarHeight + 10,
      backgroundColor: colorScheme.surface.withOpacity(0.5),

      // Menú
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

      // Título
      title: Text(
        "Soporte y Ayuda",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: colorScheme.onSurface),
      ),

      // Título cuando esté expandido
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
        largeTitle: "Soporte",
      ),

      // Deshabilita la barra de búsqueda
      searchBar: SuperSearchBar(enabled: false),
    );
  }
}
