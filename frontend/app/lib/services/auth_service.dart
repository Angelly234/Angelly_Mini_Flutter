import 'dart:convert';
import '../core/api_client.dart';
import '../core/storage.dart';

// This service handles authentication-related API calls
class AuthService {

  // Login user and save JWT token
  Future<bool> login(String email, String password) async {
    final response = await ApiClient.post("/login", {
      "email": email,
      "password": password,
    });

    // If login success
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Save token locally
      await Storage.saveToken(data['token']);

      return true;
    }

    return false;
  }

  // Register new user
  Future<bool> signup(String email, String password) async {
    final response = await ApiClient.post("/signup", {
      "email": email,
      "password": password,
    });

    return response.statusCode == 201;
  }

  // Forgot password (send OTP)
  Future<bool> forgotPassword(String email) async {
    final response = await ApiClient.post("/forgot-password", {
      "email": email,
    });

    return response.statusCode == 200;
  }
}