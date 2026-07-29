import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/routes/app_routes.dart';
import '../widgets/verfy2fa/otp_box.dart';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  final String? email;

  const VerificationScreen({super.key, this.email});

  @override
  State<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  late Timer _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _canResend = true;
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  String _getFormattedTime() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verify2FA(AuthProvider authProvider) async {
    final code = controllers.map((c) => c.text).join();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Veuillez entrer un code à 6 chiffres'),
        ),
      );
      return;
    }

    final email = widget.email ?? '';
    final result = await authProvider.verify2FA(
      email: email,
      code: code,
    );

    if (!mounted) return;

    if (result) {
      Navigator.pushReplacementNamed(context, AppRoutes.user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(authProvider.error ?? 'Erreur de vérification'),
        ),
      );
    }
  }

  Future<void> _resendCode(AuthProvider authProvider) async {
    if (!_canResend) return;

    final email = widget.email ?? '';
    final result = await authProvider.resend2FA(email: email);

    if (!mounted) return;

    if (result) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Code renvoyé à votre adresse email'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(authProvider.error ?? 'Erreur lors de l\'envoi'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            style: TextStyle(fontSize: 11),
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
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
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
                  style: TextStyle(fontSize: 22, height: 1.3),
                ),
                const SizedBox(height: 25),
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF1682F8),
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.email ?? 'mail******@gmail.com',
                        style: const TextStyle(
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
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => OtpBox(
                      controller: controllers[index],
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_outlined, size: 24),
                    const SizedBox(width: 10),
                    const Text(
                      "Renvoyer le code dans ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      _getFormattedTime(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return GestureDetector(
                      onTap: _canResend
                          ? () => _resendCode(authProvider)
                          : null,
                      child: Text(
                        "Renvoyer le code",
                        style: TextStyle(
                          color: _canResend ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () => _verify2FA(authProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF18336E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "Vérifier",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Vous n'avez pas reçu le code ?\nVérifiez vos courriers indésirables.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
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