import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/saved_translations/presentation/provider/saved_translations_provider.dart';
import 'package:sign_language_translator/features/settings/presentation/provider/theme_provider.dart';
import 'package:sign_language_translator/features/support/presentation/provider/support_provider.dart';
import 'package:sign_language_translator/features/translator/presentation/provider/translator_provider.dart';
import 'package:sign_language_translator/features/users/presentation/provider/users_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Proveedor de Temas
    ChangeNotifierProvider(create: (_) => ThemeProvider()),

    // Proveedor de Traductor
    ChangeNotifierProvider(create: (_) => TranslatorProvider()),

    // Proveedor de Autenticación
    ChangeNotifierProvider(create: (_) => AuthenticationProvider()),

    // Proveedor de Traducciones Guardadas
    ChangeNotifierProvider(create: (_) => SavedTranslationsProvider()),

    // Proveedor de Usuarios Guardados
    ChangeNotifierProvider(create: (_) => UsersProvider()),

    // Proveedor de Soporte
    ChangeNotifierProvider(create: (_) => SupportProvider()),
  ];
}