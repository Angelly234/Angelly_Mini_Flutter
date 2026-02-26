import 'dart:convert';
import '../core/api_client.dart';

class CategoryService {

  // Get categories (search optional)
  Future<List> getCategories({String search = ""}) async {

    String url = "/api/categories";

    if (search.isNotEmpty) {
      url += "?search=$search";
    }

    final response = await ApiClient.get(url);
    return jsonDecode(response.body);
  }

  // Create category
  Future<bool> createCategory(String name, String description) async {
    final response = await ApiClient.post("/api/categories", {
      "name": name,
      "description": description,
    });

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Delete category (should be DELETE not POST)
  Future<bool> deleteCategory(int id) async {
    final response = await ApiClient.delete("/api/categories/$id");
    return response.statusCode == 200;
  }
}