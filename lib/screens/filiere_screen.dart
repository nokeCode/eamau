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

  final TextEditingController _searchController =
  TextEditingController();

  List<Filiere> _allFilieres = [];

  List<Filiere> _filteredFilieres = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_filter);
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredFilieres = _allFilieres.where((filiere) {
        return filiere.nom.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
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
          backgroundColor: Colors.white.withOpacity(.15),
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
            backgroundColor: Colors.white.withOpacity(.15),
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

      body: FutureBuilder<List<Filiere>>(
        future: _service.getFilieres(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Une erreur est survenue."),
            );
          }

          _allFilieres = snapshot.data ?? [];

          if (_filteredFilieres.isEmpty &&
              _searchController.text.isEmpty) {
            _filteredFilieres = _allFilieres;
          }

          return Column(
            children: [

              const SizedBox(height: 18),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: FiliereSearchBar(
                  controller: _searchController,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filteredFilieres.length,
                  itemBuilder: (context, index) {
                    final filiere =
                    _filteredFilieres[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: FiliereCard(
                        filiere: filiere,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FiliereDetailScreen(
                                    filiereId: filiere.id,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}