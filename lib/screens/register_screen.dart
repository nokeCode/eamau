import 'package:flutter/material.dart';

import '../../models/register/register_model.dart';
import '../../services/register/register_service.dart';
import '../widgets/register/login_redirect.dart';
import '../widgets/register/register_button.dart';
import '../widgets/register/register_form.dart';
import '../widgets/register/register_header.dart';

// Remplace par ton dashboard
import 'user_screen.dart';

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

  final RegisterService _service = RegisterService();

  bool _loading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final user = RegisterModel(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _telephoneController.text.trim(),
      password: _passwordController.text,
    );

    final success = await _service.register(user);

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Compte créé avec succès."),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Échec de la création du compte."),
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
              ),

              const SizedBox(height: 30),

              RegisterButton(
                isLoading: _loading,
                onPressed: _register,
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