import '../../models/admission/admission_request_model.dart';
import '../local/admission_local_datasource.dart';
import '../remote/admission_remote_datasource.dart';

class AdmissionRepository {
  final AdmissionLocalDatasource local;
  final AdmissionRemoteDatasource remote;

  AdmissionRepository({required this.local, required this.remote});

  Future<void> saveDraft(AdmissionRequestModel draft) => local.saveDraft(draft);

  Future<bool> submit(AdmissionRequestModel draft, List<String> documents) async {
    // write to local queue then try to sync
    return await remote.submitAdmission(draft, documents);
  }
}
