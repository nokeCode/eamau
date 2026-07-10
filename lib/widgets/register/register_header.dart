import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Fond bleu
          Container(
            height: 330 + topPadding,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4D6FD4),
                  Color(0xFF1F56D8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Image de fond
          Positioned.fill(
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                "assets/images/building_bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenu
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              children: [
                const SizedBox(height: 15),

                Image.asset(
                  "assets/logos/eamau_logo.gif",
                  width: 90,
                  height: 90,
                ),

                const SizedBox(height: 15),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "École Africaine des Métiers de\nl'Architecture et de l'Urbanisme",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      children: [
                        Text(
                          "Création de compte",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F4DA8),
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Veuillez remplir les informations ci-dessous\npour créer votre compte.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}