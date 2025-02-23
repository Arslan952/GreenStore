import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/models/customerModel.dart';
import 'package:green_commerce/view/auth/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/reviewModel.dart';
import '../view/home_screen.dart';

class AuthServiceProvider extends ChangeNotifier {
  final String baseUrl = "https://mistyrose-trout-461429.hostingersite.com/wp-json/jwt-auth/v1";

  /// User Authentication: Logs in a user and retrieves a token
  Future<Map<String, dynamic>> authenticateUser(
      String username, String password, BuildContext context)
  async {
    final url = Uri.parse("$baseUrl/token");
    updateIsLoading(true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> responseData =
        await json.decode(response.body.toString());
        var decodeData = parseJwt(responseData['token']);
        var id = decodeData['data']['user']['id'].toString();
        responseData['id'] = id;
        await prefs.setString('token', responseData['token'].toString());
        AuthResponse authResponse = AuthResponse.fromJson(responseData);
        storeAuthResponse(authResponse);

        updateIsLoading(false);
        MotionToast.success(
          title: Text("Success"),
          description: Text("Successfully Logged In"),
        ).show(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        return jsonDecode(response.body);
      } else {
        MotionToast.error(
          title: Text("Failed"),
          description: const Text("Unauthorized User"),
        ).show(context);

        updateIsLoading(false);
        throw Exception("Failed to authenticate user: ${response.body}");
      }
    } catch (error) {
      updateIsLoading(false);

      // Show a toast for any error that occurs
      MotionToast.error(
        title: Text("Error"),
        description: Text(
            "An error occurred during login. Please try again later.\n$error"),
      ).show(context);

      // Re-throw the error to let calling code handle it, if needed
      throw Exception("An unexpected error occurred: $error");
    }
  }


  Future<bool> validateToken(String token, BuildContext context) async {
    final url = Uri.parse("$baseUrl/token/validate");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["data"]["status"] == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        // refreshToken(token);
        await authenticateUser(email!, password!, context);
      }
      return data["data"]["status"] == 200; // Token is valid
    } else {
      await authenticateUser(email!, password!, context);
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
      print(response.body);
      return jsonDecode(response.body); // Contains the refreshed token
    } else {
      throw Exception("Failed to refresh token: ${response.body}");
    }
  }

  void saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString(
        'lastLoginDate', DateTime.now().toIso8601String()); // Save current date
  }


  Future<void> clearToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future <void> validateUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String ? token = prefs.getString('token');

    if (email != null && password != null) {
      validateToken(token!, context);
      //  refreshToken(token!);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

// <<<<<<< Updated upstream
//
//
//   static
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('InvalidToken');
    }
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception("Invalid PAYLOAD");
    }
    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll("-", "+").replaceAll("_", "/");
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += "==";
        break;
      case 3:
        output += "=";
        break;
      default:
        throw Exception("illegal base 64 url");
    }
    return utf8.decode(base64Url.decode(output));
  }

  Future<void> storeAuthResponse(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    // Store the serialized JSON string
    await prefs.setString('auth_response', authResponse.toJsonString());
  }

  Future<AuthResponse?> retrieveAuthResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('auth_response');

    // Check if the JSON string exists
    if (jsonString != null) {
      return AuthResponse.fromJsonString(jsonString);
    }
    return null; // Return null if no data is found
  }
  bool isLoading  = false;
  updateIsLoading (bool value){
    isLoading= value;
    notifyListeners();
  }

}
