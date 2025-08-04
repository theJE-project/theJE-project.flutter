import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Category {
  final int id;
  final int? parent;  // null 가능
  final String name;
  final String url;
  final int boardType;

  Category({
    required this.id,
    this.parent,
    required this.name,
    required this.url,
    required this.boardType,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parent: json['parent'], // null 가능
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      boardType: json['boardType'] ?? 0, // JSON 키는 보통 camelCase로 수정
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'parent': parent,
    'name': name,
    'url': url,
    'boardType': boardType,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Board',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CategoryListScreen(),
    );
  }
}

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final String apiUrl = 'http://10.0.2.2:8888/api/categories';

  List<Category> categories = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List jsonList = json.decode(response.body);
        categories = jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        showError('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error: $e');
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> addCategory(String name, String url, int boardType, {int? parent}) async {
    final newCategory = {
      "name": name,
      "url": url,
      "boardType": boardType,
      "parent": parent,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newCategory),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchCategories();
      } else {
        showError('Failed to add category: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  Future<void> updateCategory(Category category) async {
    final updateUrl = '$apiUrl';

    try {
      final response = await http.put(
        Uri.parse(updateUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );
      if (response.statusCode == 200) {
        fetchCategories();
      } else {
        showError('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    final deleteUrl = '$apiUrl/$id';

    try {
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode == 200 || response.statusCode == 204) {
        fetchCategories();
      } else {
        showError('Failed to delete category: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void openCategoryDialog({Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final urlController = TextEditingController(text: category?.url ?? '');
    final boardTypeController =
    TextEditingController(text: category?.boardType.toString() ?? '1');
    final parentController =
    TextEditingController(text: category?.parent?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'URL'),
                ),
                TextField(
                  controller: boardTypeController,
                  decoration: const InputDecoration(labelText: 'Board Type'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: parentController,
                  decoration: const InputDecoration(labelText: 'Parent ID (optional)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final url = urlController.text.trim();
                final boardType = int.tryParse(boardTypeController.text.trim()) ?? 1;
                final parent = int.tryParse(parentController.text.trim());

                if (name.isEmpty || url.isEmpty) {
                  showError('Name and URL cannot be empty');
                  return;
                }

                if (category == null) {
                  addCategory(name, url, boardType, parent: parent);
                } else {
                  updateCategory(Category(
                    id: category.id,
                    name: name,
                    url: url,
                    boardType: boardType,
                    parent: parent,
                  ));
                }
                Navigator.pop(context);
              },
              child: Text(category == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Board'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchCategories,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final c = categories[index];
            return ListTile(
              title: Text(c.name),
              subtitle: Text(
                'URL: ${c.url}\nBoard Type: ${c.boardType}\nParent: ${c.parent ?? "None"}',
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => openCategoryDialog(category: c),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteCategory(c.id),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
