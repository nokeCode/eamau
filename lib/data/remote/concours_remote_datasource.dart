import '../../models/concours/concours_model.dart';
import '../../models/concours/concours_detail_model.dart';
import '../../services/concours/concours_service.dart';
import '../../services/concours/concours_detail_service.dart';

class ConcoursRemoteDatasource {
  final ConcoursService service;
  final ConcoursDetailService detailService;

  ConcoursRemoteDatasource({ConcoursService? service, ConcoursDetailService? detailService})
      : service = service ?? ConcoursService(),
        detailService = detailService ?? ConcoursDetailService();

  Future<List<ConcoursModel>> fetchConcours({int page = 1, int limit = 10, String? query}) {
    return service.getConcours(page: page, limit: limit, query: query);
  }

  Future<ConcoursDetailModel> fetchDetail(String slug) {
    return detailService.getConcoursDetail(slug);
  }
}
