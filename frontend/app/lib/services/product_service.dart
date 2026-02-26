import 'dart:convert';
import '../core/api_client.dart';

class ProductService {

  Future<List> getProducts({
    required int page,
    String search = "",
    String sortBy = "",
    int? categoryId,
  }) async {

    String url = "/api/products?page=$page&limit=20";

    if (search.isNotEmpty) {
      url += "&search=$search";
    }

    if (sortBy.isNotEmpty) {
      url += "&sort_by=$sortBy";
    }

    if (categoryId != null) {
      url += "&category_id=$categoryId";
    }

    final response = await ApiClient.get(url);
    return jsonDecode(response.body);
  }
}