import 'package:flutter/material.dart';

import 'send_button.dart';

class ContactForm extends StatefulWidget {
  final Future<void> Function({
  required String name,
  required String email,
  required String subject,
  required String message,
  })? onSubmit;

  const ContactForm({
    super.key,
    this.onSubmit,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.onSubmit == null) return;

    setState(() => _loading = true);

    await widget.onSubmit!(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  InputDecoration decoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xff0D47A1),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: decoration(
                    hint: "nom",
                    icon: Icons.person_outline,
                  ),
                  validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? "Nom obligatoire"
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: decoration(
                    hint: "email",
                    icon: Icons.mail_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email obligatoire";
                    }

                    if (!value.contains("@")) {
                      return "Email invalide";
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _subjectController,
            decoration: decoration(
              hint: "sujet",
              icon: Icons.edit_outlined,
            ),
            validator: (value) =>
            value == null || value.trim().isEmpty
                ? "Sujet obligatoire"
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _messageController,
            maxLines: 6,
            decoration: decoration(
              hint: "votre message",
              icon: Icons.chat_bubble_outline,
            ),
            validator: (value) =>
            value == null || value.trim().isEmpty
                ? "Message obligatoire"
                : null,
          ),
          const SizedBox(height: 18),
          SendButton(
            loading: _loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}