import 'package:flutter/material.dart';

import '../models/filiere/filiere_model.dart';
import '../services/filiere/filiere_service.dart';
import '../widgets/filiere/detail/filiere_slider.dart';
import '../widgets/filiere/detail/parcours_card.dart';

class FiliereDetailScreen extends StatefulWidget {
  final int filiereId;

  const FiliereDetailScreen({
    super.key,
    required this.filiereId,
  });

  @override
  State<FiliereDetailScreen> createState() =>
      _FiliereDetailScreenState();
}

class _FiliereDetailScreenState
    extends State<FiliereDetailScreen> {

  final FiliereService _service = FiliereService();

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

        future: _service.getFiliereDetail(widget.filiereId),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Erreur de chargement"),
            );
          }

          final filiere = snapshot.data!;

          return SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                FiliereSlider(
                  images: filiere.images,
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
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
                        filiere.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.45,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.bold,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                "Les parcours en ",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: filiere.nom,
                                style: const TextStyle(
                                  color:
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      ListView.separated(

                        physics:
                        const NeverScrollableScrollPhysics(),

                        shrinkWrap: true,

                        itemCount:
                        filiere.parcours.length,

                        separatorBuilder:
                            (_, __) =>
                        const SizedBox(
                          height: 18,
                        ),

                        itemBuilder: (context, index) {

                          return ParcoursCard(
                            parcours:
                            filiere.parcours[index],
                          );
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
}