import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/auth/presentation/screens/login_screen.dart';
import 'package:sign_language_translator/features/home/presentation/screens/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authToken = context.select<AuthenticationProvider, String?>((prov) => prov.authToken);

    return authToken != null && authToken.isNotEmpty ? const Home() : const LoginScreen();
  }
}
