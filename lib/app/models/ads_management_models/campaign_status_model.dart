// To parse this JSON data, do
//
//     final campaignStatusModel = campaignStatusModelFromJson(jsonString);

import 'dart:convert';

List<CampaignStatusModel> campaignStatusModelFromJson(String str) => List<CampaignStatusModel>.from(json.decode(str).map((x) => CampaignStatusModel.fromJson(x)));

String campaignStatusModelToJson(List<CampaignStatusModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CampaignStatusModel {
  String? label;
  String? value;

  CampaignStatusModel({
    this.label,
    this.value,
  });

  CampaignStatusModel copyWith({
    String? label,
    String? value,
  }) =>
      CampaignStatusModel(
        label: label ?? this.label,
        value: value ?? this.value,
      );

  factory CampaignStatusModel.fromJson(Map<String, dynamic> json) => CampaignStatusModel(
        label: json['label'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}
