import 'package:flutter/material.dart';
import '../widgets/verfy2fa/otp_box.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  final List<TextEditingController> controllers =
  List.generate(
    6,
        (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
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

                const Text(
                  "Vérification de sécurité",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 25),

                Image.asset(
                  "assets/images/security_verification.jpg",
                  height: 180,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Un code de vérification a été\nenvoyé à votre adresse e-mail",
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F8),
                    borderRadius:
                    BorderRadius.circular(16),
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

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Saisir le code reçu",
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
                        (index) => OtpBox(
                      controller:
                      controllers[index],

                      onChanged: (value) {

                        if (value.length == 1 &&
                            index < 5) {
                          FocusScope.of(context)
                              .nextFocus();
                        }

                        if (value.isEmpty &&
                            index > 0) {
                          FocusScope.of(context)
                              .previousFocus();
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: const [

                    Icon(
                      Icons.timer_outlined,
                      size: 24,
                    ),

                    SizedBox(width: 10),

                    Text(
                      "Renvoyer le code dans ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),

                    Text(
                      "00:54",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight:
                        FontWeight.w500,
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
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {

                      String otp =
                      controllers
                          .map(
                            (controller) =>
                        controller.text,
                      )
                          .join();

                      print(otp);
                    },

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                        0xFF18336E,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    child: const Text(
                      "Vérifier",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Vous n’avez pas reçu le code ?\nVérifiez vos courriers indésirables.",
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
}