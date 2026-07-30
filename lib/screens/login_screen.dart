import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/screens/register_screen.dart';
import 'package:eamau/screens/verify_2fa_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/app_routes.dart';
import '../widgets/login/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotPasswordEmailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPasswordEmailController.dispose();
    super.dispose();
  }

  Future<void> _login(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final result = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result) {
      if (authProvider.user == null) {
        Navigator.pushNamed(context, AppRoutes.verify2fa);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.user);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(authProvider.error ?? 'Erreur lors de la connexion'),
        ),
      );
    }
  }

  Future<void> _showForgotPasswordDialog(AuthProvider authProvider) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mot de passe oublié'),
          content: Form(
            key: _forgotPasswordFormKey,
            child: TextFormField(
              controller: _forgotPasswordEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Votre adresse email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email obligatoire';
                }
                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(value.trim())) {
                  return 'Adresse email invalide';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      if (!_forgotPasswordFormKey.currentState!.validate()) {
                        return;
                      }

                      final success = await authProvider.requestPasswordReset(
                        email: _forgotPasswordEmailController.text.trim(),
                      );

                      if (!mounted) return;

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: success ? Colors.green : Colors.red,
                          content: Text(
                            success
                                ? 'Si cet email est associé à un compte, un lien de réinitialisation a été envoyé.'
                                : authProvider.error ??
                                      'Impossible d’envoyer le lien.',
                          ),
                        ),
                      );
                    },
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginWithGoogle(AuthProvider authProvider) async {
    final result = await authProvider.loginWithGoogle();

    if (!mounted) return;

    if (result) {
      // Succès - naviguer vers l'écran principal ou 2FA
      if (authProvider.user == null) {
        Navigator.pushNamed(context, AppRoutes.verify2fa);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.user);
      }
    } else {
      // If 2FA is pending, navigate to verification screen with email
      if (authProvider.pending2FA && authProvider.pending2FAEmail != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                VerificationScreen(email: authProvider.pending2FAEmail),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            authProvider.error ?? 'Erreur lors de la connexion avec Google',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Image.asset('assets/logos/eamau_logo.gif', width: 120),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email obligatoire";
                          }
                          if (!RegExp(
                            r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
                          ).hasMatch(value.trim())) {
                            return "Adresse email invalide";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: "Mot de passe",
                        hint: "entrez votre mot de passe",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mot de passe obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(
                            context.read<AuthProvider>(),
                          ),
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () => _login(authProvider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF18336E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
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
                                      "Se connecter",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("ou connecter vous avec"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Bouton Google
                              GestureDetector(
                                onTap: authProvider.isLoading
                                    ? null
                                    : () => _loginWithGoogle(authProvider),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    color: authProvider.isLoading
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                  ),
                                  child: Image.asset('assets/icons/google.jpg'),
                                ),
                              ),
                              const SizedBox(width: 25),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: [
                            const TextSpan(
                              text: "Vous n'avez pas de compte ? ",
                            ),
                            TextSpan(
                              text: "Inscrivez-vous",
                              style: const TextStyle(
                                color: Color(0xFF1682F8),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
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
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/images/login_waveshap_haut.svg',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/images/login_bas_wave.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
