import '../../models/filiere/filiere_model.dart';
import '../local/filiere_local_datasource.dart';
import '../remote/filiere_remote_datasource.dart';

class FiliereRepository {
  final FiliereLocalDatasource local;
  final FiliereRemoteDatasource remote;

  FiliereRepository({required this.local, required this.remote});

  Future<List<Filiere>> getFilieres() async {
    final localData = await local.getAllFilieres();
    if (localData.isNotEmpty) return localData;
    final remoteData = await remote.fetchFilieres();
    await local.saveFilieres(remoteData);
    return remoteData;
  }
}
