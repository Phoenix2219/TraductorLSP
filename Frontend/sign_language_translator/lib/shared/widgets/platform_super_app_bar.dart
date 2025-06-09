import 'package:flutter/material.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/models/super_appbar.model.dart';
import 'package:super_cupertino_navigation_bar/models/super_large_title.model.dart';
import 'package:super_cupertino_navigation_bar/models/super_search_bar.model.dart';

SuperAppBar buildSuperAppBar(BuildContext context, 
    {Color? backgroundColor, double? height, Widget? leading, String? leadingTooltip, Widget? leadingIcon, void Function()? leadingOnPressed,
    Widget? title, String? titleText, String? largeTitleText, Widget? action, String? actionTooltip, Widget? actionIcon, void Function()? actionOnPressed}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SuperAppBar(
        height: height ?? kToolbarHeight + 10,
        backgroundColor: backgroundColor ?? colorScheme.surface.withOpacity(0.5),
        
        // Menu
        leading: PlatformButton(
          tooltip: leadingTooltip,
          margin: const EdgeInsets.only(left: 5.0),
          borderRadius: BorderRadius.circular(50.0),
          onPressed: leadingOnPressed ?? () {},
          child: leadingIcon ?? Container(),
        ),

        // Titulo
        title: title ?? Text(
          titleText ?? '',
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
          ),
          largeTitle: largeTitleText ?? '',
        ),
        
        // Deshabilita la barra de busqueda
        searchBar: SuperSearchBar(enabled: false),

        // Parte de lado derecho de la barra
        actions: action ?? PlatformButton(
          tooltip: actionTooltip,
          onPressed: actionOnPressed ?? () {},
          margin: const EdgeInsets.only(right: 15.0),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(25.0),
          child: actionIcon ?? Container(),
        ),
      );
  }