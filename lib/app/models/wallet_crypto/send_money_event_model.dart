import 'dart:convert';

List<SendMoneyEventModel> SendMoneyEventModelFromJson(String str) => List<SendMoneyEventModel>.from(json.decode(str).map((x) => SendMoneyEventModel.fromJson(x)));

String SendMoneyEventModelToJson(List<SendMoneyEventModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SendMoneyEventModel {
  String? id;
  String? requestId;
  String? to;
  String? amountInWei;
  String? signature;
  bool? isSent;
  String? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  SendMoneyEventModel({
    this.id,
    this.requestId,
    this.to,
    this.amountInWei,
    this.signature,
    this.isSent,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SendMoneyEventModel copyWith({
    String? id,
    String? requestId,
    String? to,
    String? amountInWei,
    String? signature,
    bool? isSent,
    String? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      SendMoneyEventModel(
        id: id ?? this.id,
        requestId: requestId ?? this.requestId,
        to: to ?? this.to,
        amountInWei: amountInWei ?? this.amountInWei,
        signature: signature ?? this.signature,
        isSent: isSent ?? this.isSent,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory SendMoneyEventModel.fromJson(Map<String, dynamic> json) => SendMoneyEventModel(
        id: json['_id'],
        requestId: json['requestId'],
        to: json['to'],
        amountInWei: json['amountInWei'],
        signature: json['signature'],
        isSent: json['isSent'],
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
        'isSent': isSent,
        'user': user,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return 'SendMoneyEventModel{\nid: $id,\n requestId: $requestId,\n to: $to,\n amountInWei: $amountInWei,\n signature: $signature,\n isSent: $isSent,\n user: $user,\n createdAt: $createdAt,\n updatedAt: $updatedAt,\n v: $v\n}';
  }
}
