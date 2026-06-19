import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),

            child: Column(
              children: [

                const SizedBox(height: 20),

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
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1682F8),
                  ),
                ),

                const Text(
                  "École Africaine des Métiers de\nl'Architecture et de l'Urbanisme",
                  textAlign: TextAlign.center,
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
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},

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

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    CircleAvatar(
                      radius: 25,
                      child: Icon(
                        Icons.g_mobiledata,
                        size: 40,
                      ),
                    ),

                    const SizedBox(width: 25),

                    CircleAvatar(
                      radius: 25,
                      child: Icon(
                        Icons.facebook,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                OutlinedButton.icon(
                  onPressed: () {},

                  icon: const Icon(
                    Icons.person_add_alt_outlined,
                  ),

                  label: const Text(
                    "Créer un compte",
                  ),

                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      55,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}