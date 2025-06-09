import 'dart:ui';
import 'package:flutter/material.dart';

class BlurAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double blurSigmaX;
  final double blurSigmaY;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  const BlurAppBar({
    super.key,
    this.title,
    this.actions,
    this.blurSigmaX = 10.0,
    this.blurSigmaY = 10.0,
    this.backgroundColor, 
    this.leading, this.centerTitle, 
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
        child: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          leading: leading,
          title: Text(
            title ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: centerTitle,
          backgroundColor: backgroundColor ?? colorScheme.surface.withOpacity(0.8), 
          elevation: 0,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Tamaño estándar del AppBar
}
