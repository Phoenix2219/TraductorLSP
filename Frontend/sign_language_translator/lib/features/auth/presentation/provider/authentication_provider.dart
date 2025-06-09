
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_language_translator/core/constants/constants.dart';
import 'package:sign_language_translator/features/auth/presentation/screens/login_screen.dart';
import 'package:sign_language_translator/features/home/presentation/screens/home.dart';

class AuthenticationProvider with ChangeNotifier {
  // Variables
  String? _emailError;
  String? _passwordError;
  String? _defaultError;
  String? _message;
  bool _isLoading = false;

  // Variables publicas
  String? authToken;
  int? id;
  String? nombre;
  String? apellido;
  String? correo;
  String? rol;
  String? imagen;

  // Getters
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get defaultError => _defaultError;
  String? get message => _message;
  bool get isLoading => _isLoading;

  // Constructor: Verifica si el usuario ya está autenticado
  AuthenticationProvider() {
    _loadUserData();
  }

  // Carga los datos del usuario desde SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      
      authToken = token;
      id = prefs.getInt('id') ?? 0;
      nombre = prefs.getString('nombre') ?? '';
      apellido = prefs.getString('apellido') ?? '';
      correo = prefs.getString('correo') ?? '';
      rol = prefs.getString('rol') ?? '';
      imagen = prefs.getString('imagen') ?? '';

      notifyListeners();
    } else {
      authToken = null;
      notifyListeners();
    }
  }

  // Setters
  set emailError(String? value) {
    _emailError = value;
    notifyListeners();
  }

  set passwordError(String? value) {
    _passwordError = value;
    notifyListeners();
  }

  // Metodos
  void login(BuildContext context, String email, String password) async {
    if (email.isEmpty && password.isEmpty) {
      _emailError = "Correo vacio";
      _passwordError = "Contraseña vacia";
      notifyListeners();
      return;
    }

    // Desenfoca los campos
    FocusScope.of(context).unfocus();
    _emailError = null; // Limpia cualquier error previo
    _passwordError = null; // Limpia cualquier error previo
    
    // Intenta iniciar sesión
    _isLoading = true;
    notifyListeners();
    
    // Realiza la petición al backend
    final url = Uri.parse('$baseAPIUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"correo": email, "contrasenia": password}),
    );

    if (response.statusCode == 200) {
      // Decodifica la respuesta
      final data = jsonDecode(response.body);
      
      // Almacena la información en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token'] ?? '');
      await prefs.setInt('id', data['id'] ?? 0);
      await prefs.setString('nombre', data['nombre'] ?? '');
      await prefs.setString('apellido', data['apellido'] ?? '');
      await prefs.setString('correo', data['correo'] ?? '');
      await prefs.setString('rol', data['rol'] ?? '');
      await prefs.setString('imagen', data['imagen'] ?? '');

      authToken = data['token'] ?? '';
      id = data['id'] ?? 0;
      nombre = data['nombre'] ?? '';
      apellido = data['apellido'] ?? '';
      correo = data['correo'] ?? '';
      rol = data['rol'] ?? '';
      imagen = data['imagen'] ?? '';
      
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false, 
        );
      }
      notifyListeners();
    } else {
      // Muestra un mensaje de error
      if (context.mounted) {
        _handleAuthError('invalid-credential', context);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUser(BuildContext context, String nombre, String apellido, String correo, String contrasenia) async {
    // Desenfoca los campos
    FocusScope.of(context).unfocus();
    
    _isLoading = true;
    notifyListeners();

    // Realiza la petición al backend
    final url = Uri.parse('$baseAPIUrl/usuarios');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "contrasenia": contrasenia,
        "rol": "user"
      }),
    );

    if (response.statusCode == 201) {
      // El usuario fue creado exitosamente
      final data = jsonDecode(response.body);
      _message = data['message'];      

      if (context.mounted) {
        login(context, correo, contrasenia);
      }

    } else {
      // Manejo de errores
      if (context.mounted) {
        _handleAuthError('channel-error', context);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para actualizar usuario
  Future<void> updateUser(BuildContext context, String nombre, String apellido, String correo, String rol, String imagen) async {
    // Desenfoca los campos
    FocusScope.of(context).unfocus();

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$baseAPIUrl/usuarios/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "rol": rol,
        "imagen": imagen,
      }),
    );

    if (response.statusCode == 200) {
      // Actualiza la información en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', nombre);
      await prefs.setString('apellido', apellido);
      await prefs.setString('correo', correo);
      await prefs.setString('rol', rol);
      await prefs.setString('imagen', imagen);

      // Actualiza los atributos del provider
      this.nombre = nombre;
      this.apellido = apellido;
      this.correo = correo;
      this.rol = rol;
      this.imagen = imagen;

      _message = "Usuario actualizado exitosamente";
      notifyListeners();

      // Muestra el popup de éxito
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Éxito'),
              content: Text(_message!),
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
    } else {
      if (context.mounted) {
        _handleAuthError('channel-error', context);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void _handleAuthError(String? errorCode, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (errorCode) {
      case 'invalid-email':
        _emailError = 'Correo electrónico no válido.';
        _message = _emailError;
        break;
      case 'user-disabled':
        _emailError = 'Esta cuenta ha sido deshabilitada.';
        _message = _emailError;
        break;
      case 'user-not-found':
        _emailError = 'No se encontró una cuenta con este correo electrónico.';
        _message = _emailError;
        break;
      case 'invalid-credential':
        _passwordError = 'Contraseña incorrecta.';
        _message = _passwordError;
        break;
      case 'channel-error':
        _defaultError = 'Datos inválidos';
        _message = _defaultError;
        break;
      default:
        _defaultError = 'Datos inválidos';
        _message = _defaultError;
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Error', style: TextStyle(color: colorScheme.error),),
          content: Text(_message!, style: TextStyle(color: colorScheme.onSurface),),
          actions: [
            CupertinoDialogAction(
              child: Text('OK', style: TextStyle(color: colorScheme.primary),),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el dialogo
              },
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Obtiene la instancia de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Borra los datos del usuario
    await prefs.remove('token');
    await prefs.remove('id');
    await prefs.remove('nombre');
    await prefs.remove('apellido');
    await prefs.remove('correo');
    await prefs.remove('rol');
    await prefs.remove('imagen');

    authToken = null; // Actualiza el estado del login
    _isLoading = false;
    notifyListeners();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Esto elimina todas las rutas anteriores
      );
    }
  }
}