import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/news/news_category_model.dart';
import '../../models/news/news_model.dart';
import '../../routes/app_routes.dart';
import '../../services/publication/publication_service.dart';
import '../widgets/news/custom_bottom_nav.dart';
import '../widgets/news/featured_news_carousel.dart';
import '../widgets/news/news_card.dart';
import '../widgets/news/news_header.dart';

class PublicationScreen extends StatefulWidget {
  const PublicationScreen({super.key});

  @override
  State<PublicationScreen> createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> {
  final PublicationService _service = PublicationService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  int selectedCategory = 0;
  String _searchQuery = '';
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;
  String? _errorMessage;
  List<NewsModel> _publications = [];
  List<NewsModel> _featuredPublications = [];
  List<NewsCategoryModel> _categories = [];
  NewsMeta? _meta;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCategories();
    _loadFeaturedPublications();
    _loadInitialPublications();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _service.getCategories();
      if (!mounted) {
        return;
      }
      setState(() {
        _categories = categories;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _categories = const [NewsCategoryModel(id: 0, name: 'Toutes')];
      });
    }
  }

  Future<void> _loadFeaturedPublications() async {
    try {
      final featured = await _service.getFeaturedPublications();
      if (!mounted) {
        return;
      }
      setState(() {
        _featuredPublications = featured;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _featuredPublications = [];
      });
    }
  }

  Future<void> _loadInitialPublications() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isInitialLoading = true;
      _isLoadingMore = false;
      _errorMessage = null;
      _publications = [];
      _meta = null;
      _hasReachedEnd = false;
    });

    try {
      final result = _searchQuery.trim().isEmpty
          ? await _service.getPublicationsPage(
              page: 1,
              categoryId: selectedCategory == 0 ? null : selectedCategory,
            )
          : await _service.searchPublications(
              _searchQuery,
              page: 1,
              categoryId: selectedCategory == 0 ? null : selectedCategory,
            );

      if (!mounted) {
        return;
      }

      setState(() {
        _publications = result.items;
        _meta = result.meta;
        _hasReachedEnd = result.meta.page >= result.meta.lastPage;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '$error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _loadMorePublications() async {
    if (_isLoadingMore ||
        _hasReachedEnd ||
        _meta == null ||
        _isInitialLoading) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = _searchQuery.trim().isEmpty
          ? await _service.getPublicationsPage(
              page: _meta!.page + 1,
              categoryId: selectedCategory == 0 ? null : selectedCategory,
            )
          : await _service.searchPublications(
              _searchQuery,
              page: _meta!.page + 1,
              categoryId: selectedCategory == 0 ? null : selectedCategory,
            );

      if (!mounted) {
        return;
      }

      setState(() {
        _publications.addAll(result.items);
        _meta = result.meta;
        _hasReachedEnd = result.meta.page >= result.meta.lastPage;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '$error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> loadPublications(int categoryId) async {
    setState(() {
      selectedCategory = categoryId;
      _searchController.clear();
      _searchQuery = '';
    });
    await _loadInitialPublications();
  }

  Future<void> _refreshPublications() async {
    await _loadInitialPublications();
  }

  void _onSearchChanged(String value) {
    final query = value.trim();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _searchQuery = query;
      });
      _loadInitialPublications();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePublications();
    }
  }

  void _openPublicationDetail(NewsModel publication) {
    if (publication.slug.isEmpty) {
      return;
    }
    Navigator.pushNamed(
      context,
      AppRoutes.publicationDetail,
      arguments: publication.slug,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories.isEmpty
        ? const [NewsCategoryModel(id: 0, name: 'Toutes')]
        : _categories;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A84FF), Colors.white],
                stops: [0.15, 0.55],
              ),
            ),
          ),
          Column(
            children: [
              NewsHeader(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: loadPublications,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rechercher une publication scientifique',
                      icon: Icon(Icons.search, color: Color(0xFF0A84FF)),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshPublications,
                  child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: _buildListContent(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListContent() {
    if (_isInitialLoading && _publications.isEmpty) {
      return [
        const SizedBox(height: 8),
        _buildFeaturedSkeleton(),
        const SizedBox(height: 24),
        _buildNewsCardSkeleton(),
        const SizedBox(height: 12),
        _buildNewsCardSkeleton(),
      ];
    }

    if (_errorMessage != null) {
      return [
        const SizedBox(height: 40),
        Center(
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ];
    }

    if (_publications.isEmpty) {
      return [
        const SizedBox(height: 40),
        const Center(
          child: Text(
            'Aucune publication scientifique disponible pour le moment.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ];
    }

    final widgets = <Widget>[
      const SizedBox(height: 8),
      FeaturedNewsCarousel(
        news: _featuredPublications.isEmpty ? _publications : _featuredPublications,
        onNewsTapped: _openPublicationDetail,
      ),
      const SizedBox(height: 24),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dernières publications scientifiques',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      const SizedBox(height: 12),
    ];

    widgets.addAll(
      _publications.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NewsCard(news: item, onTap: () => _openPublicationDetail(item)),
        ),
      ),
    );

    if (_isLoadingMore) {
      widgets.addAll([const SizedBox(height: 8), _buildNewsCardSkeleton()]);
    }

    return widgets;
  }

  Widget _buildFeaturedSkeleton() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }

  Widget _buildNewsCardSkeleton() {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
