import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'upload_document_card.dart';

enum _UploadSource { camera, gallery, document }

class AdmissionUploadSection extends StatefulWidget {
  const AdmissionUploadSection({super.key});

  @override
  State<AdmissionUploadSection> createState() => _AdmissionUploadSectionState();
}

class _AdmissionUploadSectionState extends State<AdmissionUploadSection> {

  final Map<String, File?> documents = {
    "Photo d'identité": null,
    "Acte de naissance": null,
    "Diplôme": null,
    "Relevé de notes": null,
    "Lettre de motivation": null,
    "Casier judiciaire": null,
    "Certificat médical": null,
  };

  Future<void> pickDocument(String key) async {
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

      setState(() {
        documents[key] = File(path);
      });
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == _UploadSource.camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() {
      documents[key] = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: documents.entries.map((doc) {
          return UploadDocumentCard(
            title: doc.key,
            subtitle: "PDF, JPG, PNG - Max 5 Mo",
            icon: Icons.description_outlined,
            file: doc.value,
            onUpload: () => pickDocument(doc.key),
            onDelete: () {
              setState(() {
                documents[doc.key] = null;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}