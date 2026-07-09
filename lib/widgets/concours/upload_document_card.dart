import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadDocumentCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<File?> onFileSelected;

  const UploadDocumentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onFileSelected,
  });

  @override
  State<UploadDocumentCard> createState() =>
      _UploadDocumentCardState();
}

class _UploadDocumentCardState
    extends State<UploadDocumentCard> {
  String? fileName;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    final file = File(result.files.single.path!);

    setState(() {
      fileName = result.files.single.name;
    });

    widget.onFileSelected(file);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffE8F1FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xff1E63F1),
                size: 30,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    fileName ?? widget.subtitle,
                    style: TextStyle(
                      color: fileName == null
                          ? Colors.grey
                          : Colors.green,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.cloud_upload_outlined,
              color: Color(0xff1E63F1),
            ),
          ],
        ),
      ),
    );
  }
}