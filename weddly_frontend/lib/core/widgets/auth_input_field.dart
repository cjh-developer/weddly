import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/weddly_colors.dart';

enum FieldStatus { none, success, error, info }

class AuthInputField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? messageText;
  final FieldStatus fieldStatus;

  const AuthInputField({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.onChanged,
    this.messageText,
    this.fieldStatus = FieldStatus.none,
    super.key,
  });

  Color _activeBorderColor(BuildContext context) {
    switch (fieldStatus) {
      case FieldStatus.error:
        return AppColors.error;
      case FieldStatus.success:
        return AppColors.success;
      default:
        return context.wBorder;
    }
  }

  Color get _msgColor {
    switch (fieldStatus) {
      case FieldStatus.success:
        return AppColors.success;
      case FieldStatus.error:
        return AppColors.error;
      default:
        return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -- Label
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: context.wTextSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        // -- Input
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          onChanged: onChanged,
          style: TextStyle(
            color: context.wTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: context.wTextHint, size: 20)
                : null,
            suffixIcon: suffixIcon,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: _activeBorderColor(context), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: fieldStatus == FieldStatus.error
                    ? AppColors.error
                    : fieldStatus == FieldStatus.success
                        ? AppColors.success
                        : AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        // -- Field message
        SizedBox(
          height: 18,
          child: Padding(
            padding: const EdgeInsets.only(top: 3, left: 2),
            child: Text(
              messageText ?? '',
              style: TextStyle(
                fontSize: 12,
                color: _msgColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Phone number auto-hyphen formatter (010-xxxx-xxxx)
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted;
    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 7) {
      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else {
      final end = digits.length.clamp(0, 11);
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7, end)}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
