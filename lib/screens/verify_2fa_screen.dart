import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                /// HEADER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/logos/eamau_logo.gif',
                      width: 75,
                    ),

                    const SizedBox(width: 8),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EAMAU',
                            style: TextStyle(
                              color: Color(0xFF1682F8),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            "École Africaine des\nMétiers de l'Architecture\net de l'Urbanisme",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// TITRE
                const Text(
                  "Vérification de securité",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 25),

                /// ILLUSTRATION
                Image.asset(
                  "assets/images/security_verification.jpg",
                  height: 180,
                ),

                const SizedBox(height: 20),

                /// MESSAGE
                const Text(
                  "un conde de vérification a été\nenvoyé à votre adresse e-mail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 25),

                /// EMAIL BOX
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Color(0xFF1682F8),
                        size: 30,
                      ),

                      SizedBox(width: 12),

                      Text(
                        "mail******@gmail.com",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Saisir du code reçu",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// OTP
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                        (index) => _otpBox(),
                  ),
                ),

                const SizedBox(height: 30),

                /// TIMER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    Icon(
                      Icons.timer_outlined,
                      size: 24,
                    ),

                    SizedBox(width: 10),

                    Text(
                      "renvoyer le code dans ",
                      style: TextStyle(fontSize: 14),
                    ),

                    Text(
                      "00:54",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {},

                  child: const Text(
                    "Renvoyer le code",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// BOUTON
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {},

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      "Vérifier",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "vous n’avez pas reçu le code ?\nvérifier vos courriers indésirable.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _otpBox() {
    return Container(
      width: 46,
      height: 56,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFFD9DEE7),
        ),
      ),

      child: const Text(
        "",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}