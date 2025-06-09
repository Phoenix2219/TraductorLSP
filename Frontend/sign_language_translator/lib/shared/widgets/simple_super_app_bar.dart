import 'package:flutter/material.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/models/super_appbar.model.dart';
import 'package:super_cupertino_navigation_bar/models/super_large_title.model.dart';
import 'package:super_cupertino_navigation_bar/models/super_search_bar.model.dart';

SuperAppBar buildSimpleSuperAppBar(BuildContext context, {String? leadingText, IconData? leadingIcon, Function()? leadingOnPressed, String? titleText, String? largeTitleText}) {
  final colorScheme = Theme.of(context).colorScheme;

  return SuperAppBar(
    height: kToolbarHeight + 10,
    backgroundColor: colorScheme.surface.withOpacity(0.5),

    // Menú
    leading: Builder(
      builder: (BuildContext context) {
        return PlatformButton(
          tooltip: leadingText ?? "Menú",
          margin: const EdgeInsets.only(left: 5.0),
          borderRadius: BorderRadius.circular(50.0),
          onPressed: leadingOnPressed ?? () {
            Scaffold.of(context).openDrawer();
          },
          child: Icon(leadingIcon ?? Icons.menu, color: colorScheme.onSurface),
        );
      },
    ),

    // Título
    title: Text(
      titleText ?? "",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: colorScheme.onSurface),
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
      largeTitle: largeTitleText ?? titleText ?? "",
    ),

    // Deshabilita la barra de búsqueda
    searchBar: SuperSearchBar(enabled: false),
  );
}
