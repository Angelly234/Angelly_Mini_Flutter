import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductService productService = ProductService();
  final CategoryService categoryService = CategoryService();

  List products = [];
  List categories = [];

  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  String search = "";
  String sortBy = "";
  int? selectedCategoryId;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadProducts();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  Future<void> loadCategories() async {
    final data = await categoryService.getCategories();
    setState(() {
      categories = data;
    });
  }

  Future<void> loadProducts({bool reset = false}) async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    final data = await productService.getProducts(
      page: page,
      search: search,
      sortBy: sortBy,
      categoryId: selectedCategoryId,
    );

    setState(() {
      if (reset) {
        products = data;
      } else {
        products.addAll(data);
      }

      if (data.length < 20) {
        hasMore = false;
      }

      isLoading = false;
    });
  }

  void loadMore() {
    page++;
    loadProducts();
  }

  void onSearchChanged(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      search = value;
      page = 1;
      hasMore = true;
      products.clear();
      loadProducts(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          DropdownButton<String>(
            value: sortBy.isEmpty ? null : sortBy,
            hint: const Text("Sort"),
            underline: const SizedBox(),
            onChanged: (value) {
              setState(() {
                sortBy = value ?? "";
                page = 1;
                hasMore = true;
                products.clear();
              });
              loadProducts(reset: true);
            },
            items: const [
              DropdownMenuItem(value: "name", child: Text("Name")),
              DropdownMenuItem(value: "price", child: Text("Price")),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [

          // 🔹 Category Filter
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<int>(
              value: selectedCategoryId,
              hint: const Text("Filter by Category"),
              items: categories.map<DropdownMenuItem<int>>((c) {
                return DropdownMenuItem<int>(
                  value: c['id'],
                  child: Text(c['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                  page = 1;
                  hasMore = true;
                  products.clear();
                });
                loadProducts(reset: true);
              },
            ),
          ),

          // 🔹 Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: "Search Product",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Product List
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: products.length,
              itemBuilder: (context, index) {

                final p = products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: CachedNetworkImage(
                      imageUrl: p['image_url'] ??
                          "https://via.placeholder.com/150",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(
                      p['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "\$${p['price']}",
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}