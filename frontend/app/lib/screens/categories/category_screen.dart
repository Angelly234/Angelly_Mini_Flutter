import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final CategoryService service = CategoryService();

  List categories = [];

  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  Timer? debounce;

  @override
  void initState() {
    super.initState();
    loadCategories("");
  }

  // Load categories from API
  Future<void> loadCategories(String search) async {
    final data = await service.getCategories(search);
    setState(() {
      categories = data;
    });
  }

  // Debounce search
  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      loadCategories(value);
    });
  }

  // Create category
  Future<void> createCategory() async {
    final success = await service.createCategory(
      nameController.text,
      descController.text,
    );

    if (success) {
      nameController.clear();
      descController.clear();
      loadCategories("");
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    await service.deleteCategory(id);
    loadCategories("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Search bar
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: "Search Category",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Create Category
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createCategory,
                child: const Text("Create Category"),
              ),
            ),

            const SizedBox(height: 15),

            // Category List
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final c = categories[index];

                  return Card(
                    child: ListTile(
                      title: Text(c['name']),
                      subtitle: Text(c['description'] ?? ""),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteCategory(c['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}