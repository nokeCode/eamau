import '../../models/filiere/filiere_model.dart';

class FiliereLocalDatasource {
  Future<List<Filiere>> getAllFilieres() async => [];
  Future<void> saveFilieres(List<Filiere> filieres) async {}
  Future<Filiere?> getFiliereBySlug(String slug) async => null;
}
