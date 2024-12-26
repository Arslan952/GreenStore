import 'dart:convert';

class AuthResponse {
  final String token;
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final int userId;

  AuthResponse({
    required this.token,
    required this.userEmail,
    required this.userNicename,
    required this.userDisplayName,
    required this.userId,
  });

  // Factory constructor to parse JSON into an instance of AuthResponse
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      userEmail: json['user_email'] as String,
      userNicename: json['user_nicename'] as String,
      userDisplayName: json['user_display_name'] as String,
      userId: int.parse(json['id'].toString()),
    );
  }

  // Convert an AuthResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_email': userEmail,
      'user_nicename': userNicename,
      'user_display_name': userDisplayName,
      'id': userId,
    };
  }

  // Serialize the object to a JSON string
  String toJsonString() => jsonEncode(toJson());

  // Deserialize a JSON string to an AuthResponse object
  static AuthResponse fromJsonString(String jsonString) {
    return AuthResponse.fromJson(jsonDecode(jsonString));
  }
}
