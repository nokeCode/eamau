import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import '../../models/concours/concours_model.dart';
import '../../services/concours/concours_service.dart';
import '../../widgets/concours/concours_card.dart';
import '../../widgets/concours/concours_header.dart';
import '../../widgets/concours/concours_search_filter.dart';

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

  String _selectedFilter = "Tous";

  @override
  void initState() {
    super.initState();
    _loadConcours();
  }

  Future<void> _loadConcours() async {
    final concours = await _service.getConcours();

    setState(() {
      _allConcours = concours;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<ConcoursModel> data = List.from(_allConcours);

    if (_selectedFilter == "Ouvertes") {
      data = data
          .where((e) => e.statut.toLowerCase() == "ouvert")
          .toList();
    }

    if (_selectedFilter == "Clôturés") {
      data = data
          .where((e) => e.statut.toLowerCase() != "ouvert")
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      data = data.where((e) {
        return e.titre
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    _filteredConcours = data;
  }

  @override
  void dispose() {
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
                setState(() {
                  _applyFilters();
                });
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
                  "Concours Disponibles",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: _filteredConcours.isEmpty
                  ? const Center(
                child: Text(
                  "Aucun concours disponible",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredConcours.length,
                itemBuilder: (context, index) {
                  return ConcoursCard(
                    concours: _filteredConcours[index],
                    onTap: () {
                      // Navigation vers le détail
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