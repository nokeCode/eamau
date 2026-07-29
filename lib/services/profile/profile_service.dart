import 'dart:convert';

import 'package:http/http.dart' as http;


import '../../models/profile/user_model.dart';
import '../auth/auth_service.dart';

class ProfileService {

  static const String baseUrl =
      "https://votre-domaine.com/api";

  final AuthService _authService =
  AuthService();

  Future<UserModel> getProfile() async {

     final token =
     await _authService.getAccessToken();

    if (token == null) {
      return UserModel.fallback();
    }

    try {

      final response = await http.get(

        Uri.parse(
          "$baseUrl/profile",
        ),

        headers: {

          "Authorization":
          "Bearer $token",

          "Accept":
          "application/json",
        },

      );

      if (response.statusCode == 200) {

        final json =
        jsonDecode(response.body);

        return UserModel.fromJson(json);

      }

      return UserModel.fallback();

    } catch (_) {

      return UserModel.fallback();

    }
  }

}