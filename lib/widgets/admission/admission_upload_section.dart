import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/admission/admission_request_service.dart';
import 'upload_document_card.dart';

enum _UploadSource { camera, gallery, document }

class AdmissionUploadSection extends StatefulWidget {
  final int? requestId;
  final AdmissionRequestService? service;

  const AdmissionUploadSection({super.key, this.requestId, this.service});

  @override
  State<AdmissionUploadSection> createState() => AdmissionUploadSectionState();
}

class AdmissionUploadSectionState extends State<AdmissionUploadSection> {
  final Map<String, File?> documents = {
    "Photo d'identité": null,
    "CNI ou Passeport": null,
    "Acte de naissance": null,
    "Diplôme": null,
    "Relevé de notes": null,
    "Lettre de motivation": null,
    "Casier judiciaire": null,
    "Certificat médical": null,
    "CV": null,
  };

  final Map<String, UploadStatus> _documentStatus = {
    "Photo d'identité": UploadStatus.none,
    "CNI ou Passeport": UploadStatus.none,
    "Acte de naissance": UploadStatus.none,
    "Diplôme": UploadStatus.none,
    "Relevé de notes": UploadStatus.none,
    "Lettre de motivation": UploadStatus.none,
    "Casier judiciaire": UploadStatus.none,
    "Certificat médical": UploadStatus.none,
    "CV": UploadStatus.none,
  };

  final Map<String, File?> _previewFiles = {
    "Photo d'identité": null,
    "CNI ou Passeport": null,
    "Acte de naissance": null,
    "Diplôme": null,
    "Relevé de notes": null,
    "Lettre de motivation": null,
    "Casier judiciaire": null,
    "Certificat médical": null,
    "CV": null,
  };

  final Map<String, String?> _documentErrors = {
    "Photo d'identité": null,
    "CNI ou Passeport": null,
    "Acte de naissance": null,
    "Diplôme": null,
    "Relevé de notes": null,
    "Lettre de motivation": null,
    "Casier judiciaire": null,
    "Certificat médical": null,
    "CV": null,
  };

  Future<bool> uploadPendingDocuments() async {
    if (widget.requestId == null || widget.service == null) return false;

    final pendingFiles = documents.entries
        .where(
          (entry) =>
              entry.value != null &&
              _documentStatus[entry.key] != UploadStatus.success,
        )
        .toList();
    if (pendingFiles.isEmpty) return false;

    bool allSuccess = true;
    for (final entry in pendingFiles) {
      setState(() {
        _documentStatus[entry.key] = UploadStatus.uploading;
        _documentErrors[entry.key] = null;
      });

      try {
        final preparedFile = await widget.service!.prepareFileForUpload(
          entry.value!,
          entry.key,
        );
        final attachmentType =
            AdmissionRequestService.normalizeAttachmentTypeCode(entry.key);
        final success = await widget.service!.uploadDocument(
          widget.requestId!,
          attachmentType,
          preparedFile,
        );

        if (success) {
          setState(() {
            _documentStatus[entry.key] = UploadStatus.success;
            _documentErrors[entry.key] = null;
          });
          continue;
        }

        allSuccess = false;
        setState(() {
          _documentStatus[entry.key] = UploadStatus.failure;
          _documentErrors[entry.key] = widget.service!.lastErrorMessage;
        });
      } catch (error) {
        allSuccess = false;
        setState(() {
          _documentStatus[entry.key] = UploadStatus.failure;
          _documentErrors[entry.key] = error.toString();
        });
      }
    }

    return allSuccess;
  }

  Future<void> _uploadPendingDocumentsAndNotify() async {
    if (widget.requestId == null || widget.service == null) return;
    final success = await uploadPendingDocuments();
    if (!mounted) return;

    if (!success) {
      final rawError = widget.service!.lastErrorMessage;
      final message = _formatUploadError(rawError);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: const Color(0xFFB00020),
          content: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Échec de l’envoi des documents\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: message,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 8),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: const Color(0xFF2E7D32),
        content: const Text('Documents uploadés avec succès.'),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _formatUploadError(String? rawError) {
    if (rawError == null || rawError.trim().isEmpty) {
      return 'Une erreur interne est survenue. Veuillez réessayer.';
    }

    try {
      final decoded = jsonDecode(rawError);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {
      // ignore parsing errors
    }

    return rawError.trim();
  }

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
      final result = await FilePicker.platform.pickFiles(withData: true);
      if (result == null || result.files.isEmpty) return;

      final selected = result.files.single;
      File? picked;

      if (selected.path != null && selected.path!.isNotEmpty) {
        final candidate = File(selected.path!);
        if (await candidate.exists() && await candidate.length() > 0) {
          picked = candidate;
        }
      }

      if (picked == null &&
          selected.bytes != null &&
          selected.bytes!.isNotEmpty) {
        picked = await _writeTempFile(selected.bytes!, selected.name);
      }

      if (picked == null) {
        setState(() {
          _documentErrors[key] = 'Impossible de lire le fichier sélectionné.';
          _documentStatus[key] = UploadStatus.failure;
        });
        return;
      }

      setState(() {
        documents[key] = picked;
        _previewFiles[key] = picked;
        _documentStatus[key] = UploadStatus.selected;
        _documentErrors[key] = null;
      });

      if (widget.requestId != null && widget.service != null) {
        await _uploadPendingDocumentsAndNotify();
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
    final picked = File(pickedFile.path);
    if (!await picked.exists() || await picked.length() == 0) {
      setState(() {
        _documentErrors[key] = 'Impossible de lire l’image sélectionnée.';
        _documentStatus[key] = UploadStatus.failure;
      });
      return;
    }
    setState(() {
      documents[key] = picked;
      _previewFiles[key] = picked;
      _documentStatus[key] = UploadStatus.selected;
      _documentErrors[key] = null;
    });

    if (widget.requestId != null && widget.service != null) {
      await _uploadPendingDocumentsAndNotify();
    }
  }

  Future<File> _writeTempFile(Uint8List bytes, String name) async {
    final tempPath = '${Directory.systemTemp.path}/$name';
    final file = File(tempPath);
    await file.writeAsBytes(bytes, flush: true);
    return file;
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
            previewFile: _previewFiles[doc.key],
            status: _documentStatus[doc.key] ?? UploadStatus.none,
            failureMessage: _documentErrors[doc.key],
            onUpload: () => pickDocument(doc.key),
            onDelete: () {
              setState(() {
                documents[doc.key] = null;
                _previewFiles[doc.key] = null;
                _documentStatus[doc.key] = UploadStatus.none;
                _documentErrors[doc.key] = null;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
