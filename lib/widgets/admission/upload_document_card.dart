import 'dart:io';

import 'package:flutter/material.dart';

class UploadDocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final File? file;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  const UploadDocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onUpload,
    this.file,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool uploaded = file != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffEEF5FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xff0B4EA2),
            ),
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
                  uploaded
                      ? file!.path.split('/').last
                      : subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          uploaded
              ? IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          )
              : IconButton(
            onPressed: onUpload,
            icon: const Icon(
              Icons.cloud_upload_outlined,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}