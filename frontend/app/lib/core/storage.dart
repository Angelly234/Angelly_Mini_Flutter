import 'package:shared_preferences/shared_preferences.dart';

// This class handles saving and reading data locally
// We use it mainly to store JWT token
class Storage {

  // Save JWT token
  static Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  // Get JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Clear all saved data (used for logout)
  static Future clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}