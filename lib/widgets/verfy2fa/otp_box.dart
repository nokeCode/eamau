import 'package:flutter/material.dart';

class OtpBox extends StatelessWidget {

  final TextEditingController controller;
  final Function(String)? onChanged;

  const OtpBox({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 45,
      height: 55,

      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,

        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),

        decoration: InputDecoration(
          counterText: "",

          contentPadding: EdgeInsets.zero,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

            borderSide: const BorderSide(
              color: Color(0xFFD9DEE7),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

            borderSide: const BorderSide(
              color: Color(0xFF1682F8),
              width: 2,
            ),
          ),
        ),

        onChanged: onChanged,
      ),
    );
  }
}