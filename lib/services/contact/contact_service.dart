import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/contact/contact_model.dart';

class ContactService {
  static const String endpoint = "api/eamau/contact";

  Future<ContactModel> getContact() async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
      );

      if (response.statusCode == 200) {
        return ContactModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (_) {}

    return ContactModel.fallback();
  }
}