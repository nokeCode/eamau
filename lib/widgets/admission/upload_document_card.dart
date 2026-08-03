import 'dart:io';

import 'package:flutter/material.dart';

enum UploadStatus { none, selected, uploading, success, failure }

class UploadDocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final File? file;
  final File? previewFile;
  final UploadStatus status;
  final String? failureMessage;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  const UploadDocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
    required this.onUpload,
    this.file,
    this.previewFile,
    this.failureMessage,
    this.onDelete,
  });

  bool _isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    final File? previewSource = previewFile ?? file;
    final bool hasFile = file != null;
    final bool showImagePreview = previewSource != null && _isImageFile(previewSource.path);
    final String fileName = hasFile ? file!.path.split('/').last : subtitle;
    final Widget actionWidget;
    final String statusLabel;
    final Color statusColor;

    switch (status) {
      case UploadStatus.uploading:
        actionWidget = SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: Colors.blue.shade700,
          ),
        );
        statusLabel = 'Envoi en cours...';
        statusColor = Colors.blue.shade700;
        break;
      case UploadStatus.success:
        actionWidget = IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        statusLabel = 'Upload réussi';
        statusColor = Colors.green.shade700;
        break;
      case UploadStatus.failure:
        actionWidget = IconButton(
          onPressed: onUpload,
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
        statusLabel = failureMessage ?? 'Échec de l’envoi';
        statusColor = Colors.red.shade700;
        break;
      case UploadStatus.selected:
        actionWidget = IconButton(
          onPressed: onUpload,
          icon: const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
        );
        statusLabel = 'Fichier prêt à envoyer';
        statusColor = Colors.blue.shade700;
        break;
      case UploadStatus.none:
        actionWidget = IconButton(
          onPressed: onUpload,
          icon: const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
        );
        statusLabel = subtitle;
        statusColor = Colors.grey.shade600;
        break;
    }

    return InkWell(
      onTap: onUpload,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xff0B4EA2)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0B4EA2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fileName,
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: status == UploadStatus.failure ? const Color(0xFFFFEBEE) : const Color(0xFFF1F5FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actionWidget,
              ],
            ),
            if (showImagePreview) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(previewSource, height: 110, width: double.infinity, fit: BoxFit.cover),
              ),
            ],
          ],
        ),
      ),
    );
  }
}