import 'package:flutter/material.dart';

class ConditionsIntro extends StatelessWidget {
  const ConditionsIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 12, 22, 24),
      child: Text(
        "Découvrez les conditions requises pour rejoindre "
            "nos programmes et entamer votre parcours "
            "académique à l'EAMAU",
        style: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: Color(0xFF444444),
        ),
      ),
    );
  }
}