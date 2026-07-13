import 'package:flutter/material.dart';

class AdmissionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool enabled;
  final int maxLines;
  final String? Function(String?)? validator;

  const AdmissionTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade500,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xff0B4EA2),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}