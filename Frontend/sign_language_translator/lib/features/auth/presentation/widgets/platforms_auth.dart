import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';

class PlatformsAuth extends StatelessWidget {
  const PlatformsAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          PlatformButton(
            onPressed: () {},
            tooltip: "Google",
            padding: const EdgeInsets.all(7),
            borderRadius: BorderRadius.circular(50.0),
            backgroundColor: colorScheme.onPrimaryFixed,
            physicalModel: true,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Image.asset(
                "assets/imgs/platforms_logos/google.png"
              ),
            ),
          ),
          const SizedBox(width: 15),
          PlatformButton(
            onPressed: () {},
            tooltip: "Apple",
            padding: const EdgeInsets.all(7),
            borderRadius: BorderRadius.circular(50.0),
            backgroundColor:  colorScheme.onPrimaryFixed,
            physicalModel: true,
            child: const Icon(
              CommunityMaterialIcons.apple,
              color: Colors.black,
              size: 45,
            ),
          ),
          const SizedBox(width: 15),
          PlatformButton(
            onPressed: () {},
            tooltip: "Facebook",
            padding: const EdgeInsets.all(7),
            borderRadius: BorderRadius.circular(50.0),
            backgroundColor: colorScheme.onPrimaryFixed,
            physicalModel: true,
            child: const Icon(
              CommunityMaterialIcons.facebook,
              color: Colors.blue,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }
}
