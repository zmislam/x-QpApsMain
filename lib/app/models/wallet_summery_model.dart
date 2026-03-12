// To parse this JSON data, do
//
//     final walletSummeryModel = walletSummeryModelFromJson(jsonString);

import 'dart:convert';

WalletSummeryModel walletSummeryModelFromJson(String str) => WalletSummeryModel.fromJson(json.decode(str));

String walletSummeryModelToJson(WalletSummeryModel data) => json.encode(data.toJson());

class WalletSummeryModel {
  int? status;
  dynamic walletBalance;
  dynamic totalSendMoneyAmount;
  dynamic totalReceivedMoneyAmount;
  dynamic totalWithdrawRequestAmount;

  WalletSummeryModel({
    this.status,
    this.walletBalance,
    this.totalSendMoneyAmount,
    this.totalReceivedMoneyAmount,
    this.totalWithdrawRequestAmount,
  });

  WalletSummeryModel copyWith({
    int? status,
    dynamic walletBalance,
    dynamic totalSendMoneyAmount,
    dynamic totalReceivedMoneyAmount,
    dynamic totalWithdrawRequestAmount,
  }) =>
      WalletSummeryModel(
        status: status ?? this.status,
        walletBalance: walletBalance ?? this.walletBalance,
        totalSendMoneyAmount: totalSendMoneyAmount ?? this.totalSendMoneyAmount,
        totalReceivedMoneyAmount: totalReceivedMoneyAmount ?? this.totalReceivedMoneyAmount,
        totalWithdrawRequestAmount: totalWithdrawRequestAmount ?? this.totalWithdrawRequestAmount,
      );

  factory WalletSummeryModel.fromJson(Map<String, dynamic> json) => WalletSummeryModel(
    status: json['status'],
    walletBalance: json['wallet_balance']?.toDouble(),
    totalSendMoneyAmount: json['total_send_money_amount'],
    totalReceivedMoneyAmount: json['total_received_money_amount'],
    totalWithdrawRequestAmount: json['total_withdraw_request_amount'],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'wallet_balance': walletBalance,
    'total_send_money_amount': totalSendMoneyAmount,
    'total_received_money_amount': totalReceivedMoneyAmount,
    'total_withdraw_request_amount': totalWithdrawRequestAmount,
  };
}
