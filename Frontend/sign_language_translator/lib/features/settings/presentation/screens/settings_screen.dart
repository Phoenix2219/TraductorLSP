import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/settings/presentation/provider/theme_provider.dart';
import 'package:sign_language_translator/features/settings/presentation/screens/color_selection/color_selection_screen.dart';
import 'package:sign_language_translator/features/settings/presentation/screens/theme_mode/theme_mode_screen.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:sign_language_translator/shared/widgets/simple_super_app_bar.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(18.0);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).padding.bottom;
    final themeMode = context.select<ThemeProvider, ThemeModeOption>((prov) => prov.themeMode);
    final colorOption = context.select<ThemeProvider, ColorOption>((prov) => prov.colorOption);
    final themeIcon = themeMode == ThemeModeOption.system ? CommunityMaterialIcons.theme_light_dark : themeMode == ThemeModeOption.light ? Icons.light_mode : Icons.dark_mode;
    final themeIconColor = themeMode == ThemeModeOption.system ? Colors.cyan : themeMode == ThemeModeOption.light ? Colors.amber : Colors.deepPurple;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildSimpleSuperAppBar(context, titleText: "Configuraciones"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Apariencia
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text("Apariencia", style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: borderRadius,
                  bottom: borderRadius,
                ),
                child: Column(
                  children: [

                    // Modos de tema
                    PlatformButton(
                      backgroundColor: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(18.0),
                      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                      leading: Icon(themeIcon, size: 30, color: themeIconColor),
                      title: Text('Modo de Tema', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 17),),
                      subtitle: Text(themeMode.displayName, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.8)),),
                      trailing: Icon(CupertinoIcons.chevron_forward, color: colorScheme.onSurface),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ThemeModeScreen()),
                      ),
                    ),

                    Divider(
                      height: 20,
                      color: colorScheme.onSurface.withOpacity(0.2),
                      indent: 45,
                    ),

                    // Colores de Temas
                    PlatformButton(
                      backgroundColor: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(18.0),
                      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                      leading: Icon(Icons.color_lens, size: 30, color: themeProvider.getColorFromOption(colorOption)),
                      title: Text('Color Principal', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 17),),
                      subtitle: Text(colorOption.displayName, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.8)),),
                      trailing: Icon(CupertinoIcons.chevron_forward, color: colorScheme.onSurface),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ColorSelectionScreen()),
                      ),
                    ),

                  ],
                ),
              ),              

              const SizedBox(height: 800),
              
              SizedBox(height: bottom + 10),
            ],
          ),
        ),
      ),
    );
  }
}