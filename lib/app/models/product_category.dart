// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  List<ProductData> data;

  Category({
    required this.data,
  });

  Category copyWith({
    List<ProductData>? data,
  }) =>
      Category(
        data: data ?? this.data,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        data: List<ProductData>.from(
            json['data'].map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductData {
  String? categoryName;
  int? count;

  ProductData({
    required this.categoryName,
    required this.count,
  });

  ProductData copyWith({
    String? categoryName,
    int? count,
  }) =>
      ProductData(
        categoryName: categoryName ?? this.categoryName,
        count: count ?? this.count,
      );

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        categoryName: json['category_name']!,
        count: json['count'],
      );

  Map<String, dynamic> toJson() => {
        'category_name': categoryName,
        'count': count,
      };
}
