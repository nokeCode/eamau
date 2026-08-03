import 'package:flutter/material.dart';

class AdmissionPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String countryCode;
  final VoidCallback? onCountryTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const AdmissionPhoneField({
    super.key,
    required this.controller,
    this.countryCode = "+228",
    this.onCountryTap,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "Téléphone",
          prefixIcon: const Icon(Icons.phone_outlined),
          suffixIcon: InkWell(
            onTap: onCountryTap,
            child: SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryCode,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
            ),
          ),
        ),
      ),
    );
  }
}