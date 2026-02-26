import 'dart:convert';
import '../core/api_client.dart';

// This service communicates with Category API
class CategoryService {

  // Get categories (with search)
  Future<List> getCategories(String search) async {
    final response = await ApiClient.get("/categories?search=$search");
    return jsonDecode(response.body);
  }

  // Create category
  Future<bool> createCategory(String name, String description) async {
    final response = await ApiClient.post("/categories", {
      "name": name,
      "description": description,
    });

    return response.statusCode == 201;
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    final response = await ApiClient.post("/categories/$id", {});
    return response.statusCode == 200;
  }
}