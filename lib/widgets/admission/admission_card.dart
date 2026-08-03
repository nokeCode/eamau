import 'package:flutter/material.dart';

class AdmissionCard extends StatefulWidget {
  final String title;
  final String description;
  final String eligibility;
  final String image;
  final VoidCallback? onTap;

  const AdmissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.image,
    this.onTap,
  });

  @override
  State<AdmissionCard> createState() => _AdmissionCardState();
}

class _AdmissionCardState extends State<AdmissionCard> {
  bool expanded = false;

  bool get _hasLongDescription {
    final words = widget.description.trim().split(RegExp(r'\s+'));
    return words.length > 10;
  }

  String get _descriptionPreview {
    final words = widget.description.trim().split(RegExp(r'\s+'));
    if (words.length <= 10) return widget.description;
    return '${words.take(10).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 22,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: const Color(0xffEAF2FF),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Image.asset(widget.image),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B4EA2),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  "Description",
                  style: TextStyle(
                    color: Color(0xff2E6CE6),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  expanded ? widget.description : _descriptionPreview,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.45,
                  ),
                ),

                if (_hasLongDescription) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          expanded ? 'Réduire' : 'Voir tout',
                          style: const TextStyle(
                            color: Color(0xff0B4EA2),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xff0B4EA2),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                const Text(
                  "Eligibilité",
                  style: TextStyle(
                    color: Color(0xff2E6CE6),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  widget.eligibility,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: 185,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: widget.onTap,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff0B4EA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Voir les conditions",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
