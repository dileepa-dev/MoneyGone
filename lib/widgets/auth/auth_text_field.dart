import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  final bool obscureText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Widget? suffixIcon;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      obscureText: obscureText,

      keyboardType: keyboardType,

      textInputAction: textInputAction,

      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurface,
      ),

      cursorColor: const Color(0xFF0DB14B),

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        floatingLabelBehavior:
        FloatingLabelBehavior.always,

        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
        ),

        floatingLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
        ),

        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.only(
          left: 0,
          right: 0,
          bottom: 8,
          top: 5,
        ),
      ),
    );
  }
}