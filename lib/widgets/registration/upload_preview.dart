import 'package:flutter/material.dart';
import '../../models/registration/registration_referential_model.dart';

class UploadPreview extends StatelessWidget {
  final List<RegistrationDocument> documents;
  final ValueChanged<int> onRemove;
  final ValueChanged<int> onPreview;

  const UploadPreview({
    super.key,
    required this.documents,
    required this.onRemove,
    required this.onPreview,
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
        final isSynced = document.uploadStatus == 'synced';
        final isError = document.uploadStatus == 'error' || document.uploadStatus == 'failed';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSynced
                  ? const Color(0xFF2E7D32).withOpacity(0.3)
                  : isError
                      ? const Color(0xFFB00020).withOpacity(0.3)
                      : const Color(0xFFDBE7FF),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isSynced
                    ? const Color(0xFF2E7D32)
                    : isError
                        ? const Color(0xFFB00020)
                        : const Color(0xFF0F4DA8),
                child: Icon(
                  isSynced
                      ? Icons.check
                      : isError
                          ? Icons.error_outline
                          : Icons.description_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            document.fileName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSynced)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Synchronisé',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'En attente',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
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
                  Icons.remove_red_eye_outlined,
                  color: Color(0xFF0F4DA8),
                ),
                onPressed: () => onPreview(index),
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
