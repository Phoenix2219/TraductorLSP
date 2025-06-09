import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/auth/presentation/screens/login_screen.dart';
import 'package:sign_language_translator/main.dart';
import 'package:sign_language_translator/shared/widgets/blur_app_bar.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:sign_language_translator/shared/widgets/platform_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authToken = context.select<AuthenticationProvider, String?>((provider) => provider.authToken);
    return authToken != null && authToken.isNotEmpty ? Profile() : const LoginScreen();
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Recupera los datos del provider y los asigna
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
    _idController.text = (auth.id ?? 0).toString();
    _nameController.text = auth.nombre ?? '';
    _lastNameController.text = auth.apellido ?? '';
    _emailController.text = auth.correo ?? '';
    _rolController.text = auth.rol ?? '';
    _imageController.text = auth.imagen ?? '';
  }

  @override
  void dispose() {
    // Limpia los controladores
    _idController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _rolController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    final nombre = context.select<AuthenticationProvider, String?>((provider) => provider.nombre);
    final imagen = context.select<AuthenticationProvider, String?>((provider) => provider.imagen);
    final isLoading = context.select<AuthenticationProvider, bool>((provider) => provider.isLoading);
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: BlurAppBar(title: "Mi Perfil - ${nombre?.toCapitalized}", centerTitle: true, backgroundColor: colorScheme.surface.withOpacity(0.5)),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  
                  // logo
                  CircleAvatar(
                    radius: 100,
                    child: ClipRRect(borderRadius: BorderRadius.circular(100), child: imagen != null && imagen.isNotEmpty ? Image.network(imagen, width: 200) : Image.asset("assets/imgs/profile.png", width: 200)),
                  ),
                  
                  const SizedBox(
                    height: 50,
                  ),

                  Text(
                    "Detalles del Perfil",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              
                  const SizedBox(
                    height: 50,
                  ),
          
                  // Campo de Nombre
                  PlatformTextfield(
                    controller: _nameController,
                    backgroundColor: colorScheme.surfaceContainer,
                    keyboardType: TextInputType.name,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    fontSize: 17,
                    labelText: "Nombres",
                  ),
          
                  const SizedBox(
                    height: 15,
                  ),
          
                  // Campo de Apellidos
                  PlatformTextfield(
                    controller: _lastNameController,
                    backgroundColor: colorScheme.surfaceContainer,
                    keyboardType: TextInputType.name,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    fontSize: 17,
                    labelText: "Apellidos",
                  ),
          
                  const SizedBox(
                    height: 15,
                  ),
                  
                  // Campo de correo
                  PlatformTextfield(
                    controller: _emailController,
                    backgroundColor: colorScheme.surfaceContainer,
                    keyboardType: TextInputType.emailAddress,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    fontSize: 17,
                    labelText: "Correo",
                    enabled: false,
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  
                  // Campo de rol
                  PlatformTextfield(
                    controller: _rolController,
                    backgroundColor: colorScheme.surfaceContainer,
                    keyboardType: TextInputType.name,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    fontSize: 17,
                    labelText: "Rol",
                    enabled: false,
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  
                  // Campo de imagen
                  PlatformTextfield(
                    controller: _imageController,
                    backgroundColor: colorScheme.surfaceContainer,
                    keyboardType: TextInputType.url,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    fontSize: 17,
                    labelText: "Imagen",
                  ),
          
                  const SizedBox(
                    height: 30,
                  ),

                  // Botón de editar
                  SizedBox(
                    width: double.infinity,
                    child: PlatformButton(
                      onPressed: () => auth.updateUser(context, _nameController.text, _lastNameController.text, _emailController.text, _rolController.text, _imageController.text),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      borderRadius: BorderRadius.circular(10.0),
                      backgroundColor: colorScheme.tertiary,
                      physicalModel: true,
                      child: isLoading ? Center(child: CircularProgressIndicator(strokeWidth: 3.0, color: colorScheme.onPrimaryFixed),) : Text("Editar perfil", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorScheme.onPrimary),),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
          
                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: PlatformButton(
                      onPressed: () => auth.logout(context),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      borderRadius: BorderRadius.circular(10.0),
                      backgroundColor: colorScheme.primary,
                      physicalModel: true,
                      child: Text("Cerrar sesión", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorScheme.onPrimary),),
                    ),
                  ),
          
                  SizedBox(
                    height: paddingBottom + 20,
                  ),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 10,
            left: 10,
            child: PlatformButton(
              onPressed: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(50.0),
              child: const Icon(CupertinoIcons.back, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}