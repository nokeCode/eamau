import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum _UploadSource { camera, gallery, document }

class IdentityUploadField extends StatefulWidget {
  final String label;
  final String subtitle;
  final ValueChanged<File?> onFileSelected;
  final ValueChanged<String> onFileNameChanged;
  final String? initialFileName;

  const IdentityUploadField({
    super.key,
    required this.label,
    required this.subtitle,
    required this.onFileSelected,
    required this.onFileNameChanged,
    this.initialFileName,
  });

  @override
  State<IdentityUploadField> createState() => _IdentityUploadFieldState();
}

class _IdentityUploadFieldState extends State<IdentityUploadField> {
  File? _selectedFile;
  String? _fileName;

  static const List<String> _imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.heic',
  ];

  bool get _selectedFileIsImage {
    if (_selectedFile == null) return false;
    final path = _selectedFile!.path.toLowerCase();
    return _imageExtensions.any(path.endsWith);
  }

  Future<void> _pickFile() async {
    final source = await showModalBottomSheet<_UploadSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Prendre une photo'),
                onTap: () => Navigator.pop(sheetContext, _UploadSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choisir depuis la galerie'),
                onTap: () => Navigator.pop(sheetContext, _UploadSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text('Sélectionner un document'),
                onTap: () => Navigator.pop(sheetContext, _UploadSource.document),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    if (source == _UploadSource.document) {
      final result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.isEmpty) return;

      final path = result.files.single.path;
      if (path == null || path.isEmpty) return;

      final file = File(path);
      setState(() {
        _selectedFile = file;
        _fileName = result.files.single.name;
      });
      widget.onFileSelected(file);
      widget.onFileNameChanged(_fileName!);
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == _UploadSource.camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    setState(() {
      _selectedFile = file;
      _fileName = pickedFile.name;
    });
    widget.onFileSelected(file);
    widget.onFileNameChanged(_fileName!);
  }

  @override
  Widget build(BuildContext context) {
    final fileLabel = _fileName ?? widget.initialFileName ?? widget.subtitle;

    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                    color: const Color(0xFFEEF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.upload_file_outlined, color: Color(0xFF1682F8)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fileLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: _selectedFile == null ? const Color(0xFF64748B) : const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF64748B)),
              ],
            ),
            if (_selectedFileIsImage && _selectedFile != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedFile!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
