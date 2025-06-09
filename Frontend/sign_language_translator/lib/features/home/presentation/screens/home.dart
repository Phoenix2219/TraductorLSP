import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/auth/presentation/provider/authentication_provider.dart';
import 'package:sign_language_translator/features/auth/presentation/screens/profile_screen.dart';
import 'package:sign_language_translator/features/translator/presentation/screens/translator.dart';
import 'package:sign_language_translator/main.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/card_button.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:sign_language_translator/shared/widgets/side_page_route.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).colorScheme.brightness;
    setBarBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildHomeSuperAppBar(colorScheme, context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              PlatformButton(
                onPressed: () {},
                backgroundColor: colorScheme.surfaceContainer,
                margin: const EdgeInsets.symmetric(horizontal: 15.0), 
                child: RichText(
                  text: TextSpan(
                    text: 'Este es un sistema de traductor de lengua de señas, detecta las señas por medio de IA. \n\nPara empezar a traducir, da clic en el botón de abajo "',
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16), // Estilo normal
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Traducir Señas', // Texto resaltado
                        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary), // Negrita y color primario
                      ),
                      const TextSpan(
                        text: '"', // Continuación del texto normal
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CardButton(
                icon: Icons.sign_language,
                text: "Traducir Señas",
                screen: Translator(),
              ),
              const SizedBox(height: 20),
              const CardButton(
                icon: Icons.report,
                text: "Enviar alerta",
              ),
              const SizedBox(height: 80),
              Container(margin: const EdgeInsets.symmetric(horizontal: 15.0), child: Text("Modelos de IA de Lengua de Señas Peruano", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28, color: colorScheme.primary),)),
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
          ),
        ),
      ),
    );
  }

  SuperAppBar buildHomeSuperAppBar(ColorScheme colorScheme, BuildContext context) {
    final nombreUsuario = context.select<AuthenticationProvider, String?>((prov) => prov.nombre);

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
          "Traductor LSP",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: colorScheme.onSurface),
        ),

        // Titulo cuando este expandido
        largeTitle: SuperLargeTitle(
          enabled: true,
          height: 75,
          textStyle: TextStyle(
            inherit: false,
            fontFamily: 'MachtonTTF',
            fontSize: 40,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: colorScheme.onSurface,
            overflow: TextOverflow.ellipsis,
          ),
          largeTitle: nombreUsuario != null && nombreUsuario.isNotEmpty ? "Bienvenido ${nombreUsuario.toCapitalized}" : "Bienvenido" ,
        ),
        
        // Deshabilita la barra de busqueda
        searchBar: SuperSearchBar(enabled: false),

        // Parte de lado derecho de la barra
        actions: PlatformButton(
          tooltip: "Perfil",
          onPressed: () {
            Navigator.of(context).push(SlidePageRoute(page: const ProfileScreen()));
          },
          margin: const EdgeInsets.only(right: 15.0),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(25.0),
          physicalModel: true,
          physicalShadowColor: colorScheme.onSurface.withOpacity(0.4),
          gradient: LinearGradient(
            colors: [colorScheme.primaryContainer, colorScheme.onPrimaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage("assets/imgs/profile.png"),
              // backgroundColor: Colors.transparent,
            ),
          ),
        ),
      );
  }

  // Cambia el color de los íconos de la barra de estado
  void setBarBrightness(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: brightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

