import 'package:flutter/material.dart';

import '../../models/filiere/filiere_model.dart';

class FiliereCard extends StatelessWidget {
  final Filiere filiere;
  final VoidCallback onTap;

  const FiliereCard({
    super.key,
    required this.filiere,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.10),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [

            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 95,
                height: 95,
                child: Image.network(
                  filiere.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.blue.shade50,
                      child: const Icon(
                        Icons.school,
                        size: 45,
                        color: Color(0xff0D6EFD),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    filiere.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0A4EAF),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    filiere.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Niveau : ",
                          style: TextStyle(
                            color: Color(0xff0D6EFD),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: filiere.niveau,
                          style: const TextStyle(
                            color: Color(0xff4A78D0),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              Icons.chevron_right,
              color: Colors.blue.shade700,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}