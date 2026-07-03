import 'package:flutter/material.dart';

import '../models/contact/contact_model.dart';
import '../services/contact/contact_service.dart';
import '../widgets/contact/campus_map.dart';
import '../widgets/contact/contact_form.dart';
import '../widgets/contact/contact_info_card.dart';
import '../widgets/contact/social_links.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactService _service = ContactService();

  late Future<ContactModel> _futureContact;

  @override
  void initState() {
    super.initState();
    _futureContact = _service.getContact();
  }

  Future<void> _sendMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    // Endpoint d'envoi à intégrer lorsqu'il sera disponible.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Message envoyé."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: Color(0xff0a2dee),
        title: const Text(
            "Contact",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFFFFFFFF),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<ContactModel>(
        future: _futureContact,
        builder: (context, snapshot) {
          final contact = snapshot.data ?? ContactModel.fallback();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nous contacter",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D47A1),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Nous sommes là pour vous accompagner.",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                ContactInfoCard(
                  icon: Icons.phone_outlined,
                  title: "Téléphone",
                  value: contact.phone,
                ),

                const SizedBox(height: 14),

                ContactInfoCard(
                  icon: Icons.mail_outline,
                  title: "Email",
                  value: contact.email,
                ),

                const SizedBox(height: 14),

                ContactInfoCard(
                  icon: Icons.location_on_outlined,
                  title: "Adresse",
                  value: contact.address,
                ),

                const SizedBox(height: 28),

                const Text(
                  "Envoyer un message",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D47A1),
                  ),
                ),

                const SizedBox(height: 16),

                ContactForm(
                  onSubmit: ({
                    required name,
                    required email,
                    required subject,
                    required message,
                  }) async {
                    await _sendMessage(
                      name: name,
                      email: email,
                      subject: subject,
                      message: message,
                    );
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  "Notre localisation",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D47A1),
                  ),
                ),

                const SizedBox(height: 14),

                CampusMap(
                  mapUrl: contact.mapUrl,
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Text(
                    "Suivez-nous",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0D47A1),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: SocialLinks(
                    links: contact.socialLinks,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}