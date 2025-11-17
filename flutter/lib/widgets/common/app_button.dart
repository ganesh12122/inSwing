import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadiusGeometry? borderRadius;
  final double? elevation;

  const AppButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = isOutlined
        ? theme.outlinedButtonTheme.style
        : theme.elevatedButtonTheme.style;

    Widget buttonChild;
    if (isLoading) {
      buttonChild = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitWave(
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(text),
        ],
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      buttonChild = Text(text);
    }

    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height ?? 56,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle?.copyWith(
            minimumSize: WidgetStateProperty.all(const Size(double.infinity, 56)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            ),
            backgroundColor: backgroundColor != null
                ? WidgetStateProperty.all(backgroundColor)
                : null,
            foregroundColor: textColor != null
                ? WidgetStateProperty.all(textColor)
                : null,
          ),
          child: buttonChild,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height ?? 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle?.copyWith(
            minimumSize: WidgetStateProperty.all(const Size(double.infinity, 56)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            ),
            backgroundColor: backgroundColor != null
                ? WidgetStateProperty.all(backgroundColor)
                : null,
            foregroundColor: textColor != null
                ? WidgetStateProperty.all(textColor)
                : null,
            elevation: elevation != null
                ? WidgetStateProperty.all(elevation)
                : null,
          ),
          child: buttonChild,
        ),
      );
    }
  }
}