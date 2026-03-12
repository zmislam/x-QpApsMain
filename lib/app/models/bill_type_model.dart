// To parse this JSON data, do
//
//     final billTypeModel = billTypeModelFromJson(jsonString);

import 'dart:convert';

BillTypeModel billTypeModelFromJson(String str) =>
    BillTypeModel.fromJson(json.decode(str));

String billTypeModelToJson(BillTypeModel data) => json.encode(data.toJson());

class BillTypeModel {
  String? label;
  String? value;

  BillTypeModel({
    this.label,
    this.value,
  });

  BillTypeModel copyWith({
    String? label,
    String? value,
  }) =>
      BillTypeModel(
        label: label ?? this.label,
        value: value ?? this.value,
      );

  factory BillTypeModel.fromJson(Map<String, dynamic> json) => BillTypeModel(
        label: json['label'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };

  @override
  String toString() {
    return value ?? '';
  }
}
