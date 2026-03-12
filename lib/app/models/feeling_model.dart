/// To parse this JSON data, do
//
//     final feelingModel = feelingModelFromJson(jsonString);

import 'dart:convert';

FeelingModel feelingModelFromJson(String str) =>
    FeelingModel.fromJson(json.decode(str));

String feelingModelToJson(FeelingModel data) => json.encode(data.toJson());

class FeelingModel {
  int? status;
  List<PostFeeling>? postFeelings;

  FeelingModel({
    required this.status,
    required this.postFeelings,
  });

  FeelingModel copyWith({
    int? status,
    List<PostFeeling>? postFeelings,
  }) =>
      FeelingModel(
        status: status ?? this.status,
        postFeelings: postFeelings ?? this.postFeelings,
      );

  factory FeelingModel.fromJson(Map<String, dynamic> json) => FeelingModel(
        status: json['status'],
        postFeelings: List<PostFeeling>.from(
            json['postFeelings'].map((x) => PostFeeling.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'postFeelings':
            List<dynamic>.from(postFeelings!.map((x) => x.toJson())),
      };
}

class PostFeeling {
  String? id;
  String? feelingName;
  String logo;

  PostFeeling({
    required this.id,
    required this.feelingName,
    required this.logo,
  });

  PostFeeling copyWith({
    String? id,
    String? feelingName,
    String? logo,
  }) =>
      PostFeeling(
        id: id ?? this.id,
        feelingName: feelingName ?? this.feelingName,
        logo: logo ?? this.logo,
      );

  factory PostFeeling.fromJson(Map<String, dynamic> json) => PostFeeling(
        id: json['_id'],
        feelingName: json['feeling_name'],
        logo: json['logo'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'feeling_name': feelingName,
        'logo': logo,
      };
}
