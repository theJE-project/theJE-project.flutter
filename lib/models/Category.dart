import 'package:flutter/foundation.dart';

class Category {
  final int? id;
  final int? parent;
  final String name;
  final String url;
  final int? boardType;
  final DateTime? createdAt;

  Category({
    this.id,
    this.parent,
    required this.name,
    required this.url,
    this.boardType,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      parent: json['parent'] != null ? (json['parent'] as num).toInt() : null,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      boardType: json['board_type'] != null ? (json['board_type'] as num).toInt() : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent': parent,
      'name': name,
      'url': url,
      'board_type': boardType,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Category &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              parent == other.parent &&
              name == other.name &&
              url == other.url &&
              boardType == other.boardType &&
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      parent.hashCode ^
      name.hashCode ^
      url.hashCode ^
      boardType.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'Category{id: $id, parent: $parent, name: $name, url: $url, boardType: $boardType, createdAt: $createdAt}';
  }
}