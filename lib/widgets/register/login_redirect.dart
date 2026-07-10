import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../screens/login_screen.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            children: [
              const TextSpan(
                text: "Vous avez déjà un compte ? ",
              ),
              TextSpan(
                text: "Se connecter",
                style: const TextStyle(
                  color: Color(0xFF0F4DA8),
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}