import 'package:flutter/material.dart';
import '../shared/utils/responsive_utils.dart';

class ModernTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final TextCapitalization textCapitalization;

  const ModernTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 4)),
                child: prefixIcon,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 4)),
                child: suffixIcon,
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        border: Theme.of(context).inputDecorationTheme.border,
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveIconSize(context, 12),
          vertical: ResponsiveUtils.getResponsiveIconSize(context, 12),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontFamily: 'Roboto',
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
        ),
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontFamily: 'Roboto',
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
          fontFamily: 'Roboto',
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      textCapitalization: textCapitalization,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
      ),
    );
  }
}