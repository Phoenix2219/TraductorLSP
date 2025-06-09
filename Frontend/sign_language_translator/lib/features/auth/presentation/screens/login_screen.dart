import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/auth/presentation/screens/signup_screen.dart';
import 'package:sign_language_translator/features/auth/presentation/widgets/divider_with_text.dart';
import 'package:sign_language_translator/shared/widgets/blur_app_bar.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:sign_language_translator/shared/widgets/platform_textfield.dart';
import 'package:sign_language_translator/features/auth/presentation/widgets/platforms_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(true);
  Color? _errorColor;
  bool _showPass = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    final emailError = context.select<AuthenticationProvider, String?>((provider) => provider.emailError);
    final passwordError = context.select<AuthenticationProvider, String?>((provider) => provider.passwordError);
    final isLoading = context.select<AuthenticationProvider, bool>((provider) => provider.isLoading);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: BlurAppBar(title: "Traductor LSP", centerTitle: true, backgroundColor: colorScheme.surface.withOpacity(0.5)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 110,
              ),

              // logo
              Image.asset("assets/imgs/logoLSP2.png", width: 200,),
          
              const SizedBox(
                height: 50,
              ),
          
              // Mnesaje de bienvenida
              Text("Inicio de Sesión", style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 25, fontWeight: FontWeight.w700),),
      
              const SizedBox(
                height: 30,
              ),
              
              // Campo de correo
              PlatformTextfield(
                controller: _emailController,
                backgroundColor: colorScheme.surfaceContainer,
                keyboardType: TextInputType.emailAddress,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                fontSize: 17,
                labelText: "Correo",
                errorText: emailError,
                errorColor: _errorColor,
              ),
      
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: emailError != null ? 25 : 15,
              ),
      
              // Campo de contraseña
              PlatformTextfield(
                controller: _passwordController,
                backgroundColor: colorScheme.surfaceContainer,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(top: 3, bottom: 3, left: 15.0, right: 10.0),
                obscureText: !_showPass,
                fontSize: 17,
                labelText: "Contraseña",
                errorText: passwordError,
                errorColor: _errorColor,
                trailing: PlatformButton(
                  onPressed: () => setState(() { _showPass = !_showPass; }),
                  tooltip: "Mostrar contraseña",
                  padding: const EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(50.0),
                  child: _showPass ? const Icon(CommunityMaterialIcons.eye) : const Icon(CommunityMaterialIcons.eye_off),
                ),
              ),
      
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: passwordError != null ? 25 : 15,
              ),
      
              // Olvidaste tu contraseña
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Olvidé mi contraseña",
                  style: TextStyle(color: Color.fromARGB(220, 33, 149, 243), fontWeight: FontWeight.w500),
                ),
              ),
      
              const SizedBox(
                height: 15,
              ),
      
              // Botón de iniciar sesión
              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isButtonEnabled, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    child: PlatformButton(
                      onPressed: () => auth.login(context, _emailController.text, _passwordController.text),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      borderRadius: BorderRadius.circular(10.0),
                      backgroundColor: colorScheme.primary,
                      physicalModel: true,
                      isActive: isButtonEnabled,
                      child: isLoading ? Center(child: CircularProgressIndicator(strokeWidth: 3.0, color: colorScheme.onPrimaryFixed),) : Text("Iniciar sesión", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorScheme.onPrimary),),
                    ),
                  );
                }
              ),
      
              const SizedBox(
                height: 30,
              ),
      
              // O continuar con otras plataformas
              const DividerWithText(
                text: "O continúa con",
                margin: EdgeInsets.symmetric(horizontal: 20.0),                
              ),
      
              const SizedBox(
                height: 25,
              ),
      
              // Otras plataformas
              const PlatformsAuth(),
      
              const SizedBox(
                height: 30,
              ),
      
              // Registrar ahora
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "¿No tienes cuenta? ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: colorScheme.onSurface, fontSize: 13.5),
                    ),
                    TextSpan(
                      text: "Regístrate",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color.fromARGB(220, 33, 149, 243), fontWeight: FontWeight.w600, fontSize: 13.5),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                            (Route<dynamic> route) => false, // Esto elimina todas las rutas anteriores
                          );
                        },
                    ),
                  ],
                ),
              ),
      
              SizedBox(
                height: paddingBottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to validate the form fields
  void _validateForm() {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    final emailValid = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email);
    final passwordValid = password.isNotEmpty && !password.contains(' ');

    if (!emailValid || !passwordValid) {
      _errorColor = const Color.fromARGB(255, 164, 126, 13);
    } else {
      _errorColor = null;
    }

    if (!emailValid && email.isNotEmpty) {
      auth.emailError = "Correo no válido. Ej: user@google.com";
    } else {
      auth.emailError = null;
    }

    if (!passwordValid && password.isNotEmpty) {
      auth.passwordError = "La contraseña no debe tener espacios en blanco";
    } else {
      auth.passwordError = null;
    }

    _isButtonEnabled.value = emailValid && passwordValid;
  }
}
