import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/sync/sync_engine.dart';
import '../../services/admission/admission_request_service.dart';
import '../../data/repositories/admission_repository.dart';
import '../../data/local/admission_local_datasource.dart';
import '../../data/remote/admission_remote_datasource.dart';
import 'upload_document_card.dart';

enum _UploadSource { camera, gallery, document }

/// Outcome of [AdmissionUploadSectionState._uploadOrQueue], distinct enough
/// to tell the user *why* a document ended up queued instead of uploaded:
/// no network at all vs. a network that's up but couldn't reach the API
/// (Wi-Fi connected != API reachable).
enum _DocumentSyncOutcome { uploaded, queuedOffline, queuedApiUnreachable, failed }

/// Upload section supports two modes:
/// - remoteRequestId != null: upload immediately via `service`
/// - localDraftId != null: attach files locally to draft and enqueue uploads
class AdmissionUploadSection extends StatefulWidget {
  final int? remoteRequestId;
  final int? localDraftId;
  final AdmissionRequestService? service;

  const AdmissionUploadSection({super.key, this.remoteRequestId, this.localDraftId, this.service});

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

  /// How long [_uploadOrQueue] waits for the upload to actually finish
  /// before giving up on the UI's behalf, same idea as `AdmissionRepository.
  /// _quickSyncAttempt`: the document is already durably saved locally
  /// before this wait even starts, so timing out here only means "still
  /// queued", never "lost".
  static const Duration _quickUploadAttempt = Duration(seconds: 10);

  /// Saves a just-picked file for [key] locally (durable, instant — never
  /// blocks on the network) and, if online, gives the upload a short bounded
  /// window to actually finish before falling back to "queued". Previously
  /// this awaited the full attach-and-upload chain unbounded, which is why
  /// picking a document could feel stuck for as long as the underlying HTTP
  /// timeout (up to ~30s) even though it would eventually succeed.
  Future<_DocumentSyncOutcome> _uploadOrQueue(String key, File file) async {
    if (widget.localDraftId == null) {
      if (mounted) {
        setState(() {
          _documentStatus[key] = UploadStatus.failure;
          _documentErrors[key] = 'Aucune demande active pour joindre ce document.';
        });
      }
      debugPrint('[ADMISSION][DOCUMENT][ERROR] localDraftId indisponible clé=$key');
      return _DocumentSyncOutcome.failed;
    }

    final attachmentType = AdmissionRequestService.normalizeAttachmentTypeCode(key);
    debugPrint('[ADMISSION][DOCUMENT] sélection fichier=${file.path.split('/').last} clé=$key');

    if (mounted) {
      setState(() {
        _documentStatus[key] = UploadStatus.uploading;
        _documentErrors[key] = null;
      });
    }

    // `remote` is never actually used by attachDocumentToDraft/
    // getDocumentsForDraft below (only `local` is), but the constructor
    // requires a real, non-null instance — `null as dynamic` used to be
    // passed here instead, which throws "type 'Null' is not a subtype of
    // type 'AdmissionRemoteDatasource'" the moment this line runs (Dart's
    // sound null safety rejects assigning null to a non-nullable field even
    // through a dynamic cast). AdmissionRemoteDatasource is itself just an
    // unused stub, so constructing a real one here is free and harmless.
    final repo = AdmissionRepository(local: AdmissionLocalDatasource(), remote: AdmissionRemoteDatasource());
    final int docId;
    try {
      docId = await repo.attachDocumentToDraft(
        draftId: widget.localDraftId!,
        file: file,
        fileName: file.path.split('/').last,
        mimeType: 'application/octet-stream',
        attachmentType: attachmentType,
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _documentStatus[key] = UploadStatus.failure;
          _documentErrors[key] = error.toString();
        });
      }
      debugPrint('[ADMISSION][DOCUMENT][ERROR] échec sauvegarde locale clé=$key error=$error');
      return _DocumentSyncOutcome.failed;
    }
    debugPrint('[ADMISSION][DOCUMENT] sauvegardé localement documentId=$docId clé=$key');

    // The document is already durably saved at this point — everything
    // below is just "did it also finish uploading within our short
    // window?". It must never leave the UI stuck on "uploading": any
    // unexpected exception here (SyncEngine hiccup, a transient DB read
    // error...) falls back to "queued" rather than propagating and
    // silently freezing the spinner forever.
    var online = false;
    var synced = false;
    try {
      online = await ConnectivityService().isOnline();
      debugPrint('[ADMISSION][DOCUMENT] documentId=$docId online=$online');

      if (online) {
        debugPrint('[ADMISSION][DOCUMENT] tentative réseau courte (max ${_quickUploadAttempt.inSeconds}s) '
            'documentId=$docId');
        await SyncEngine().processQueueNow().timeout(
          _quickUploadAttempt,
          onTimeout: () {
            debugPrint('[ADMISSION][DOCUMENT] tentative réseau courte non terminée documentId=$docId '
                '-> la synchronisation continue en arrière-plan');
          },
        );
      }

      final docs = await repo.getDocumentsForDraft(widget.localDraftId!);
      synced = docs.any((d) => d.id == docId && d.uploadStatus == 'synced');
    } catch (error, stackTrace) {
      debugPrint('[ADMISSION][DOCUMENT][ERROR] exception pendant la tentative réseau documentId=$docId '
          'type=${error.runtimeType} error=$error -> considéré comme en attente');
      debugPrint('[ADMISSION][DOCUMENT][ERROR] stackTrace=$stackTrace');
      synced = false;
    }
    debugPrint('[ADMISSION][DOCUMENT] statut final documentId=$docId synced=$synced clé=$key');

    if (mounted) {
      setState(() {
        _documentStatus[key] = synced ? UploadStatus.success : UploadStatus.queued;
        _documentErrors[key] = null;
      });
    }

    if (synced) return _DocumentSyncOutcome.uploaded;
    return online ? _DocumentSyncOutcome.queuedApiUnreachable : _DocumentSyncOutcome.queuedOffline;
  }

  Future<bool> uploadPendingDocuments() async {
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
      final outcome = await _uploadOrQueue(entry.key, entry.value!);
      if (outcome == _DocumentSyncOutcome.failed) allSuccess = false;
    }
    return allSuccess;
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

  // Documents always go through the local draft + SyncQueue path now (see
  // _uploadOrQueue), so localDraftId is the only thing that actually gates
  // whether there's somewhere to attach a document to.
  bool get _hasActiveRequest => widget.localDraftId != null;

  Future<void> pickDocument(String key) async {
    if (!_hasActiveRequest) {
      // Nothing to attach the document to yet: no local draft, no remote
      // request. This happens when the user reaches the "Pièces à joindre"
      // section (same scrollable form) before validating the base
      // information — there is genuinely no draft/request id to read at
      // that point, it isn't lost or misplumbed. Guard before even opening
      // the file picker so the message is immediate and unambiguous,
      // instead of letting them pick a file first and only then failing.
      debugPrint('[ADMISSION][DOCUMENT] pickDocument bloqué clé=$key: aucune demande active '
          '(remoteRequestId et localDraftId sont tous les deux null)');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            backgroundColor: Color(0xFFB07D00),
            content: Text(
              'Veuillez d’abord valider vos informations personnelles (bouton « Continuer ») '
              'avant de joindre vos documents.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }

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

      await _pickedFileAndNotify(key, picked);
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

    await _pickedFileAndNotify(key, picked);
  }

  /// Runs the upload-or-queue decision for a just-picked file and shows a
  /// SnackBar reflecting what actually happened, matching the outcome
  /// recorded in [_documentStatus] — with a message that tells offline
  /// apart from "Wi-Fi connected but API unreachable", per outcome 3 of the
  /// spec (that distinction is the whole point: a connected Wi-Fi icon
  /// doesn't mean the API answered).
  Future<void> _pickedFileAndNotify(String key, File picked) async {
    final outcome = await _uploadOrQueue(key, picked);
    if (!mounted) return;

    if (outcome == _DocumentSyncOutcome.failed) {
      final message = _formatUploadError(_documentErrors[key]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFFB00020),
          content: Text('Échec de l’envoi : $message'),
          duration: const Duration(seconds: 8),
        ),
      );
      return;
    }

    final (Color color, String message) = switch (outcome) {
      _DocumentSyncOutcome.uploaded => (const Color(0xFF2E7D32), 'Document envoyé.'),
      _DocumentSyncOutcome.queuedOffline => (
          const Color(0xFFB07D00),
          'Pas de connexion. Le document a été enregistré et sera envoyé automatiquement.',
        ),
      _DocumentSyncOutcome.queuedApiUnreachable => (
          const Color(0xFFB07D00),
          'Connexion au serveur impossible. Le document a été enregistré et sera envoyé automatiquement.',
        ),
      _DocumentSyncOutcome.failed => (const Color(0xFFB00020), ''), // unreachable, handled above
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
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
        children: [
          if (!_hasActiveRequest)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD98E)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFB07D00), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Validez d’abord vos informations personnelles ci-dessus (bouton « Continuer ») '
                      'pour pouvoir joindre vos documents.',
                      style: TextStyle(color: Color(0xFFB07D00), fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ...documents.entries.map((doc) {
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
          }),
        ],
      ),
    );
  }
}
