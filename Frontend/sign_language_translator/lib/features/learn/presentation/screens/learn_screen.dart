import 'package:flutter/material.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://issuu.com/keniacarolinalaraortiz/docs/manual_de_lengua_de_se_as_de_guatemala_mineduc_rgb')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://issuu.com/keniacarolinalaraortiz/docs/manual_de_lengua_de_se_as_de_guatemala_mineduc_rgb'));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildTranslationsSuperAppBar(colorScheme, context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(12.0),
                height: MediaQuery.of(context).size.height / 1.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: WebViewWidget(
                    controller: _controller,
                  ),
                ),
              ),
              const SizedBox(height: 800),
            ],
          ),
        ),
      ),
    );
  }

  SuperAppBar buildTranslationsSuperAppBar(ColorScheme colorScheme, BuildContext context) {
    return SuperAppBar(
      height: kToolbarHeight + 10,
      backgroundColor: colorScheme.surface.withOpacity(0.5),

      // Menú
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

      // Título
      title: Text(
        "Aprender",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: colorScheme.onSurface),
      ),

      // Título cuando esté expandido
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
        largeTitle: "Aprender",
      ),

      // Deshabilita la barra de búsqueda
      searchBar: SuperSearchBar(enabled: false),
    );
  }
}
