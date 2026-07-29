import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/routes/app_routes.dart';

import '../widgets/register/login_redirect.dart';
import '../widgets/register/register_button.dart';
import '../widgets/register/register_form.dart';
import '../widgets/register/register_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _register(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Les mots de passe ne correspondent pas'),
        ),
      );
      return;
    }

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      firstName: _prenomController.text.trim(),
      lastName: _nomController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmController.text,
      phone: _telephoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Compte créé avec succès. Bienvenue !')),
            ],
          ),
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD32F2F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            authProvider.error ?? 'Erreur lors de l\'inscription',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const RegisterHeader(),
            const SizedBox(height: 28),
            RegisterForm(
              formKey: _formKey,
              nomController: _nomController,
              prenomController: _prenomController,
              emailController: _emailController,
              telephoneController: _telephoneController,
              passwordController: _passwordController,
              passwordConfirmController: _passwordConfirmController,
            ),
            const SizedBox(height: 30),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return RegisterButton(
                  isLoading: authProvider.isLoading,
                  onPressed: () => _register(authProvider),
                );
              },
            ),
            const SizedBox(height: 24),
            const LoginRedirect(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
