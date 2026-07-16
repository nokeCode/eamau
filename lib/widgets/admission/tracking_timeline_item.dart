import 'package:flutter/material.dart';

class TrackingTimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final bool completed;
  final bool isLast;

  const TrackingTimelineItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 45,
            child: Column(
              children: [

                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed
                        ? const Color(0xff0B4EA2)
                        : Colors.white,
                    border: Border.all(
                      color: completed
                          ? const Color(0xff0B4EA2)
                          : Colors.grey,
                    ),
                  ),
                  child: completed
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                      : null,
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: completed
                          ? const Color(0xff0B4EA2)
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff183A7A),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xff0B4EA2),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}