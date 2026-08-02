import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

enum _UploadSource { camera, gallery, document }

class UploadDocumentCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<File?> onFileSelected;
  final bool isImageField;

  const UploadDocumentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onFileSelected,
    this.isImageField = false,
  });

  @override
  State<UploadDocumentCard> createState() => _UploadDocumentCardState();
}

class _UploadDocumentCardState extends State<UploadDocumentCard> {
  String? fileName;
  File? selectedFile;

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
    if (selectedFile == null) return false;
    final path = selectedFile!.path.toLowerCase();
    return _imageExtensions.any(path.endsWith);
  }

  bool _isImagePath(String path) {
    final normalizedPath = path.toLowerCase();
    return _imageExtensions.any(normalizedPath.endsWith);
  }

  String _safePdfBaseName(String title) {
    final normalized = title.trim().replaceAll(RegExp(r'[^\w\s-]'), '');
    final sanitized = normalized.replaceAll(RegExp(r'\s+'), '_');
    final cleaned = sanitized.replaceAll(RegExp(r'[^\w-]'), '_');
    return cleaned.isEmpty ? 'document' : cleaned;
  }

  String _pdfFileName(String title) {
    return '${_safePdfBaseName(title)}.pdf';
  }

  Future<File> _convertImageToPdf(File sourceFile, String title) async {
    final bytes = await sourceFile.readAsBytes();
    final pdf = pw.Document();
    final image = pw.MemoryImage(bytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) =>
            pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );

    final pdfName = _pdfFileName(title);
    final outputFile = File('${Directory.systemTemp.path}/$pdfName');
    await outputFile.writeAsBytes(await pdf.save());
    return outputFile;
  }

  Future<void> _pickFile() async {
    final source = await showModalBottomSheet<_UploadSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Prendre une photo'),
                onTap: () => Navigator.pop(context, _UploadSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choisir depuis la galerie'),
                onTap: () => Navigator.pop(context, _UploadSource.gallery),
              ),
              if (!widget.isImageField)
                ListTile(
                  leading: const Icon(Icons.insert_drive_file_outlined),
                  title: const Text('Sélectionner un document'),
                  onTap: () => Navigator.pop(context, _UploadSource.document),
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
      if (_isImagePath(file.path)) {
        final pdfFile = await _convertImageToPdf(file, widget.title);
        setState(() {
          selectedFile = file;
          fileName = _pdfFileName(widget.title);
        });
        widget.onFileSelected(pdfFile);
      } else {
        setState(() {
          selectedFile = file;
          fileName = result.files.single.name;
        });
        widget.onFileSelected(file);
      }
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == _UploadSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    if (_isImagePath(file.path)) {
      final pdfFile = await _convertImageToPdf(file, widget.title);
      setState(() {
        selectedFile = file;
        fileName = _pdfFileName(widget.title);
      });
      widget.onFileSelected(pdfFile);
      return;
    }

    setState(() {
      selectedFile = file;
      fileName = pickedFile.name;
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
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: fileName == null ? Colors.grey : Colors.green,
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
            if (selectedFile != null && _selectedFileIsImage) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  selectedFile!,
                  height: 110,
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
