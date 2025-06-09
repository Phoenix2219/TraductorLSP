import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PlatformButtonType {
  auto,
  material,
  cupertino,
  none,
}

class PlatformButton extends StatefulWidget {
  final Widget? child;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final BoxBorder? border;
  final bool? backdropFilter;
  final double? sigmaFilter;
  final bool? physicalModel;
  final Color? physicalColor;
  final Color? physicalShadowColor;
  final LinearGradient? gradient;
  final PlatformButtonType type;
  final bool isActive;
  final MouseCursor cursor;
  final Function(bool isHovered)? onHover;
  final bool scaleOnHover;

  const PlatformButton({
    super.key,
    this.child,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.onPressed,
    this.backgroundColor,
    this.borderRadius,
    this.tooltip,
    this.padding = const EdgeInsets.all(8.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.border,
    this.backdropFilter = false,
    this.sigmaFilter = 10.0,
    this.physicalModel = false,
    this.physicalColor,
    this.physicalShadowColor,
    this.gradient,
    this.type = PlatformButtonType.auto,
    this.isActive = true,
    this.cursor = SystemMouseCursors.click,
    this.onHover,
    this.scaleOnHover = false,
  });

  @override
  State<PlatformButton> createState() => _PlatformButtonState();
}

class _PlatformButtonState extends State<PlatformButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onPress = widget.isActive ? widget.onPressed : () {};

    return MouseRegion(
      cursor: widget.isActive ? widget.cursor : SystemMouseCursors.forbidden,
      onEnter: (_) { 
        setState(() => _isHovered = true); 
        if (widget.onHover != null) {
          widget.onHover!(true);
        }
      },
      onExit: (_) { 
        setState(() => _isHovered = false); 
        if (widget.onHover != null) {
          widget.onHover!(false);
        }
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: widget.scaleOnHover && _isHovered ? 1.05 : 1.0,
        child: Container(
          width: widget.width,
          margin: widget.margin,
          decoration: widget.border != null ? BoxDecoration(
            border: widget.border,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          ) : null,
          child: PhysicalModel(
            color: widget.physicalModel! ? widget.physicalColor != null ? widget.physicalColor! : Colors.transparent : Colors.transparent,
            elevation: widget.physicalModel! ? 8.0 : 0.0,
            shadowColor: widget.physicalModel! ? widget.physicalShadowColor != null ? widget.physicalShadowColor! : const Color(0xFF000000) : Colors.transparent,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: widget.backdropFilter! ? ImageFilter.blur(sigmaX: widget.sigmaFilter!, sigmaY: widget.sigmaFilter!) : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Tooltip(
                  message: widget.tooltip ?? "",
                  decoration: BoxDecoration(color: colorScheme.onPrimaryContainer.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                  textStyle: TextStyle(color: colorScheme.primaryContainer),
                  child: widget.isActive ? _buildPlatformSpecificButton(onPress) : _buildButton(onPress),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformSpecificButton(VoidCallback onPress) {

    if (widget.type == PlatformButtonType.auto) {
      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        return _buildCupertinoButton(onPress);
      } else {
        return _buildMaterialButton(onPress);
      }
    }

    switch (widget.type) {
      case PlatformButtonType.material:
        return _buildMaterialButton(onPress);
      case PlatformButtonType.cupertino:
        return _buildCupertinoButton(onPress);
      default:
        return _buildButton(onPress);
    }
  }

  Widget _buildCupertinoButton(void Function() onPress) {
    return CupertinoButton(
      padding: widget.padding,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
      color: widget.gradient == null ? widget.backgroundColor ?? Colors.transparent : null,
      onPressed: () {
        onPress();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: _buildChild(),
        ),
      ),
    );
  }

  Material _buildMaterialButton(void Function() onPress) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.backgroundColor ?? Colors.transparent : null,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          gradient: widget.gradient,
        ),
        child: InkWell(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          onTap: () {
            onPress();
          },
          child: Padding(
            padding: widget.padding!,
            child: _buildChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(void Function() onPress) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Opacity(
        opacity: widget.isActive ? 1 : 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: widget.gradient == null ? widget.isActive ? (widget.backgroundColor ?? Colors.transparent) : (widget.backgroundColor?.withOpacity(0.5) ?? Colors.transparent) : null,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
            gradient: widget.gradient,
          ),
          child: Padding(
            padding: widget.padding!,
            child: _buildChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    return widget.child != null ? widget.child! : SizedBox(
      width: widget.leading == null && widget.title == null && widget.subtitle == null && widget.trailing == null ? 10.0 : null,
      height: widget.leading == null && widget.title == null && widget.subtitle == null && widget.trailing == null ? 10.0 : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading
          if (widget.leading != null)
            Container(margin: const EdgeInsets.only(right: 10.0), child: widget.leading!),
      
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                if (widget.title != null) widget.title!,
      
                // Space vertical if subtitle item is not null
                if (widget.title != null && widget.subtitle != null) const SizedBox(height: 0.5),
      
                // Subtitle
                if (widget.subtitle != null) widget.subtitle!
              ],
            ),
          ),
      
          // Widget on the right side
          if (widget.trailing != null) Container( margin: const EdgeInsets.only(left: 10.0), child: widget.trailing!),
        ],
      ),
    );
  }

}