import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color? textColor;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.keyboardType,
    this.obscureText = false,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.textColor,
    this.onSuffixTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;
    
    // Calculate responsive values
    final double horizontalPadding = size.width * 0.04; // 4% of screen width
    final double verticalPadding = size.height * 0.02; // 2% of screen height
    final double borderRadius = size.width * 0.02; // 2% of screen width
    final double iconSize = size.width * 0.05; // 5% of screen width

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 14 * textScaleFactor,
        fontFamily: 'Poppins1',
        letterSpacing: 1.12,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: const Color(0xffEDEDED),
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.black,
                size: iconSize,
              )
            : null,
        prefixIconColor: Colors.black,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  size: iconSize,
                ),
              )
            : null,
        suffixIconColor: Colors.black,
        hintText: hintText,
        hintStyle: TextStyle(
          color: textColor,
          fontSize: 14 * textScaleFactor,
          fontFamily: 'Poppins1',
          letterSpacing: 1.12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xffD0D0D0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xffD0D0D0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xffD0D0D0)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
