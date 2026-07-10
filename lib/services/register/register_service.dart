import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/register/register_model.dart';

class RegisterService {
  static const String baseUrl = "https://votre-api.com";
  static const String endpoint = "/api/register";

  Future<bool> register(RegisterModel user) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (_) {
      // Fallback tant que l'API n'est pas disponible
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }
  }
}