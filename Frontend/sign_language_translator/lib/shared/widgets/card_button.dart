import 'package:flutter/material.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';

class CardButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? backgroundIconColor;
  final Color? iconColor;
  final Color? textColor;
  final IconData? icon;
  final String? text;
  final Widget? screen;

  const CardButton({
    super.key,
    this.backgroundColor,
    this.screen, this.iconColor, this.textColor, this.backgroundIconColor, this.icon, this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PlatformButton(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 35.0),
      width: double.infinity,
      backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
      onPressed: () {
        if (screen != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => screen!,
            ),
          );
        }
      },
      child: Column(
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: backgroundIconColor ?? colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Icon(icon!, size: 34, color: iconColor ?? colorScheme.inversePrimary),
            ),
          const SizedBox(height: 10),
          if (text != null)
            Text(
              text!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor ?? colorScheme.onPrimaryContainer),
            ),
        ],
      ),
    );
  }
}
