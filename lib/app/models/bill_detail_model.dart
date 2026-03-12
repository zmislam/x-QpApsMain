// To parse this JSON data, do
//
//     final billDetailsModel = billDetailsModelFromJson(jsonString);

import 'dart:convert';

BillDetailsModel billDetailsModelFromJson(String str) =>
    BillDetailsModel.fromJson(json.decode(str));

String billDetailsModelToJson(BillDetailsModel data) =>
    json.encode(data.toJson());

class BillDetailsModel {
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
  DateTime? updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  int? v;
  // CampaignBill? campaignBill;
  // Campaign? campaign;
  // CampaignOwner? campaignOwner;

  BillDetailsModel({
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
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.v,
    // this.campaignBill,
    // this.campaign,
    // this.campaignOwner,
  });

  BillDetailsModel copyWith({
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
    DateTime? updatedAt,
    dynamic createdBy,
    dynamic updatedBy,
    int? v,
    // CampaignBill? campaignBill,
    // Campaign? campaign,
    // CampaignOwner? campaignOwner,
  }) =>
      BillDetailsModel(
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
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        v: v ?? this.v,
        // campaignBill: campaignBill ?? this.campaignBill,
        // campaign: campaign ?? this.campaign,
        // campaignOwner: campaignOwner ?? this.campaignOwner,
      );

  factory BillDetailsModel.fromJson(Map<String, dynamic> json) =>
      BillDetailsModel(
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
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        v: json['__v'],
        // campaignBill: json["campaignBill"] == null ? null : CampaignBill.fromJson(json["campaignBill"]),
        // campaign: json["campaign"] == null ? null : Campaign.fromJson(json["campaign"]),
        // campaignOwner: json["campaign_owner"] == null ? null : CampaignOwner.fromJson(json["campaign_owner"]),
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
        'updatedAt': updatedAt?.toIso8601String(),
        'created_by': createdBy,
        'updated_by': updatedBy,
        '__v': v,
        // "campaignBill": campaignBill?.toJson(),
        // "campaign": campaign?.toJson(),
        // "campaign_owner": campaignOwner?.toJson(),
      };
}

class Campaign {
  String? id;
  String? userId;
  dynamic postId;
  dynamic deletedAt;
  String? campaignName;
  String? campaignCategory;
  String? pageName;
  String? pageId;
  DateTime? startDate;
  DateTime? endDate;
  String? callToAction;
  String? websiteUrl;
  int? totalBudget;
  int? dailyBudget;
  String? gender;
  String? headline;
  String? description;
  dynamic phoneNumber;
  List<String>? campaignCoverPic;
  String? adsPlacement;
  dynamic destination;
  String? ageGroup;
  dynamic fromAge;
  dynamic toAge;
  List<String>? locations;
  List<String>? keywords;
  String? adminStatus;
  String? status;
  String? approvedDeclinedBy;
  String? createdBy;
  String? rejectNote;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  double? earningClickPrice;
  double? earningImpressionPrice;
  double? earningReactionPrice;

  Campaign({
    this.id,
    this.userId,
    this.postId,
    this.deletedAt,
    this.campaignName,
    this.campaignCategory,
    this.pageName,
    this.pageId,
    this.startDate,
    this.endDate,
    this.callToAction,
    this.websiteUrl,
    this.totalBudget,
    this.dailyBudget,
    this.gender,
    this.headline,
    this.description,
    this.phoneNumber,
    this.campaignCoverPic,
    this.adsPlacement,
    this.destination,
    this.ageGroup,
    this.fromAge,
    this.toAge,
    this.locations,
    this.keywords,
    this.adminStatus,
    this.status,
    this.approvedDeclinedBy,
    this.createdBy,
    this.rejectNote,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.earningClickPrice,
    this.earningImpressionPrice,
    this.earningReactionPrice,
  });

  Campaign copyWith({
    String? id,
    String? userId,
    dynamic postId,
    dynamic deletedAt,
    String? campaignName,
    String? campaignCategory,
    String? pageName,
    String? pageId,
    DateTime? startDate,
    DateTime? endDate,
    String? callToAction,
    String? websiteUrl,
    int? totalBudget,
    int? dailyBudget,
    String? gender,
    String? headline,
    String? description,
    dynamic phoneNumber,
    List<String>? campaignCoverPic,
    String? adsPlacement,
    dynamic destination,
    String? ageGroup,
    dynamic fromAge,
    dynamic toAge,
    List<String>? locations,
    List<String>? keywords,
    String? adminStatus,
    String? status,
    String? approvedDeclinedBy,
    String? createdBy,
    String? rejectNote,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    double? earningClickPrice,
    double? earningImpressionPrice,
    double? earningReactionPrice,
  }) =>
      Campaign(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        deletedAt: deletedAt ?? this.deletedAt,
        campaignName: campaignName ?? this.campaignName,
        campaignCategory: campaignCategory ?? this.campaignCategory,
        pageName: pageName ?? this.pageName,
        pageId: pageId ?? this.pageId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        callToAction: callToAction ?? this.callToAction,
        websiteUrl: websiteUrl ?? this.websiteUrl,
        totalBudget: totalBudget ?? this.totalBudget,
        dailyBudget: dailyBudget ?? this.dailyBudget,
        gender: gender ?? this.gender,
        headline: headline ?? this.headline,
        description: description ?? this.description,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        campaignCoverPic: campaignCoverPic ?? this.campaignCoverPic,
        adsPlacement: adsPlacement ?? this.adsPlacement,
        destination: destination ?? this.destination,
        ageGroup: ageGroup ?? this.ageGroup,
        fromAge: fromAge ?? this.fromAge,
        toAge: toAge ?? this.toAge,
        locations: locations ?? this.locations,
        keywords: keywords ?? this.keywords,
        adminStatus: adminStatus ?? this.adminStatus,
        status: status ?? this.status,
        approvedDeclinedBy: approvedDeclinedBy ?? this.approvedDeclinedBy,
        createdBy: createdBy ?? this.createdBy,
        rejectNote: rejectNote ?? this.rejectNote,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        earningClickPrice: earningClickPrice ?? this.earningClickPrice,
        earningImpressionPrice:
            earningImpressionPrice ?? this.earningImpressionPrice,
        earningReactionPrice: earningReactionPrice ?? this.earningReactionPrice,
      );

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
        id: json['_id'],
        userId: json['user_id'],
        postId: json['post_id'],
        deletedAt: json['deleted_at'],
        campaignName: json['campaign_name'],
        campaignCategory: json['campaign_category'],
        pageName: json['page_name'],
        pageId: json['page_id'],
        startDate: json['start_date'] == null
            ? null
            : DateTime.parse(json['start_date']),
        endDate:
            json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        callToAction: json['call_to_action'],
        websiteUrl: json['website_url'],
        totalBudget: json['total_budget'],
        dailyBudget: json['daily_budget'],
        gender: json['gender'],
        headline: json['headline'],
        description: json['description'],
        phoneNumber: json['phone_number'],
        campaignCoverPic: json['campaign_cover_pic'] == null
            ? []
            : List<String>.from(json['campaign_cover_pic']!.map((x) => x)),
        adsPlacement: json['ads_placement'],
        destination: json['destination'],
        ageGroup: json['age_group'],
        fromAge: json['from_age'],
        toAge: json['to_age'],
        locations: json['locations'] == null
            ? []
            : List<String>.from(json['locations']!.map((x) => x)),
        keywords: json['keywords'] == null
            ? []
            : List<String>.from(json['keywords']!.map((x) => x)),
        adminStatus: json['admin_status'],
        status: json['status'],
        approvedDeclinedBy: json['approved_declined_by'],
        createdBy: json['created_by'],
        rejectNote: json['reject_note'],
        updatedBy: json['updated_by'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        v: json['__v'],
        earningClickPrice: json['earning_click_price']?.toDouble(),
        earningImpressionPrice: json['earning_impression_price']?.toDouble(),
        earningReactionPrice: json['earning_reaction_price']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'post_id': postId,
        'deleted_at': deletedAt,
        'campaign_name': campaignName,
        'campaign_category': campaignCategory,
        'page_name': pageName,
        'page_id': pageId,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'call_to_action': callToAction,
        'website_url': websiteUrl,
        'total_budget': totalBudget,
        'daily_budget': dailyBudget,
        'gender': gender,
        'headline': headline,
        'description': description,
        'phone_number': phoneNumber,
        'campaign_cover_pic': campaignCoverPic == null
            ? []
            : List<dynamic>.from(campaignCoverPic!.map((x) => x)),
        'ads_placement': adsPlacement,
        'destination': destination,
        'age_group': ageGroup,
        'from_age': fromAge,
        'to_age': toAge,
        'locations': locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x)),
        'keywords':
            keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
        'admin_status': adminStatus,
        'status': status,
        'approved_declined_by': approvedDeclinedBy,
        'created_by': createdBy,
        'reject_note': rejectNote,
        'updated_by': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'earning_click_price': earningClickPrice,
        'earning_impression_price': earningImpressionPrice,
        'earning_reaction_price': earningReactionPrice,
      };
}

class CampaignBill {
  String? id;
  String? campaignId;
  String? billMonth;
  int? totalClicked;
  int? totalImpressed;
  int? totalReached;
  int? totalImpressionBill;
  double? totalReachedBill;
  int? totalClickedBill;
  int? totalBill;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  int? v;

  CampaignBill({
    this.id,
    this.campaignId,
    this.billMonth,
    this.totalClicked,
    this.totalImpressed,
    this.totalReached,
    this.totalImpressionBill,
    this.totalReachedBill,
    this.totalClickedBill,
    this.totalBill,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.v,
  });

  CampaignBill copyWith({
    String? id,
    String? campaignId,
    String? billMonth,
    int? totalClicked,
    int? totalImpressed,
    int? totalReached,
    int? totalImpressionBill,
    double? totalReachedBill,
    int? totalClickedBill,
    int? totalBill,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic createdBy,
    dynamic updatedBy,
    int? v,
  }) =>
      CampaignBill(
        id: id ?? this.id,
        campaignId: campaignId ?? this.campaignId,
        billMonth: billMonth ?? this.billMonth,
        totalClicked: totalClicked ?? this.totalClicked,
        totalImpressed: totalImpressed ?? this.totalImpressed,
        totalReached: totalReached ?? this.totalReached,
        totalImpressionBill: totalImpressionBill ?? this.totalImpressionBill,
        totalReachedBill: totalReachedBill ?? this.totalReachedBill,
        totalClickedBill: totalClickedBill ?? this.totalClickedBill,
        totalBill: totalBill ?? this.totalBill,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        v: v ?? this.v,
      );

  factory CampaignBill.fromJson(Map<String, dynamic> json) => CampaignBill(
        id: json['_id'],
        campaignId: json['campaign_id'],
        billMonth: json['bill_month'],
        totalClicked: json['total_clicked'],
        totalImpressed: json['total_impressed'],
        totalReached: json['total_reached'],
        totalImpressionBill: json['total_impression_bill'],
        totalReachedBill: json['total_reached_bill']?.toDouble(),
        totalClickedBill: json['total_clicked_bill'],
        totalBill: json['total_bill'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'campaign_id': campaignId,
        'bill_month': billMonth,
        'total_clicked': totalClicked,
        'total_impressed': totalImpressed,
        'total_reached': totalReached,
        'total_impression_bill': totalImpressionBill,
        'total_reached_bill': totalReachedBill,
        'total_clicked_bill': totalClickedBill,
        'total_bill': totalBill,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'created_by': createdBy,
        'updated_by': updatedBy,
        '__v': v,
      };
}

class CampaignOwner {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;

  CampaignOwner({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
  });

  CampaignOwner copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
  }) =>
      CampaignOwner(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  factory CampaignOwner.fromJson(Map<String, dynamic> json) => CampaignOwner(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone': phone,
      };
}
