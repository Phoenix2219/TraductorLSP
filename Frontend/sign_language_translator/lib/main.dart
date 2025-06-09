import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/core/providers/app_providers.dart';
import 'package:sign_language_translator/features/auth/presentation/screens/auth_gate.dart';
import 'package:sign_language_translator/features/settings/presentation/provider/theme_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: AppProviders.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeProvider, ThemeModeOption>((prov) => prov.themeMode);
    final primaryColor = context.select<ThemeProvider, Color?>((prov) => prov.primaryColor);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Traductor de Lengua de Señas Peruano',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor ?? Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor ?? Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeMode == ThemeModeOption.system
          ? ThemeMode.system
          : themeMode == ThemeModeOption.dark
              ? ThemeMode.dark
              : ThemeMode.light,
      home: const AuthGate(),
    );
  }
}

extension StringCasingExtension on String {
  String get toCapitalized {
    if (isEmpty) return this;
    final firstLetterIndex = indexOf(RegExp(r'[a-zA-Z]'));
    if (firstLetterIndex == -1) return this; // If there are no letters, returns the original string
    return substring(0, firstLetterIndex) +
        this[firstLetterIndex].toUpperCase() +
        substring(firstLetterIndex + 1).toLowerCase();
  }

  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}