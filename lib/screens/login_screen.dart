import 'package:eamau/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/login/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key}); // Correction : Fermeture de la parenthèse et du crochet manquants

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Image du bâtiment en arrière-plan
          Positioned(
            right: -40,
            top: -10,
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/images/building_bg1.jpg',
                fit: BoxFit.fill,
                width: 500,
                height: 500,
              ),
            ),
          ),

          // 2. Contenu principal (Formulaire)
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    // Logo
                    Image.asset(
                      'assets/logos/eamau_logo.gif',
                      width: 120,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'EAMAU',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1682F8),
                      ),
                    ),

                    const Text(
                      "École Africaine des Métiers de\nl'Architecture et de l'Urbanisme",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Bienvenu !',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Connectez-vous à votre compte\npour accéder à votre espace.",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 25),

                    CustomTextField(
                      label: "E-mail",
                      hint: "entrez votre adresse email",
                      icon: Icons.mail_outline,
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      label: "Mot de passe",
                      hint: "entrez votre mot de passe",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.verify2fa,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF18336E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "ou connecter vous avec",
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'assets/icons/google.jpg',
                          ),
                        ),

                        const SizedBox(width: 25),

                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'assets/icons/facebook.jpg',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    //le texte d'inscription
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                        children: [
                          const TextSpan(text: "Vous n'avez pas de compte ? "),
                          TextSpan(
                            text: "Inscrivez-vous",
                            style: const TextStyle(
                              color: Color(0xFF1682F8), // Bleu EAMAU
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.register,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),

          //Vague du haut (Superposée et nettoyée)
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/images/login_waveshap_haut.svg',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.4, // Largeur relative stable
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          //wave shape du bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/login_bas_wave.svg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
