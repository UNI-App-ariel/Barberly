import 'package:flutter/material.dart';

class MySettingsTile extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? titleColor;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? leadingBackgroundColor;
  final void Function()? onTap;

  const MySettingsTile({
    super.key,
    required this.title,
    this.fontSize,
    this.titleColor,
    this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.iconColor,
    this.leadingBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        // constraints: const BoxConstraints(minHeight: 60),
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: leadingBackgroundColor ??
                      Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: leading,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize ?? 15,
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) subtitle!,
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 16),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
