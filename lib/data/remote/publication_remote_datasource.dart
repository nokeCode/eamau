import '../../services/publication/publication_service.dart';
import '../../models/news/news_model.dart';
import '../../models/news/news_category_model.dart';

class PublicationRemoteDatasource {
  final PublicationService service;

  PublicationRemoteDatasource({PublicationService? service}) : service = service ?? PublicationService();

  Future<PublicationPageResult> fetchPublicationsPage({int page = 1, int limit = 12, int? categoryId, bool featured = false}) {
    return service.getPublicationsPage(page: page, limit: limit, categoryId: categoryId, featured: featured);
  }

  Future<PublicationPageResult> searchPublications(String query, {int page = 1, int limit = 12, int? categoryId}) {
    return service.searchPublications(query, page: page, limit: limit, categoryId: categoryId);
  }

  Future<List<NewsModel>> fetchFeatured() async {
    final items = await service.getFeaturedPublications();
    return items;
  }

  Future<NewsModel> fetchBySlug(String slug) {
    return service.getPublicationBySlug(slug);
  }

  Future<List<NewsCategoryModel>> fetchCategories() {
    return service.getCategories();
  }
}
