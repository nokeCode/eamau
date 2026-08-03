import 'package:flutter/material.dart';

class AdmissionDropdownField<T> extends StatelessWidget {
  final String hint;
  final IconData icon;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T item)? itemLabel;
  final String? Function(T?)? validator;
  final FocusNode? focusNode;

  const AdmissionDropdownField({
    super.key,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: DropdownButtonFormField<T>(
        initialValue: value,
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
          errorStyle: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabel != null
                  ? itemLabel!(item)
                  : item.toString(),
            ),
          ),
        )
            .toList(),
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}