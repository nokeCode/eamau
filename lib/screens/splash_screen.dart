import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
          () {
        // Navigation plus tard
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          //première cercle bleu en haut
          Positioned(
            top: -8,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),

          //dexième cercle bleu en bas
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Blob jaune/crème – milieu droite
          Positioned(
            top: size.height * 0.28,
            right: -size.width * 0.08,
            child: Container(
              width: size.width * 0.40,
              height: size.width * 0.40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EDBB).withOpacity(0.70),
                shape: BoxShape.circle,
              ),
            ),
          ),

          //contenu centrale logo + texte
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/logos/eamau_logo.gif',
                  width: 140,
                ),

                const SizedBox(height: 20),

                const Text(
                  'EAMAU',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1677FF),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "École Africaine des Métiers de\nl'Architecture et de l'Urbanisme",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [

                CircularProgressIndicator(),

                SizedBox(height: 12),

                Text(
                  "Chargement ...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}