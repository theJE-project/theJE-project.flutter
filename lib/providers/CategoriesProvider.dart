import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/Category.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final response = await http.get(Uri.parse('http://localhost:8888/api/categories'));
  if (response.statusCode == 200) {
    String utf8Body = utf8.decode(response.bodyBytes);
    final List<dynamic> jsonList = jsonDecode(utf8Body);
    return jsonList.map((e) => Category.fromJson(e)).toList();
  } else {
    throw Exception('API 호출 실패');
  }
});