import 'package:flutter/material.dart';

import '../models/filiere/filiere_model.dart';
import '../services/filiere/filiere_service.dart';
import '../widgets/filiere/detail/filiere_slider.dart';
import '../widgets/filiere/detail/parcours_card.dart';

class FiliereDetailScreen extends StatefulWidget {
  final String slug;

  const FiliereDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  State<FiliereDetailScreen> createState() => _FiliereDetailScreenState();
}

class _FiliereDetailScreenState extends State<FiliereDetailScreen> {
  final FiliereService _service = FiliereService();

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
        "Filière",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: _buildAppBar(),
      body: FutureBuilder<Filiere>(
        future: _service.getFiliereBySlug(widget.slug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement'));
          }

          final filiere = snapshot.data!;
          final images = filiere.images.isEmpty && filiere.image.isNotEmpty
              ? [filiere.image]
              : filiere.images;
          final description = filiere.presentation.isNotEmpty
              ? filiere.presentation
              : filiere.description;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FiliereSlider(images: images),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filière ${filiere.nom}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0A4EAF),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.45,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (filiere.diplomes?.isNotEmpty == true)
                        _infoChip('Diplômes', filiere.diplomes!),
                      if (filiere.duree?.isNotEmpty == true)
                        _infoChip('Durée', filiere.duree!),
                      if (filiere.debouches?.isNotEmpty == true)
                        _infoChip('Débouchés', filiere.debouches!),
                      const SizedBox(height: 25),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Les parcours en ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: filiere.nom,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filiere.parcours.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          return ParcoursCard(parcours: filiere.parcours[index]);
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 15),
            children: [
              TextSpan(
                text: '$label : ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ),
    );
  }
}