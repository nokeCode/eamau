import 'dart:async';

import 'package:flutter/material.dart';

import '../models/filiere/filiere_model.dart';
import '../services/filiere/filiere_service.dart';
import '../widgets/filiere/filiere_card.dart';
import '../widgets/filiere/filiere_search_bar.dart';
import 'filiere_detail_screen.dart';

class FiliereScreen extends StatefulWidget {
  const FiliereScreen({super.key});

  @override
  State<FiliereScreen> createState() => _FiliereScreenState();
}

class _FiliereScreenState extends State<FiliereScreen> {
  final FiliereService _service = FiliereService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Filiere> _filieres = [];
  Timer? _debounce;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int _lastPage = 1;
  String _query = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    _loadFilieres();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _query = _searchController.text.trim();
      });
      _loadFilieres(reset: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadFilieres();
    }
  }

  Future<void> _loadFilieres({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _hasMore = true;
      _filieres.clear();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else if (_isLoadingMore || !_hasMore) {
      return;
    }

    if (!reset) {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final result = await _service.getFilieresPage(
        page: _currentPage,
        query: _query.isEmpty ? null : _query,
      );

      if (!mounted) return;

      setState(() {
        if (reset || _currentPage == 1) {
          _filieres
            ..clear()
            ..addAll(result.items);
        } else {
          _filieres.addAll(result.items);
        }
        _lastPage = result.meta.lastPage;
        _hasMore = _currentPage < _lastPage;
        _currentPage += 1;
        _isLoading = false;
        _isLoadingMore = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff0D6EFD),
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white.withAlpha(38),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: const Text(
        "Listes des filières",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(38),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FiliereSearchBar(controller: _searchController),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading && _filieres.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => _loadFilieres(reset: true),
                    child: _errorMessage != null && _filieres.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 80),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _filieres.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 80),
                                  Center(
                                    child: Text('Aucune filière trouvée.'),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: _filieres.length + (_isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _filieres.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }

                                  final filiere = _filieres[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: FiliereCard(
                                      filiere: filiere,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => FiliereDetailScreen(slug: filiere.slug),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
          ),
        ],
      ),
    );
  }
}