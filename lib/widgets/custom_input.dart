import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final IconData? prefixIcon; // ✅ Icon personnalisable

  const CustomInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.prefixIcon, // optional
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.blue.shade700)
            : null, // ✅ icon if provided
      ),
    );
  }
}
