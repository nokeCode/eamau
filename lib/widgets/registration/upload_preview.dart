import 'package:flutter/material.dart';
import '../../models/registration/registration_referential_model.dart';

class UploadPreview extends StatelessWidget {
  final List<RegistrationDocument> documents;
  final ValueChanged<int> onRemove;

  const UploadPreview({
    super.key,
    required this.documents,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Aucune pièce ajoutée pour le moment.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return Column(
      children: documents.asMap().entries.map((entry) {
        final index = entry.key;
        final document = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDBE7FF)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF0F4DA8),
                child: Icon(Icons.description_outlined, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.fileName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${document.type} • ${document.displaySize}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFB00020),
                ),
                onPressed: () => onRemove(index),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
