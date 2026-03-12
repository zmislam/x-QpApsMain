// To parse this JSON data, do
//
//     final helpModel = helpModelFromJson(jsonString);

import 'dart:convert';

HelpModel helpModelFromJson(String str) => HelpModel.fromJson(json.decode(str));

String helpModelToJson(HelpModel data) => json.encode(data.toJson());

class HelpModel {
  dynamic actionBy;
  dynamic note;
  String? id;
  String? name;
  String? topics;
  String? userId;
  String? status;
  String? description;
  List<String>? photos;
  String? createdAt;
  int? v;

  HelpModel({
    this.actionBy,
    this.note,
    this.id,
    this.name,
    this.topics,
    this.userId,
    this.status,
    this.description,
    this.photos,
    this.createdAt,
    this.v,
  });

  HelpModel copyWith({
    dynamic actionBy,
    dynamic note,
    String? id,
    String? name,
    String? topics,
    String? userId,
    String? status,
    String? description,
    List<String>? photos,
    String? createdAt,
    int? v,
  }) =>
      HelpModel(
        actionBy: actionBy ?? this.actionBy,
        note: note ?? this.note,
        id: id ?? this.id,
        name: name ?? this.name,
        topics: topics ?? this.topics,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        description: description ?? this.description,
        photos: photos ?? this.photos,
        createdAt: createdAt ?? this.createdAt,
        v: v ?? this.v,
      );

  factory HelpModel.fromJson(Map<String, dynamic> json) => HelpModel(
        actionBy: json['action_by'],
        note: json['note'],
        id: json['_id'],
        name: json['name'],
        topics: json['topics'],
        userId: json['user_id'],
        status: json['status'],
        description: json['description'],
        photos: json['photos'] == null
            ? []
            : List<String>.from(json['photos']!.map((x) => x)),
        createdAt: json['createdAt'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        'action_by': actionBy,
        'note': note,
        '_id': id,
        'name': name,
        'topics': topics,
        'user_id': userId,
        'status': status,
        'description': description,
        'photos':
            photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
        'createdAt': createdAt,
        '__v': v,
      };
}
