// To parse this JSON data, do
//
//     final cardDetailsModel = cardDetailsModelFromJson(jsonString);

import 'dart:convert';

CardDetailsModel cardDetailsModelFromJson(String str) =>
    CardDetailsModel.fromJson(json.decode(str));

String cardDetailsModelToJson(CardDetailsModel data) =>
    json.encode(data.toJson());

class CardDetailsModel {
  String? id;
  String? cardHolderUserId;
  String? cardHolderName;
  String? cardNumber;
  String? expiry;
  String? cvc;
  dynamic country;
  String? postalCode;
  bool? isForDefaultPayment;
  bool? isVerified;
  String? createdAt;
  DateTime? updatedAt;
  int? v;

  CardDetailsModel({
    this.id,
    this.cardHolderUserId,
    this.cardHolderName,
    this.cardNumber,
    this.expiry,
    this.cvc,
    this.country,
    this.postalCode,
    this.isForDefaultPayment,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CardDetailsModel copyWith({
    String? id,
    String? cardHolderUserId,
    String? cardHolderName,
    String? cardNumber,
    String? expiry,
    String? cvc,
    dynamic country,
    String? postalCode,
    bool? isForDefaultPayment,
    bool? isVerified,
    String? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      CardDetailsModel(
        id: id ?? this.id,
        cardHolderUserId: cardHolderUserId ?? this.cardHolderUserId,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        cardNumber: cardNumber ?? this.cardNumber,
        expiry: expiry ?? this.expiry,
        cvc: cvc ?? this.cvc,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        isForDefaultPayment: isForDefaultPayment ?? this.isForDefaultPayment,
        isVerified: isVerified ?? this.isVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory CardDetailsModel.fromJson(Map<String, dynamic> json) =>
      CardDetailsModel(
        id: json['_id'],
        cardHolderUserId: json['card_holder_user_id'],
        cardHolderName: json['card_holder_name'],
        cardNumber: json['card_number'],
        expiry: json['expiry'],
        cvc: json['cvc'],
        country: json['country'],
        postalCode: json['postal_code'],
        isForDefaultPayment: json['isForDefaultPayment'],
        isVerified: json['isVerified'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'card_holder_user_id': cardHolderUserId,
        'card_holder_name': cardHolderName,
        'card_number': cardNumber,
        'expiry': expiry,
        'cvc': cvc,
        'country': country,
        'postal_code': postalCode,
        'isForDefaultPayment': isForDefaultPayment,
        'isVerified': isVerified,
        'createdAt': createdAt,
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return cardNumber ?? '';
  }
}
