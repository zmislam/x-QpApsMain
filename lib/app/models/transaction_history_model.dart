// To parse this JSON data, do
//
//     final transactionHistoryModel = transactionHistoryModelFromJson(jsonString);

import 'dart:convert';

TransactionHistoryModel transactionHistoryModelFromJson(String str) =>
    TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) =>
    json.encode(data.toJson());

class TransactionHistoryModel {
  String? id;
  String? userId;
  String? type;
  dynamic amount;
  dynamic trxId;
  String? referenceWalletBillId;
  dynamic sendMoneyDetailsId;
  dynamic withdrawRequestQueueId;
  bool? isOrder;
  dynamic createdBy;
  String? createdAt;
  int? v;
  List<Walletbill>? walletbill;

  TransactionHistoryModel({
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
    this.createdAt,
    this.v,
    this.walletbill,
  });

  TransactionHistoryModel copyWith({
    String? id,
    String? userId,
    String? type,
    int? amount,
    dynamic trxId,
    String? referenceWalletBillId,
    dynamic sendMoneyDetailsId,
    dynamic withdrawRequestQueueId,
    bool? isOrder,
    dynamic createdBy,
    String? createdAt,
    int? v,
    List<Walletbill>? walletbill,
  }) =>
      TransactionHistoryModel(
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
        createdAt: createdAt ?? this.createdAt,
        v: v ?? this.v,
        walletbill: walletbill ?? this.walletbill,
      );

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
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
        createdAt: json['createdAt'],
        v: json['__v'],
        walletbill: json['walletbill'] == null
            ? []
            : List<Walletbill>.from(
                json['walletbill']!.map((x) => Walletbill.fromJson(x))),
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
        'createdAt': createdAt,
        '__v': v,
        'walletbill': walletbill == null
            ? []
            : List<dynamic>.from(walletbill!.map((x) => x.toJson())),
      };
}

class Walletbill {
  String? id;
  dynamic billPaidByUserId;
  String? billType;
  String? status;
  String? campaignBillId;
  String? invoiceNumber;
  dynamic transectionNo;
  dynamic totalBillAmount;
  dynamic totalPaidAmount;
  String? createdAt;
  dynamic createdBy;
  dynamic updatedBy;
  int? v;

  Walletbill({
    this.id,
    this.billPaidByUserId,
    this.billType,
    this.status,
    this.campaignBillId,
    this.invoiceNumber,
    this.transectionNo,
    this.totalBillAmount,
    this.totalPaidAmount,
    this.createdAt,
    this.createdBy,
    this.updatedBy,
    this.v,
  });

  Walletbill copyWith({
    String? id,
    dynamic billPaidByUserId,
    String? billType,
    String? status,
    String? campaignBillId,
    String? invoiceNumber,
    dynamic transectionNo,
    dynamic totalBillAmount,
    dynamic totalPaidAmount,
    String? createdAt,
    dynamic createdBy,
    dynamic updatedBy,
    int? v,
  }) =>
      Walletbill(
        id: id ?? this.id,
        billPaidByUserId: billPaidByUserId ?? this.billPaidByUserId,
        billType: billType ?? this.billType,
        status: status ?? this.status,
        campaignBillId: campaignBillId ?? this.campaignBillId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        transectionNo: transectionNo ?? this.transectionNo,
        totalBillAmount: totalBillAmount ?? this.totalBillAmount,
        totalPaidAmount: totalPaidAmount ?? this.totalPaidAmount,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        v: v ?? this.v,
      );

  factory Walletbill.fromJson(Map<String, dynamic> json) => Walletbill(
        id: json['_id'],
        billPaidByUserId: json['bill_paid_by_user_id'],
        billType: json['bill_type'],
        status: json['status'],
        campaignBillId: json['campaign_bill_id'],
        invoiceNumber: json['invoice_number'],
        transectionNo: json['transection_no'],
        totalBillAmount: json['total_bill_amount'],
        totalPaidAmount: json['total_paid_amount'],
        createdAt: json['createdAt'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'bill_paid_by_user_id': billPaidByUserId,
        'bill_type': billType,
        'status': status,
        'campaign_bill_id': campaignBillId,
        'invoice_number': invoiceNumber,
        'transection_no': transectionNo,
        'total_bill_amount': totalBillAmount,
        'total_paid_amount': totalPaidAmount,
        'createdAt': createdAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        '__v': v,
      };
}
