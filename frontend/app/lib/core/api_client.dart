import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'storage.dart';

class ApiClient {

  static Future<http.Response> post(String path, Map data) async {
    final token = await Storage.getToken();

    return http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> get(String path) async {
    final token = await Storage.getToken();

    return http.get(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  // 👇 ADD THIS
  static Future<http.Response> delete(String path) async {
    final token = await Storage.getToken();

    return http.delete(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}