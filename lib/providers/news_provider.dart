import 'package:flutter/foundation.dart';

import '../data/local/news_local_datasource.dart';
import '../data/remote/news_remote_datasource.dart';
import '../data/repositories/news_repository.dart';
import '../models/news/news_model.dart';
import '../services/news/news_service.dart';

class NewsProvider extends ChangeNotifier {
  late final NewsRepository _repository;

  List<NewsModel> _items = [];
  bool _isLoading = false;
  String? _error;

  List<NewsModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NewsProvider() {
    final local = NewsLocalDatasource();
    final remote = NewsRemoteDatasource(service: NewsService());
    _repository = NewsRepository(local: local, remote: remote);
  }

  Future<void> loadNews() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _repository.getNewsList();
      _items = data;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
