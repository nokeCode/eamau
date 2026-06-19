import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Image.asset(
          'assets/logos/eamau_logo.gif',
          width: 40,
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'EAMAU',
                style: TextStyle(
                  color: Color(0xFF1682F8),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              Text(
                "École Africaine des Métiers\n de l'Architecture et de l'Urbanisme",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            size: 28,
          ),
        ),
      ],
    );
  }
}