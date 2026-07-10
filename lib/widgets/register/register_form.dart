import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController emailController;
  final TextEditingController telephoneController;
  final TextEditingController passwordController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nomController,
    required this.prenomController,
    required this.emailController,
    required this.telephoneController,
    required this.passwordController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;

  InputDecoration decoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0F4DA8),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F7FB),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF0F4DA8),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.nomController,
                    textInputAction: TextInputAction.next,
                    decoration: decoration(
                      label: "Nom",
                      hint: "Votre nom",
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Champ obligatoire";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextFormField(
                    controller: widget.prenomController,
                    textInputAction: TextInputAction.next,
                    decoration: decoration(
                      label: "Prénom",
                      hint: "Votre prénom",
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Champ obligatoire";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: decoration(
                label: "Email",
                hint: "exemple@email.com",
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Email obligatoire";
                }

                if (!RegExp(
                  r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
                ).hasMatch(value)) {
                  return "Adresse email invalide";
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: widget.telephoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: decoration(
                label: "Téléphone",
                hint: "+228 XX XX XX XX",
                icon: Icons.phone_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Téléphone obligatoire";
                }

                if (value.length < 8) {
                  return "Numéro invalide";
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              decoration: decoration(
                label: "Mot de passe",
                hint: "********",
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mot de passe obligatoire";
                }

                if (value.length < 6) {
                  return "Minimum 6 caractères";
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}