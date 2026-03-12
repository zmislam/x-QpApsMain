// To parse this JSON data, do
//
//     final mintEventModel = mintEventModelFromJson(jsonString);

import 'dart:convert';

List<MintEventModel> mintEventModelFromJson(String str) => List<MintEventModel>.from(json.decode(str).map((x) => MintEventModel.fromJson(x)));

String mintEventModelToJson(List<MintEventModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MintEventModel {
  String? id;
  String? requestId;
  String? to;
  String? amountInWei;
  String? signature;
  bool? isMinted;
  String? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  MintEventModel({
    this.id,
    this.requestId,
    this.to,
    this.amountInWei,
    this.signature,
    this.isMinted,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MintEventModel copyWith({
    String? id,
    String? requestId,
    String? to,
    String? amountInWei,
    String? signature,
    bool? isMinted,
    String? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      MintEventModel(
        id: id ?? this.id,
        requestId: requestId ?? this.requestId,
        to: to ?? this.to,
        amountInWei: amountInWei ?? this.amountInWei,
        signature: signature ?? this.signature,
        isMinted: isMinted ?? this.isMinted,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory MintEventModel.fromJson(Map<String, dynamic> json) => MintEventModel(
        id: json['_id'],
        requestId: json['requestId'],
        to: json['to'],
        amountInWei: json['amountInWei'],
        signature: json['signature'],
        isMinted: json['isMinted'],
        user: json['user'],
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'requestId': requestId,
        'to': to,
        'amountInWei': amountInWei,
        'signature': signature,
        'isMinted': isMinted,
        'user': user,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return 'MintEventModel{\nid: $id,\n requestId: $requestId,\n to: $to,\n amountInWei: $amountInWei,\n signature: $signature,\n isMinted: $isMinted,\n user: $user,\n createdAt: $createdAt,\n updatedAt: $updatedAt,\n v: $v\n}';
  }
}
