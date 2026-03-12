// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/ad_product_model.dart';
import 'package:quantum_possibilities_flutter/app/models/campaign_model.dart';
import 'package:quantum_possibilities_flutter/app/models/post.dart';
import 'package:quantum_possibilities_flutter/app/models/user_id.dart';

class SharePostIdModel {
  String? id;
  String? description;
  String? post_type;
  String? to_user_id;
  String? event_type;
  String? event_sub_type;
  UserIdModel? user_id;
  LocationId? location_id;
  dynamic locationName;
  FeelingId? feeling_id;
  String? activity_id;
  String? sub_activity_id;
  String? post_privacy;
  PageId? page_id;
  AdProduct? adProduct;
  Campaign? campaignModel;
  String? share_post_id;
  String? share_reels_id;
  WorkplaceId? workplace_id;
  InstituteId? institute_id;
  LifeEventId? lifeEventId;
  GroupId? groupId;

  String? link;
  String? link_title;
  String? link_description;
  String? link_image;
  String? post_background_color;
  String? status;
  String? ip_address;
  bool? is_hidden;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  SharePostIdModel({
    this.id,
    this.description,
    this.post_type,
    this.to_user_id,
    this.event_type,
    this.event_sub_type,
    this.user_id,
    this.location_id,
    this.locationName,
    this.feeling_id,
    this.activity_id,
    this.sub_activity_id,
    this.post_privacy,
    this.page_id,
    this.adProduct,
    this.campaignModel,
    this.share_post_id,
    this.share_reels_id,
    this.workplace_id,
    this.institute_id,
    this.lifeEventId,
    this.groupId,
    this.link,
    this.link_title,
    this.link_description,
    this.link_image,
    this.post_background_color,
    this.status,
    this.ip_address,
    this.is_hidden,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SharePostIdModel copyWith({
    String? id,
    String? description,
    String? post_type,
    String? to_user_id,
    String? event_type,
    String? event_sub_type,
    UserIdModel? user_id,
    LocationId? location_id,
    dynamic locationName,
    String? feeling_id,
    String? activity_id,
    String? sub_activity_id,
    String? post_privacy,
    PageId? page_id,
    AdProduct? adProduct,
    Campaign? campaignModel,
    String? share_post_id,
    String? share_reels_id,
    WorkplaceId? workplace_id,
    InstituteId? institute_id,
    LifeEventId? lifeEventId,
    GroupId? groupId,
    String? link,
    String? link_title,
    String? link_description,
    String? link_image,
    String? post_background_color,
    String? status,
    String? ip_address,
    bool? is_hidden,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return SharePostIdModel(
      id: id ?? this.id,
      description: description ?? this.description,
      post_type: post_type ?? this.post_type,
      to_user_id: to_user_id ?? this.to_user_id,
      event_type: event_type ?? this.event_type,
      event_sub_type: event_sub_type ?? this.event_sub_type,
      user_id: user_id ?? this.user_id,
      location_id: location_id != null ? this.location_id : null,
      locationName: locationName != null ? this.locationName : null,
      feeling_id: feeling_id == null
          ? this.feeling_id
          : FeelingId(id: id, feelingName: 'feelingName', logo: ''),
      activity_id: activity_id ?? this.activity_id,
      sub_activity_id: sub_activity_id ?? this.sub_activity_id,
      post_privacy: post_privacy ?? this.post_privacy,
      page_id: page_id ?? this.page_id,
      adProduct: adProduct != null ? this.adProduct : AdProduct(),
      campaignModel: campaignModel != null ? this.campaignModel : Campaign(),
      groupId: groupId != null ? this.groupId : GroupId.empty(),
      share_post_id: share_post_id ?? this.share_post_id,
      share_reels_id: share_reels_id ?? this.share_reels_id,
      workplace_id:
          workplace_id == null ? this.workplace_id : WorkplaceId.empty(),
      institute_id:
          institute_id == null ? this.institute_id : InstituteId.empty(),
      lifeEventId: lifeEventId != null ? this.lifeEventId : null,
      link: link ?? this.link,
      link_title: link_title ?? this.link_title,
      link_description: link_description ?? this.link_description,
      link_image: link_image ?? this.link_image,
      post_background_color:
          post_background_color ?? this.post_background_color,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      is_hidden: is_hidden ?? this.is_hidden,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'description': description,
      'post_type': post_type,
      'to_user_id': to_user_id,
      'event_type': event_type,
      'event_sub_type': event_sub_type,
      'user_id': user_id?.toMap(),
      'location_id': location_id,
      'location_name': locationName,
      'feeling_id': feeling_id,
      'activity_id': activity_id,
      'sub_activity_id': sub_activity_id,
      'post_privacy': post_privacy,
      'page_id': page_id,
      'product_id': adProduct?.toJson(),
      'campaign_id': campaignModel?.toJson(),
      'share_post_id': share_post_id,
      'share_reels_id': share_reels_id,
      'workplace_id': workplace_id,
      'institute_id': institute_id,
      'life_event_id': lifeEventId?.toJson(),
      'group_id': groupId?.toJson(),
      'link': link,
      'link_title': link_title,
      'link_description': link_description,
      'link_image': link_image,
      'post_background_color': post_background_color,
      'status': status,
      'ip_address': ip_address,
      'is_hidden': is_hidden,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory SharePostIdModel.fromMap(Map<String, dynamic> map) {
    return SharePostIdModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      post_type: map['post_type'] != null ? map['post_type'] as String : null,
      to_user_id:
          map['to_user_id'] != null ? map['to_user_id'] as String : null,
      event_type:
          map['event_type'] != null ? map['event_type'] as String : null,
      event_sub_type: map['event_sub_type'] != null
          ? map['event_sub_type'] as String
          : null,
      user_id: map['user_id'] != null
          ? UserIdModel.fromMap(map['user_id'] as Map<String, dynamic>)
          : null,
      location_id: map['location_id'] != null
          ? LocationId.fromJson(map['location_id'])
          : null,
      locationName: map['location_name'],
      feeling_id: map['feeling_id'] != null
          ? FeelingId.fromJson(map['feeling_id'] as Map<String, dynamic>)
          : null,
      lifeEventId: map['life_event_id'] == null
          ? null
          : LifeEventId.fromJson(map['life_event_id']),
      groupId: map['group_id'] == null
          ? GroupId.empty()
          : (map['group_id'] is Map<String, dynamic>)
              ? GroupId.fromJson(map['group_id']) // Handle as a Map
              : GroupId.fromJson({'id': map['group_id']}),
      adProduct: map['product_id'] == null
          ? AdProduct()
          : AdProduct.fromJson(map['product_id']),
      campaignModel: map['campaign_id'] == null
          ? Campaign()
          : Campaign.fromJson(map['campaign_id']),
      activity_id:
          map['activity_id'] != null ? map['activity_id'] as String : null,
      sub_activity_id: map['sub_activity_id'] != null
          ? map['sub_activity_id'] as String
          : null,
      post_privacy:
          map['post_privacy'] != null ? map['post_privacy'] as String : null,
      page_id: map['page_id'] != null
          ? PageId.fromJson(map['page_id'])
          : null,
      share_post_id:
          map['share_post_id'] != null ? map['share_post_id'] as String : null,
      // share_reels_id: map['share_reels_id'] != null
      //     ? map['share_reels_id'] as String
      // : null,
      workplace_id: map['workplace_id'] != null
          ? WorkplaceId.fromJson(map['workplace_id'])
          : WorkplaceId.empty(),
      institute_id: map['institute_id'] != null
          ? InstituteId.fromJson(map['institute_id'])
          : InstituteId.empty(),
      link: map['link'] != null ? map['link'] as String : null,
      link_title:
          map['link_title'] != null ? map['link_title'] as String : null,
      link_description: map['link_description'] != null
          ? map['link_description'] as String
          : null,
      link_image:
          map['link_image'] != null ? map['link_image'] as String : null,
      post_background_color: map['post_background_color'] != null
          ? map['post_background_color'] as String
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      is_hidden: map['is_hidden'] != null ? map['is_hidden'] as bool : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['v'] != null ? map['v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharePostIdModel.fromJson(String source) =>
      SharePostIdModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SharePostIdModel(id: $id, description: $description, post_type: $post_type, to_user_id: $to_user_id, event_type: $event_type, event_sub_type: $event_sub_type, user_id: $user_id, location_id: $location_id, feeling_id: $feeling_id, life_event_id:$lifeEventId activity_id: $activity_id, sub_activity_id: $sub_activity_id, post_privacy: $post_privacy, page_id: $page_id, product_id: $adProduct , campaign_id:$campaignModel, share_post_id: $share_post_id, share_reels_id: $share_reels_id, workplace_id: $workplace_id, institute_id: $institute_id, link: $link, link_title: $link_title, link_description: $link_description, link_image: $link_image, post_background_color: $post_background_color, status: $status, ip_address: $ip_address, is_hidden: $is_hidden, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant SharePostIdModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.post_type == post_type &&
        other.to_user_id == to_user_id &&
        other.event_type == event_type &&
        other.event_sub_type == event_sub_type &&
        other.user_id == user_id &&
        other.location_id == location_id &&
        other.feeling_id == feeling_id &&
        other.activity_id == activity_id &&
        other.sub_activity_id == sub_activity_id &&
        other.post_privacy == post_privacy &&
        other.page_id == page_id &&
        other.adProduct == adProduct &&
        other.campaignModel == campaignModel &&
        other.share_post_id == share_post_id &&
        other.share_reels_id == share_reels_id &&
        other.workplace_id == workplace_id &&
        other.institute_id == institute_id &&
        other.lifeEventId == lifeEventId &&
        other.link == link &&
        other.link_title == link_title &&
        other.link_description == link_description &&
        other.link_image == link_image &&
        other.post_background_color == post_background_color &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.is_hidden == is_hidden &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        post_type.hashCode ^
        to_user_id.hashCode ^
        event_type.hashCode ^
        event_sub_type.hashCode ^
        user_id.hashCode ^
        location_id.hashCode ^
        feeling_id.hashCode ^
        activity_id.hashCode ^
        sub_activity_id.hashCode ^
        post_privacy.hashCode ^
        page_id.hashCode ^
        campaignModel.hashCode ^
        share_post_id.hashCode ^
        share_reels_id.hashCode ^
        workplace_id.hashCode ^
        institute_id.hashCode ^
        lifeEventId.hashCode ^
        link.hashCode ^
        link_title.hashCode ^
        link_description.hashCode ^
        link_image.hashCode ^
        post_background_color.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        is_hidden.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class WorkplaceId {
  String? id;
  String? userId;
  String? orgId;
  int? v;
  DateTime? createdAt;
  dynamic createdBy;
  dynamic designation;
  dynamic fromDate;
  bool? isWorking;
  String? orgName;
  String? privacy;
  int? status;
  dynamic toDate;
  dynamic updateBy;
  DateTime? updatedAt;
  String? username;

  WorkplaceId({
    required this.id,
    required this.userId,
    required this.orgId,
    required this.v,
    required this.createdAt,
    required this.createdBy,
    required this.designation,
    required this.fromDate,
    required this.isWorking,
    required this.orgName,
    required this.privacy,
    required this.status,
    required this.toDate,
    required this.updateBy,
    required this.updatedAt,
    required this.username,
  });

  WorkplaceId copyWith({
    String? id,
    String? userId,
    String? orgId,
    int? v,
    DateTime? createdAt,
    dynamic createdBy,
    dynamic designation,
    dynamic fromDate,
    bool? isWorking,
    String? orgName,
    String? privacy,
    int? status,
    dynamic toDate,
    dynamic updateBy,
    DateTime? updatedAt,
    String? username,
  }) =>
      WorkplaceId(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        orgId: orgId ?? this.orgId,
        v: v ?? this.v,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        designation: designation ?? this.designation,
        fromDate: fromDate ?? this.fromDate,
        isWorking: isWorking ?? this.isWorking,
        orgName: orgName ?? this.orgName,
        privacy: privacy ?? this.privacy,
        status: status ?? this.status,
        toDate: toDate ?? this.toDate,
        updateBy: updateBy ?? this.updateBy,
        updatedAt: updatedAt ?? this.updatedAt,
        username: username ?? this.username,
      );

  factory WorkplaceId.fromJson(Map<String, dynamic> json) => WorkplaceId(
        id: json['_id'],
        userId: json['user_id'],
        orgId: json['org_id'],
        v: json['__v'],
        createdAt: DateTime.parse(json['createdAt']),
        createdBy: json['created_by'],
        designation: json['designation'],
        fromDate: json['from_date'],
        isWorking: json['is_working'],
        orgName: json['org_name'],
        privacy: json['privacy']!,
        status: json['status'],
        toDate: json['to_date'],
        updateBy: json['update_by'],
        updatedAt: DateTime.parse(json['updatedAt']),
        username: json['username'],
      );

  factory WorkplaceId.empty() => WorkplaceId(
        id: '',
        userId: '',
        orgId: '',
        v: 0,
        createdAt: DateTime.now(),
        createdBy: '',
        designation: '',
        fromDate: '',
        isWorking: true,
        orgName: '',
        privacy: '',
        status: 0,
        toDate: '',
        updateBy: '',
        updatedAt: DateTime.now(),
        username: '',
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'org_id': orgId,
        '__v': v,
        'createdAt': createdAt,
        'created_by': createdBy,
        'designation': designation,
        'from_date': fromDate,
        'is_working': isWorking,
        'org_name': orgName,
        'privacy': privacy,
        'status': status,
        'to_date': toDate,
        'update_by': updateBy,
        'updatedAt': updatedAt,
        'username': username,
      };
}

class InstituteId {
  String? id;
  String? userId;
  String? username;
  dynamic designation;
  dynamic instituteTypeId;
  dynamic instituteId;
  String? instituteName;
  dynamic isStudying;
  DateTime? startDate;
  dynamic endDate;
  dynamic description;
  String? privacy;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  InstituteId({
    required this.id,
    required this.userId,
    required this.username,
    required this.designation,
    required this.instituteTypeId,
    required this.instituteId,
    required this.instituteName,
    required this.isStudying,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.privacy,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  InstituteId copyWith({
    String? id,
    String? userId,
    String? username,
    dynamic designation,
    dynamic instituteTypeId,
    dynamic instituteId,
    String? instituteName,
    dynamic isStudying,
    DateTime? startDate,
    DateTime? endDate,
    dynamic description,
    String? privacy,
    dynamic status,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      InstituteId(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        designation: designation ?? this.designation,
        instituteTypeId: instituteTypeId ?? this.instituteTypeId,
        instituteId: instituteId ?? this.instituteId,
        instituteName: instituteName ?? this.instituteName,
        isStudying: isStudying ?? this.isStudying,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        privacy: privacy ?? this.privacy,
        status: status ?? this.status,
        ipAddress: ipAddress ?? ipAddress,
        createdBy: createdBy ?? this.createdBy,
        updateBy: updateBy ?? this.updateBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory InstituteId.fromJson(Map<String, dynamic> json) => InstituteId(
        id: json['_id'],
        userId: json['user_id'],
        username: json['username'],
        designation: json['designation'],
        instituteTypeId: json['institute_type_id'],
        instituteId: json['institute_id'],
        instituteName: json['institute_name'],
        isStudying: json['is_studying'],
        startDate: json['startDate'] == null
            ? DateTime.now()
            : DateTime.parse(json['startDate']),
        endDate: json['endDate'] == null
            ? DateTime.now()
            : DateTime.parse(json['endDate']),
        description: json['description'],
        privacy: json['privacy'],
        status: json['status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  factory InstituteId.empty() => InstituteId(
        id: '',
        userId: '',
        username: '',
        v: 0,
        designation: '',
        instituteTypeId: '',
        instituteId: '',
        instituteName: '',
        createdAt: DateTime.now(),
        createdBy: '',
        isStudying: '',
        startDate: DateTime.now(),
        privacy: '',
        status: 0,
        endDate: DateTime.now(),
        description: '',
        updateBy: '',
        updatedAt: DateTime.now(),
        ipAddress: null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'username': username,
        'designation': designation,
        'institute_type_id': instituteTypeId,
        'institute_id': instituteId,
        'institute_name': instituteName,
        'is_studying': isStudying,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
        'privacy': privacy,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}
