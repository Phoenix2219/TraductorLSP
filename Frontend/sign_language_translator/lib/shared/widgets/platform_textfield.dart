import 'dart:ui';
import 'package:flutter/material.dart';

class PlatformTextfield extends StatefulWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final BorderRadius? borderRadius;
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? isDense;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final Color? color;
  final Color? labelTextColor;
  final Color? hintColor;
  final String? errorText;
  final Color? errorbackgroundColor;
  final Color? errorColor;
  final BorderRadiusGeometry? errorBorderRadius;
  final double labelTextOpacity;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final Widget? leading;
  final Widget? trailing;
  final bool useNative;
  const PlatformTextfield({super.key, this.hintText, this.backgroundColor, this.color, this.padding, this.margin, this.borderRadius, this.hintColor, this.gradient, this.obscureText, required this.controller, this.fontSize, this.keyboardType, this.errorText, this.onChanged, this.errorbackgroundColor, this.errorColor, this.errorBorderRadius, this.leading, this.trailing, this.focusNode, this.enabled, this.height, this.fontWeight, this.isDense, this.onTapOutside, this.maxLines = 1, this.minLines, this.labelText, this.labelTextColor, this.useNative = false, this.labelTextOpacity = 1.0});

  @override
  State<PlatformTextfield> createState() => _PlatformTextfieldState();
}

class _PlatformTextfieldState extends State<PlatformTextfield> {
  late Color? _background;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _background = widget.gradient == null ? (widget.backgroundColor ?? colorScheme.primaryContainer) : null;

    return Container(
      margin: widget.margin,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: widget.padding != null ? widget.padding!.left : 15.0, right: widget.padding != null ? widget.padding!.right : 15.0),
            height: widget.height ?? 50,
            decoration: BoxDecoration(
              color: _background,
              gradient: widget.gradient,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                if (widget.leading != null)
                  Container(
                    margin: const EdgeInsets.only(right: 5.0),
                    child: widget.leading!,
                  ),
                Expanded(
                  child: buildTextField(colorScheme),
                ),
                if (widget.trailing != null)
                  Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    child: widget.trailing!,
                  ),
              ],
            ),
          ),
          if (widget.errorText != null)
            buildErrorContainer(colorScheme),
        ],
      ),
    );
  }

  TextField buildTextField(ColorScheme colorScheme) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      obscureText: widget.obscureText ?? false,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: EdgeInsets.only(top: widget.padding != null ? widget.padding!.top : 3, bottom: widget.padding != null ? widget.padding!.bottom : 3),
        label: widget.labelText != null
            ? buildLabelText(colorScheme)
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: widget.hintColor ?? colorScheme.onPrimaryContainer.withAlpha(190),
            fontSize: widget.fontSize,
        ),
        isDense: widget.isDense,
      ),
      style: TextStyle(
        color: widget.color ?? colorScheme.onPrimaryContainer,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
      onChanged: widget.onChanged,
      onTapOutside: widget.onTapOutside,
    );
  }

  Widget buildLabelText(ColorScheme colorScheme) {
    return Opacity(
      opacity: widget.labelTextOpacity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
            child: Text(
              widget.labelText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.labelTextColor ?? colorScheme.onPrimaryContainer.withAlpha(190),
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildErrorContainer(ColorScheme colorScheme) {
    return Positioned(
      bottom: 0,
      left:  0,
      right:  0,
      child: Transform.translate(
        offset: const Offset(0, 3),
        child: ClipRRect(
          borderRadius: widget.errorBorderRadius ?? const BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
          child: Container(
            padding: EdgeInsets.only(top: 0, bottom: 2, left: widget.padding != null ? widget.padding!.left + 2 : 8, right: widget.padding != null ? widget.padding!.right + 2 : 8),
            decoration: BoxDecoration(
              color: widget.errorbackgroundColor?.withOpacity(0.5) ?? _background?.withOpacity(0.5),
            ),
            child: Text(
              widget.errorText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: widget.errorColor ?? colorScheme.errorContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
