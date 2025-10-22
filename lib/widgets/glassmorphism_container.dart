import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? blur;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassmorphismContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24,
    this.blur = 20,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius!),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: (borderColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: blur!,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: BackdropFilter(
          filter: blur != 0
              ? ImageFilter.blur(sigmaX: blur!, sigmaY: blur!)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).cardColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(borderRadius!),
              border: Border.all(
                color: borderColor?.withValues(alpha: 0.2) ?? Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: borderWidth!,
              ),
            ),
            child: onTap != null
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(borderRadius!),
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}