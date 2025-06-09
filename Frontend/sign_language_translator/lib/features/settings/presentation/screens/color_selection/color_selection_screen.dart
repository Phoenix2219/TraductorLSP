import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/settings/presentation/provider/theme_provider.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/simple_super_app_bar.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class ColorSelectionScreen extends StatelessWidget {
  const ColorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final bottom = MediaQuery.of(context).padding.bottom;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildSimpleSuperAppBar(context, titleText: "Color Principal", leadingIcon: CupertinoIcons.back, leadingOnPressed: () => Navigator.of(context).pop()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Modos de color
              ...ColorOption.values.map((color) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: colorScheme.surfaceContainer,
                  ),
                  child: RadioListTile<ColorOption>(
                    contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                    title: Row(
                      children: [
                        Expanded(child: Text(color.displayName, style: const TextStyle(fontSize: 17),)),
                        const SizedBox(width: 10),
                        Container(width: 50, height: 50, decoration: BoxDecoration(color: provider.getColorFromOption(color), borderRadius: BorderRadius.circular(50.0)), child: const Icon(Icons.color_lens_sharp, color: Colors.white),),
                      ],
                    ),
                    value: color,
                    groupValue: provider.colorOption,
                    onChanged: (value) {
                      provider.setColorOption(value!);
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
