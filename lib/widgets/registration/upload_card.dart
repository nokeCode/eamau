import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {
  final String label;
  final String? selectedType;
  final List<String> options;
  final VoidCallback onPick;
  final ValueChanged<String?> onTypeChanged;

  const UploadCard({
    super.key,
    required this.label,
    required this.selectedType,
    required this.options,
    required this.onPick,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBE7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF173B7A),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: () {
              try {
                if (selectedType == null) return null;
                // Deduplicate options and ensure initialValue exists in the
                // unique list to avoid duplicate-value assertion.
                final unique = <String>{};
                for (final o in options) {
                  unique.add(o);
                }
                return unique.contains(selectedType) ? selectedType : null;
              } catch (_) {}
              return null;
            }(),
            decoration: InputDecoration(
              labelText: 'Type de pièce',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: () {
              final seen = <String>{};
              final list = <DropdownMenuItem<String>>[];
              for (final option in options) {
                if (seen.add(option)) {
                  list.add(DropdownMenuItem<String>(value: option, child: Text(option)));
                }
              }
              return list;
            }(),
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('Choisir un fichier'),
            ),
          ),
        ],
      ),
    );
  }
}
