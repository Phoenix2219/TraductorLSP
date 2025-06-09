import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/settings/presentation/provider/theme_provider.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/simple_super_app_bar.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final bottom = MediaQuery.of(context).padding.bottom;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildSimpleSuperAppBar(context, titleText: "Modo de Tema", leadingIcon: CupertinoIcons.back, leadingOnPressed: () => Navigator.of(context).pop()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Modos de tema
              ...ThemeModeOption.values.map((mode) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: colorScheme.surfaceContainer,
                  ),
                  child: RadioListTile<ThemeModeOption>(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                    title: Row(
                      children: [
                        Expanded(child: Text(mode.displayName, style: const TextStyle(fontSize: 17),)),
                        const SizedBox(width: 10),
                        if (mode == ThemeModeOption.system)
                          const Icon(CommunityMaterialIcons.theme_light_dark, size: 40, color: Colors.cyan),
                        if (mode == ThemeModeOption.light)
                          const Icon(Icons.light_mode, size: 40, color: Colors.amber),
                        if (mode == ThemeModeOption.dark)
                          const Icon(Icons.dark_mode, size: 40, color: Colors.deepPurple),
                      ],
                    ),
                    value: mode,
                    groupValue: provider.themeMode,
                    onChanged: (value) {
                      provider.setThemeMode(value!);
                    },
                  ),
                );
              }),

              const SizedBox(height: 800),
              
              SizedBox(height: bottom + 10),
            ],
          ),
        ),
      ),
    );
  }
}
