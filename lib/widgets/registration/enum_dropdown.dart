import 'package:flutter/material.dart';

class EnumDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  const EnumDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Deduplicate items by label to avoid multiple DropdownMenuItem with
    // the same logical value which causes Flutter assertion failures.
    final List<T> uniqueItems = [];
    final seen = <String>{};
    for (final item in items) {
      try {
        final label = labelBuilder(item);
        if (!seen.contains(label)) {
          seen.add(label);
          uniqueItems.add(item);
        }
      } catch (_) {
        if (!uniqueItems.contains(item)) uniqueItems.add(item);
      }
    }

    final T? selected = () {
      try {
        if (value == null) return null;
        // Prefer the actual instance from uniqueItems to avoid identity mismatches.
        for (final item in uniqueItems) {
          if (item == value) return item;
        }
        final valueLabel = labelBuilder(value as T);
        for (final item in uniqueItems) {
          if (labelBuilder(item) == valueLabel) return item;
        }
      } catch (_) {}
      return null;
    }();

    return DropdownButtonFormField<T>(
      isExpanded: true,
      initialValue: selected,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0F4DA8)),
        filled: true,
        fillColor: const Color(0xFFF5F7FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: uniqueItems
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                labelBuilder(item),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
