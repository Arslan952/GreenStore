import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../view/home_screen.dart';

class AuthServiceProvider extends ChangeNotifier {
  final String baseUrl = "https://springgreen-magpie-211501.hostingersite.com/wp-json/jwt-auth/v1";

  /// User Authentication: Logs in a user and retrieves a token
  Future<Map<String, dynamic>> authenticateUser(String username, String password, BuildContext context) async {
    final url = Uri.parse("$baseUrl/token");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    print(url);

    if (response.statusCode == 200) {
      print('User successfully logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully Logged In',
            style: TextStyle(color: Colors.green),
          ),
          backgroundColor: Colors.white,
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unauthorized User',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ),
      );
      throw Exception("Failed to authenticate user: ${response.body}");
    }
  }

  Future<bool> validateToken(String token) async {
    final url = Uri.parse("$baseUrl/token/validate");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"]["status"] == 200; // Token is valid
    } else {
      return false; // Invalid token
    }
  }

  /// Refresh Token: Refreshes the user's token
  Future<Map<String, dynamic>> refreshToken(String token) async {
    final url = Uri.parse("$baseUrl/token/refresh");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Contains the refreshed token
    } else {
      throw Exception("Failed to refresh token: ${response.body}");
    }
  }
}