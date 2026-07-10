import 'package:flutter/material.dart';

import '../../../models/filiere/filiere_model.dart';

class ParcoursCard extends StatefulWidget {
  final Parcours parcours;

  const ParcoursCard({
    super.key,
    required this.parcours,
  });

  @override
  State<ParcoursCard> createState() => _ParcoursCardState();
}

class _ParcoursCardState extends State<ParcoursCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.parcours.image,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 85,
                    height: 85,
                    color: Colors.blue.shade50,
                    child: const Icon(
                      Icons.school,
                      size: 40,
                      color: Color(0xff0D6EFD),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Text(
                  widget.parcours.nom,
                  style: const TextStyle(
                    color: Color(0xff0A4EAF),
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              widget.parcours.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                height: 1.5,
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.parcours.description,
                  style: const TextStyle(
                    height: 1.5,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.parcours.details,
                  style: const TextStyle(
                    height: 1.5,
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0D6EFD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Text(
                expanded ? "Réduire" : "Voir plus",
              ),
            ),
          ),
        ],
      ),
    );
  }
}