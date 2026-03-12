// To parse this JSON data, do
//
//     final brand = brandFromJson(jsonString);

import 'dart:convert';

Brand brandFromJson(String str) => Brand.fromJson(json.decode(str));

String brandToJson(Brand data) => json.encode(data.toJson());

class Brand {
  List<ProductBrand> data;

  Brand({
    required this.data,
  });

  Brand copyWith({
    List<ProductBrand>? data,
  }) =>
      Brand(
        data: data ?? this.data,
      );

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        data: List<ProductBrand>.from(
            json['data'].map((x) => ProductBrand.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductBrand {
  String? brandName;
  int count;

  ProductBrand({
    required this.brandName,
    required this.count,
  });

  ProductBrand copyWith({
    String? brandName,
    int? count,
  }) =>
      ProductBrand(
        brandName: brandName ?? this.brandName,
        count: count ?? this.count,
      );

  factory ProductBrand.fromJson(Map<String, dynamic> json) => ProductBrand(
        brandName: json['brand_name']!,
        count: json['count'],
      );

  Map<String, dynamic> toJson() => {
        'brand_name': brandName,
        'count': count,
      };
}
