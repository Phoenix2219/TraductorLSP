import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/home/presentation/screens/home.dart';
import 'package:sign_language_translator/features/learn/presentation/screens/learn_screen.dart';
import 'package:sign_language_translator/features/modelsai/presentation/screens/modelsai_screen.dart';
import 'package:sign_language_translator/features/saved_translations/presentation/screens/saved_translations_screen.dart';
import 'package:sign_language_translator/features/settings/presentation/screens/settings_screen.dart';
import 'package:sign_language_translator/features/support/presentation/screens/support_screen.dart';
import 'package:sign_language_translator/features/users/presentation/screens/users_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rol = context.select<AuthenticationProvider, String?>((provider) => provider.rol);

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/imgs/top_LSP1.1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(  
                      'Traductor de LSP',
                      style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'MachtonTTF'),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: colorScheme.onSurface),
                  title: Text('Inicio', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.save, color: colorScheme.onSurface),
                  title: Text('Traducciones', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedTranslationsScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.model_training_sharp, color: colorScheme.onSurface),
                  title: Text('Modelos', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ModelsaiScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.school, color: colorScheme.onSurface),
                  title: Text('Aprender', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnScreen()));
                  },
                ),
                if (rol != null && rol == "admin")
                  ListTile(
                    leading: Icon(Icons.person, color: colorScheme.onSurface),
                    title: Text('Usuarios', style: TextStyle(color: colorScheme.onSurface)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UsersScreen()));
                    },
                  ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: colorScheme.onSurface),
            title: Text('Configuración', style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: colorScheme.onSurface),
            title: Text('Soporte y Ayuda', style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom,)
        ],
      ),
    );
  }
}
