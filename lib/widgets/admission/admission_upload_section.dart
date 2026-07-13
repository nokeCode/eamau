import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'upload_document_card.dart';

class AdmissionUploadSection extends StatefulWidget {
  const AdmissionUploadSection({super.key});

  @override
  State<AdmissionUploadSection> createState() =>
      _AdmissionUploadSectionState();
}

class _AdmissionUploadSectionState
    extends State<AdmissionUploadSection> {

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
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        documents[key] = File(result.files.single.path!);
      });
    }
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