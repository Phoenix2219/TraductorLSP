import 'package:flutter/material.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class ModelsaiScreen extends StatelessWidget {
  const ModelsaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Lista de colores
    final List<Color> colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.surfaceContainer,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
    ];

    final List<Color> textColors = [
      colorScheme.onPrimary,
      colorScheme.onSecondary,
      colorScheme.onTertiary,
      colorScheme.onSurfaceVariant,
      colorScheme.onPrimaryContainer,
      colorScheme.onSecondaryContainer,
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildTranslationsSuperAppBar(colorScheme, context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PlatformButton(
                        onPressed: () => {},
                        backgroundColor: colors[0],
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        physicalModel: true,
                        title: buildTitle(textColors[0], "Versión 1.0", "Modelo de Lengua de Señas Peruano Con Precisión del 65.4%", "65.4%"),
              ),
              PlatformButton(
                        onPressed: () => {},
                        backgroundColor: colors[2],
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        physicalModel: true,
                        title: buildTitle(textColors[2], "Versión 2.0", "Modelo de Lengua de Señas Peruano Con Precisión del 71.6%", "71.6%"),
              ),
              const SizedBox(height: 100),
              Container(margin: const EdgeInsets.symmetric(horizontal: 15.0), child: Text("Graficas de Modelos de IA de Lengua de Señas Peruano", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28, color: colorScheme.primary),)),
              PlatformButton(
                onPressed: () {},
                backgroundColor: colorScheme.surfaceBright,
                margin: const EdgeInsets.symmetric(horizontal: 15.0), 
                child: RichText(
                  text: TextSpan(
                    text: 'A continuación se muestra un gráfico con la precisión actual que cuentan los ',
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16), // Estilo normal
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Modelos de Inteligencia Artificial', // Texto resaltado
                        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary), // Negrita y color primario
                      ),
                      const TextSpan(
                        text: ' que usa este sistema: ', // Continuación del texto normal
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: Image.asset("assets/imgs/graficamodelosai.png", width: 300)),
              const SizedBox(height: 800),
            ],
          )
          ),
        ),
    );
  }

  RichText buildTitle(Color textColor, String verison, String descripcion, String precision) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Modelo: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: verison,
            style: TextStyle(color: textColor),
          ),
          const TextSpan(text: "\n\n"),
          TextSpan(
            text: "Descripción de Modelo: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: descripcion,
            style: TextStyle(color: textColor),
          ),
          const TextSpan(text: "\n\n"),
          TextSpan(
            text: "Precisión: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: precision,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  SuperAppBar buildTranslationsSuperAppBar(ColorScheme colorScheme, BuildContext context) {
    return SuperAppBar(
      height: kToolbarHeight + 10,
      backgroundColor: colorScheme.surface.withOpacity(0.5),

      // Menu
      leading: Builder(
        builder: (BuildContext context) {
          return PlatformButton(
            tooltip: "Menú",
            margin: const EdgeInsets.only(left: 5.0),
            borderRadius: BorderRadius.circular(50.0),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: Icon(Icons.menu, color: colorScheme.onSurface),
          );
        },
      ),

      // Titulo
      title: Text(
        "Modelos de IA",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: colorScheme.onSurface),
      ),

      // Titulo cuando este expandido
      largeTitle: SuperLargeTitle(
        enabled: true,
        height: 75,
        textStyle: TextStyle(
          inherit: false,
          fontFamily: '.SF Pro Display',
          fontSize: 34.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.41,
          color: colorScheme.onSurface,
          overflow: TextOverflow.ellipsis,
        ),
        largeTitle: "Modelos de IA",
      ),

      // Deshabilita la barra de busqueda
      searchBar: SuperSearchBar(enabled: false),
    );
  }
}
