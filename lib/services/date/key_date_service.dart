import 'package:dio/dio.dart';

import '../../core/api/dio_client.dart';
import '../../models/date/key_date_model.dart';

class KeyDateService {
  final DioClient _dioClient = DioClient();

  Future<List<KeyDateModel>> getKeyDates() async {
    try {
      final response = await _dioClient.dio.get(
        '/key-dates',
        options: Options(extra: {'skipAuth': true}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        return data
            .where((item) => item['enabled'] == true)
            .map((item) => KeyDateModel.fromJson(item))
            .toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  List<KeyDateModel> getFallbackKeyDates() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    final nextNextMonth = DateTime(now.year, now.month + 2, 1);

    return [
      KeyDateModel(
        id: '1',
        title: 'Rentrée universitaire',
        description: 'Début des cours pour tous les niveaux',
        date: nextMonth,
        isImportant: true,
        category: 'Académique',
      ),
      KeyDateModel(
        id: '2',
        title: 'Fin des inscriptions',
        description: 'Dernier délai pour s\'inscrire',
        date: DateTime(now.year, now.month + 1, 15),
        isImportant: true,
        category: 'Admission',
      ),
      KeyDateModel(
        id: '3',
        title: 'Début des examens',
        description: 'Session d\'examens du premier semestre',
        date: nextNextMonth,
        isImportant: true,
        category: 'Examens',
      ),
      KeyDateModel(
        id: '4',
        title: 'Journée porte ouverte',
        description: 'Visitez notre campus et découvrez nos formations',
        date: DateTime(now.year, now.month + 1, 10),
        isImportant: false,
        category: 'Événement',
      ),
      KeyDateModel(
        id: '5',
        title: 'Cérémonie de remise des diplômes',
        description: 'Célébration des diplômés de la promotion',
        date: DateTime(now.year, now.month + 3, 1),
        isImportant: false,
        category: 'Cérémonie',
      ),
    ]..sort((a, b) => a.date.compareTo(b.date));
  }
}
