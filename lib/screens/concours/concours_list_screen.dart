import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/concours/concours_model.dart';
import '../../services/concours/concours_service.dart';
import '../../widgets/concours/concours_card.dart';
import '../../widgets/concours/concours_header.dart';
import '../../widgets/concours/concours_search_filter.dart';
import 'detail_concours_screen.dart';

class ConcoursListScreen extends StatefulWidget {
  const ConcoursListScreen({super.key});

  @override
  State<ConcoursListScreen> createState() => _ConcoursListScreenState();
}

class _ConcoursListScreenState extends State<ConcoursListScreen> {
  final ConcoursService _service = ConcoursService();
  final TextEditingController _searchController = TextEditingController();

  List<ConcoursModel> _allConcours = [];
  List<ConcoursModel> _filteredConcours = [];
  String _selectedFilter = 'Tous';
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadConcours();
  }

  Future<void> _loadConcours({String? query}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final concours = await _service.getConcours(query: query);
      if (!mounted) return;
      setState(() {
        _allConcours = concours;
        _applyFilters();
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  void _applyFilters() {
    List<ConcoursModel> data = List.from(_allConcours);

    if (_selectedFilter == 'Ouvertes') {
      data = data.where((e) => e.statut.toLowerCase() == 'ouvert').toList();
    }

    if (_selectedFilter == 'Clôturés') {
      data = data.where((e) => e.statut.toLowerCase() != 'ouvert').toList();
    }

    if (_searchController.text.isNotEmpty) {
      data = data.where((e) {
        return e.titre.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }

    _filteredConcours = data;
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _loadConcours(query: value);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xffF7F8FC),
        body: Column(
          children: [
            ConcoursHeader(
              onBackPressed: () => Navigator.pop(context),
              onNotificationPressed: () {},
            ),
            const SizedBox(height: 16),
            ConcoursSearchFilter(
              controller: _searchController,
              selectedFilter: _selectedFilter,
              onSearch: (value) {
                _onSearchChanged(value);
              },
              onFilterChanged: (value) {
                setState(() {
                  _selectedFilter = value;
                  _applyFilters();
                });
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Concours Disponibles',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 5,
                      itemBuilder: (_, _) => const _ConcoursSkeleton(),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      : _filteredConcours.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun concours disponible',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _filteredConcours.length,
                              itemBuilder: (context, index) {
                                final concours = _filteredConcours[index];
                                return ConcoursCard(
                                  concours: concours,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailConcoursScreen(slug: concours.slug),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConcoursSkeleton extends StatelessWidget {
  const _ConcoursSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(width: 80, height: 80, color: Colors.grey.shade200),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 120, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                Container(height: 12, width: double.infinity, color: Colors.grey.shade200),
                const SizedBox(height: 6),
                Container(height: 12, width: 100, color: Colors.grey.shade200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}