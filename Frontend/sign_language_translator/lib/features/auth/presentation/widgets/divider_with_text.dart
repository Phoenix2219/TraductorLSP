import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? textPadding;
  final Color? color;
  final double? thickness;
  const DividerWithText({super.key, required this.text, this.margin, this.textPadding, this.color, this.thickness = 1});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: margin,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: thickness,
              color: color ?? colorScheme.onPrimaryContainer.withOpacity(0.7),
            ),
          ),
          Padding(
            padding: textPadding ?? const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              text,
              style: TextStyle(
                color: color ?? colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: thickness,
              color: color ?? colorScheme.onPrimaryContainer.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
