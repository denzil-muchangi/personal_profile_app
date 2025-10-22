import 'package:flutter/material.dart';
import '../shared/utils/responsive_utils.dart';

class ModernButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const ModernButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isPrimary = true,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveBorderRadius = borderRadius ?? ResponsiveUtils.getResponsiveIconSize(context, 12);

    final button = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        boxShadow: isPrimary && onPressed != null
            ? [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
                  offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 5)),
                ),
              ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
                icon,
                size: ResponsiveUtils.getResponsiveIconSize(context, 16),
              )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          foregroundColor: isPrimary
              ? Colors.white
              : Theme.of(context).primaryColor,
          elevation: 0,
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveIconSize(context, 20),
            vertical: ResponsiveUtils.getResponsiveIconSize(context, 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    width: ResponsiveUtils.getResponsiveIconSize(context, 1.2),
                  ),
          ),
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}