// To parse this JSON data, do
//
//     final sendMoneyHistoryModel = sendMoneyHistoryModelFromJson(jsonString);

import 'dart:convert';

SendMoneyHistoryModel sendMoneyHistoryModelFromJson(String str) =>
    SendMoneyHistoryModel.fromJson(json.decode(str));

String sendMoneyHistoryModelToJson(SendMoneyHistoryModel data) =>
    json.encode(data.toJson());

class SendMoneyHistoryModel {
  String? id;
  String? userId;
  String? type;
  dynamic amount;
  dynamic trxId;
  dynamic referenceWalletBillId;
  String? sendMoneyDetailsId;
  dynamic withdrawRequestQueueId;
  bool? isOrder;
  String? createdBy;
  int? v;
  String? createdAt;
  DateTime? updatedAt;
  List<SendMoneyDetail>? sendMoneyDetails;
  bool? isSended;

  SendMoneyHistoryModel({
    this.id,
    this.userId,
    this.type,
    this.amount,
    this.trxId,
    this.referenceWalletBillId,
    this.sendMoneyDetailsId,
    this.withdrawRequestQueueId,
    this.isOrder,
    this.createdBy,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.sendMoneyDetails,
    this.isSended,
  });

  SendMoneyHistoryModel copyWith({
    String? id,
    String? userId,
    String? type,
    int? amount,
    dynamic trxId,
    dynamic referenceWalletBillId,
    String? sendMoneyDetailsId,
    dynamic withdrawRequestQueueId,
    bool? isOrder,
    String? createdBy,
    int? v,
    String? createdAt,
    DateTime? updatedAt,
    List<SendMoneyDetail>? sendMoneyDetails,
    bool? isSended,
  }) =>
      SendMoneyHistoryModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        trxId: trxId ?? this.trxId,
        referenceWalletBillId:
            referenceWalletBillId ?? this.referenceWalletBillId,
        sendMoneyDetailsId: sendMoneyDetailsId ?? this.sendMoneyDetailsId,
        withdrawRequestQueueId:
            withdrawRequestQueueId ?? this.withdrawRequestQueueId,
        isOrder: isOrder ?? this.isOrder,
        createdBy: createdBy ?? this.createdBy,
        v: v ?? this.v,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sendMoneyDetails: sendMoneyDetails ?? this.sendMoneyDetails,
        isSended: isSended ?? this.isSended,
      );

  factory SendMoneyHistoryModel.fromJson(Map<String, dynamic> json) =>
      SendMoneyHistoryModel(
        id: json['_id'],
        userId: json['user_id'],
        type: json['type'],
        amount: json['amount'],
        trxId: json['trxId'],
        referenceWalletBillId: json['reference_wallet_bill_id'],
        sendMoneyDetailsId: json['send_money_details_id'],
        withdrawRequestQueueId: json['withdraw_request_queue_id'],
        isOrder: json['is_order'],
        createdBy: json['created_by'],
        v: json['__v'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        sendMoneyDetails: json['sendMoneyDetails'] == null
            ? []
            : List<SendMoneyDetail>.from(json['sendMoneyDetails']!
                .map((x) => SendMoneyDetail.fromJson(x))),
        isSended: json['isSended'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'type': type,
        'amount': amount,
        'trxId': trxId,
        'reference_wallet_bill_id': referenceWalletBillId,
        'send_money_details_id': sendMoneyDetailsId,
        'withdraw_request_queue_id': withdrawRequestQueueId,
        'is_order': isOrder,
        'created_by': createdBy,
        '__v': v,
        'createdAt': createdAt,
        'updatedAt': updatedAt?.toIso8601String(),
        'sendMoneyDetails': sendMoneyDetails == null
            ? []
            : List<dynamic>.from(sendMoneyDetails!.map((x) => x.toJson())),
        'isSended': isSended,
      };
}

class SendMoneyDetail {
  String? id;
  String? fromUserId;
  String? toUserId;
  dynamic remarks;
  String? createdAt;
  DateTime? updatedAt;
  int? v;
  List<EntUser>? sentUser;
  List<EntUser>? recipientUser;

  SendMoneyDetail({
    this.id,
    this.fromUserId,
    this.toUserId,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.sentUser,
    this.recipientUser,
  });

  SendMoneyDetail copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    dynamic remarks,
    String? createdAt,
    DateTime? updatedAt,
    int? v,
    List<EntUser>? sentUser,
    List<EntUser>? recipientUser,
  }) =>
      SendMoneyDetail(
        id: id ?? this.id,
        fromUserId: fromUserId ?? this.fromUserId,
        toUserId: toUserId ?? this.toUserId,
        remarks: remarks ?? this.remarks,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        sentUser: sentUser ?? this.sentUser,
        recipientUser: recipientUser ?? this.recipientUser,
      );

  factory SendMoneyDetail.fromJson(Map<String, dynamic> json) =>
      SendMoneyDetail(
        id: json['_id'],
        fromUserId: json['from_user_id'],
        toUserId: json['to_user_id'],
        remarks: json['remarks'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        v: json['__v'],
        sentUser: json['sent_user'] == null
            ? []
            : List<EntUser>.from(
                json['sent_user']!.map((x) => EntUser.fromJson(x))),
        recipientUser: json['recipient_user'] == null
            ? []
            : List<EntUser>.from(
                json['recipient_user']!.map((x) => EntUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'from_user_id': fromUserId,
        'to_user_id': toUserId,
        'remarks': remarks,
        'created_at': createdAt,
        'updated_at': updatedAt?.toIso8601String(),
        '__v': v,
        'sent_user': sentUser == null
            ? []
            : List<dynamic>.from(sentUser!.map((x) => x.toJson())),
        'recipient_user': recipientUser == null
            ? []
            : List<dynamic>.from(recipientUser!.map((x) => x.toJson())),
      };
}

class EntUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  EntUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  EntUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
  }) =>
      EntUser(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
      );

  factory EntUser.fromJson(Map<String, dynamic> json) => EntUser(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      };
}
