import 'dart:ui';
import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  const BlurContainer({super.key, required this.child, this.backgroundColor, this.borderRadius = 15, this.padding});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius!),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius!),
            color: backgroundColor ?? colorScheme.primaryContainer.withOpacity(0.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
