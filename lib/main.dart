import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'communities.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '커뮤니티 피드',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const FeedScreen(),
    );
  }
}


