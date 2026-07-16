import 'package:flutter/material.dart';

class TrackingHelpCard extends StatelessWidget {
  final VoidCallback? onTap;

  const TrackingHelpCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xffDCEAFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent,
                color: Color(0xff0B4EA2),
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    "Besoin d'aide ?",
                    style: TextStyle(
                      color: Color(0xff183A7A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Contactez notre service d'admission",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff0B4EA2),
            ),
          ],
        ),
      ),
    );
  }
}