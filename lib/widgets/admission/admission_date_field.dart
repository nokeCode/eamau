import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdmissionDateField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const AdmissionDateField({
    super.key,
    required this.controller,
    required this.hint,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(context),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.calendar_month_outlined),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
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