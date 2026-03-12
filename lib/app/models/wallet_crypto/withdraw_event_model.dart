import 'dart:convert';

List<WithdrawnEventModel> WithdrawnEventModelFromJson(String str) => List<WithdrawnEventModel>.from(json.decode(str).map((x) => WithdrawnEventModel.fromJson(x)));

String WithdrawnEventModelToJson(List<WithdrawnEventModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WithdrawnEventModel {
  String? id;
  String? requestId;
  String? amountInWei;
  String? signature;
  bool? isWithdrawn;
  String? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  WithdrawnEventModel({
    this.id,
    this.requestId,
    this.amountInWei,
    this.signature,
    this.isWithdrawn,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  WithdrawnEventModel copyWith({
    String? id,
    String? requestId,
    String? to,
    String? amountInWei,
    String? signature,
    bool? isWithdrawn,
    String? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      WithdrawnEventModel(
        id: id ?? this.id,
        requestId: requestId ?? this.requestId,
        amountInWei: amountInWei ?? this.amountInWei,
        signature: signature ?? this.signature,
        isWithdrawn: isWithdrawn ?? this.isWithdrawn,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory WithdrawnEventModel.fromJson(Map<String, dynamic> json) => WithdrawnEventModel(
        id: json['_id'],
        requestId: json['requestId'],
        amountInWei: json['amountInWei'],
        signature: json['signature'],
        isWithdrawn: json['isWithdrawn'],
        user: json['user'],
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'requestId': requestId,
        'amountInWei': amountInWei,
        'signature': signature,
        'isWithdrawn': isWithdrawn,
        'user': user,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return 'WithdrawnEventModel{\nid: $id,\n requestId: $requestId,\n amountInWei: $amountInWei,\n signature: $signature,\n isWithdrawn: $isWithdrawn,\n user: $user,\n createdAt: $createdAt,\n updatedAt: $updatedAt,\n v: $v\n}';
  }
}
