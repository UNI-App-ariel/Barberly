import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? height;
  final double? width;

  const MyButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: Material(
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: child,
          ),
        ),
      ),
    );
  }
}
