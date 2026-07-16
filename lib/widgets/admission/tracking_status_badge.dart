import 'package:flutter/material.dart';

class TrackingStatusBadge extends StatelessWidget {
  final String status;

  const TrackingStatusBadge({
    super.key,
    required this.status,
  });

  Color get color {
    switch (status.toLowerCase()) {
      case "accepté":
        return Colors.green;

      case "refusé":
        return Colors.red;

      case "en cours d'étude":
        return const Color(0xff0B4EA2);

      case "en attente":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}