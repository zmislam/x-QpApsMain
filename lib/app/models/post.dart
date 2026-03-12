// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/ad_product_model.dart';

import 'package:quantum_possibilities_flutter/app/models/campain.dart';
import 'package:quantum_possibilities_flutter/app/models/comment_model.dart';
import 'package:quantum_possibilities_flutter/app/models/media.dart';
import 'package:quantum_possibilities_flutter/app/models/share_post_id.dart';
import 'package:quantum_possibilities_flutter/app/models/user_id.dart';

class PostModel {
  String? id;
  String? description;
  String? post_type;
  UserIdModel? to_user_id;
  String? event_type;
  String? event_sub_type;
  UserIdModel? user_id;
  LocationId? location_id;
  String? locationName;
  FeelingId? feeling_id;
  String? activity_id;
  String? sub_activity_id;

  /// MUST NEVER BE NULL (PostCard uses groupId!.groupName!.length)
  GroupId groupId;

  String? post_privacy;
  AdProduct? adProduct;

  /// MUST NEVER BE NULL (PostCard uses page_id!.pageName!.length)
  PageId page_id;

  CampainModel? campaign_id;
  SharePostIdModel? share_post_id;
  ShareReelsId? share_reels_id;

  WorkplaceId? workplace_id;
  InstituteId? institute_id;
  LifeEventId? lifeEventId;
  String? link;
  String? link_title;
  String? link_description;
  String? link_image;
  String? post_background_color;
  String? status;
  String? ip_address;
  bool? is_hidden;
  bool? is_live;
  bool? pinPost;
  bool? isBookMarked;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  String? v;
  String? url;
  List<MediaModel>? media;
  String? layout_type;
  List<MediaModel>? shareMedia;
  List<TaggedUserList>? taggedUserList;
  List<CommentModel>? comments;
  int? totalComments;
  int? reactionCount;
  int? postShareCount;
  int? view_count;
  Bookmark? bookmark;
  List<ReactionModel>? reactionTypeCountsByPost;

  bool? is_web;
  String? live_reels_id;
  String? modification_date;
  String? data_sort_property;
  String? latestActivityDate;
  List<dynamic>? friends;
  int? dislikeCount;
  bool? isFriend;
  bool? isFriendRequestSended;
  bool? isFollowingPage;
  bool? isGroupMember;
  bool? isIgnored;
  String? key;
  String? whyShown;
  Map<String, dynamic>? reactionSummary;

  PostModel({
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

    /// default non-null
    GroupId? groupId,
    this.post_privacy,
    this.adProduct,

    /// default non-null
    PageId? page_id,
    this.campaign_id,
    this.share_post_id,
    this.share_reels_id,
    this.workplace_id,
    this.institute_id,
    this.lifeEventId,
    this.link,
    this.link_title,
    this.link_description,
    this.link_image,
    this.post_background_color,
    this.status,
    this.ip_address,
    this.is_hidden,
    this.is_live,
    this.pinPost,
    this.isBookMarked,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.url,
    this.media,
    this.layout_type,
    this.shareMedia,
    this.taggedUserList,
    this.comments,
    this.totalComments,
    this.reactionCount,
    this.postShareCount,
    this.view_count,
    this.bookmark,
    this.reactionTypeCountsByPost,
    this.is_web,
    this.live_reels_id,
    this.modification_date,
    this.data_sort_property,
    this.latestActivityDate,
    this.friends,
    this.dislikeCount,
    this.isFriend,
    this.isFriendRequestSended,
    this.isFollowingPage,
    this.isGroupMember,
    this.isIgnored,
    this.key,
    this.whyShown,
    this.reactionSummary,
  })  : groupId = groupId ?? GroupId.empty(),
        page_id = page_id ?? PageId.empty();

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'],
      description: map['description'],
      post_type: map['post_type'],
      to_user_id: map['to_user_id'] != null
          ? UserIdModel.fromMap(map['to_user_id'])
          : null,
      event_type: map['event_type'],
      event_sub_type: map['event_sub_type'],
      user_id:
          map['user_id'] != null ? UserIdModel.fromMap(map['user_id']) : null,
      location_id: map['location_id'] != null
          ? LocationId.fromJson(map['location_id'])
          : null,
      locationName: map['location_name'],
      feeling_id: map['feeling_id'] != null
          ? FeelingId.fromJson(map['feeling_id'])
          : null,
      lifeEventId: map['life_event_id'] != null
          ? LifeEventId.fromJson(map['life_event_id'])
          : null,
      activity_id: map['activity_id'],
      sub_activity_id: map['sub_activity_id'],

      /// SAFE: never null
      groupId: map['group_id'] != null
          ? GroupId.fromJson(map['group_id'])
          : GroupId.empty(),

      post_privacy: map['post_privacy'],
      adProduct: map['product_id'] != null
          ? AdProduct.fromJson(map['product_id'])
          : null,

      /// SAFE: never null
      page_id: map['page_id'] != null
          ? PageId.fromJson(map['page_id'])
          : PageId.empty(),

      campaign_id: map['campaign_id'] != null
          ? CampainModel.fromMap(map['campaign_id'])
          : null,

      /// SAFE: nested defaults inside SharePostIdModel
      share_post_id: map['share_post_id'] != null
          ? SharePostIdModel.fromMap(map['share_post_id'])
          : null,

      share_reels_id: map['share_reels_id'] != null
          ? ShareReelsId.fromJson(map['share_reels_id'])
          : null,

      workplace_id: map['workplace_id'] != null
          ? WorkplaceId.fromJson(map['workplace_id'])
          : null,
      institute_id: map['institute_id'] != null
          ? InstituteId.fromMap(map['institute_id'])
          : null,
      link: map['link'],
      link_title: map['link_title'],
      link_description: map['link_description'],
      link_image: map['link_image'],
      post_background_color: map['post_background_color'],
      status: map['status'],
      ip_address: map['ip_address'],
      is_hidden: map['is_hidden'],
      is_live: map['is_live'],
      pinPost: map['pin_post'],
      isBookMarked: map['isBookMarked'],
      created_by: map['created_by'],
      updated_by: map['updated_by'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      v: map['__v']?.toString(),
      url: map['url'],
      layout_type: map['layout_type'],

      media: map['media'] != null
          ? List<MediaModel>.from(
              map['media'].map((x) => MediaModel.fromMap(x)))
          : null,

      shareMedia: map['shareMedia'] != null
          ? List<MediaModel>.from(
              map['shareMedia'].map((x) => MediaModel.fromMap(x)))
          : null,

      taggedUserList: map['tagged_user_list'] != null
          ? List<TaggedUserList>.from(
              map['tagged_user_list'].map((x) => TaggedUserList.fromJson(x)))
          : null,

      comments: map['comments'] != null
          ? List<CommentModel>.from(
              map['comments'].map((x) => CommentModel.fromMap(x)))
          : null,

      totalComments: map['totalComments'],
      reactionCount: map['reactionCount'],
      postShareCount: map['postShareCount'],
      view_count: map['view_count'],
      bookmark:
          map['bookmark'] != null ? Bookmark.fromJson(map['bookmark']) : null,

      reactionTypeCountsByPost: map['reactionTypeCountsByPost'] != null
          ? List<ReactionModel>.from(map['reactionTypeCountsByPost']
              .map((x) => ReactionModel.fromMap(x)))
          : null,

      is_web: map['is_web'],
      live_reels_id: map['live_reels_id'],
      modification_date: map['modification_date'],
      data_sort_property: map['data_sort_property'],
      latestActivityDate: map['latestActivityDate'],
      friends: map['friends'],
      dislikeCount: map['dislikeCount'],
      isFriend: map['isFriend'],
      isFriendRequestSended: map['isFriendRequestSended'],
      isFollowingPage: map['is_following_page'],
      isGroupMember: map['is_group_member'],
      isIgnored: map['isIgnored'],
      key: map['key'],
      whyShown: map['_why_shown'],
      reactionSummary: map['reactionSummary'] != null
          ? Map<String, dynamic>.from(map['reactionSummary'])
          : null,
    );
  }

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}

//===================================================== Reaction Model =====================================================//

class ReactionModel {
  int? count;
  String? post_id;
  String? reaction_type;
  String? user_id;

  ReactionModel({
    this.count,
    this.post_id,
    this.reaction_type,
    this.user_id,
  });

  ReactionModel copyWith({
    int? count,
    String? post_id,
    String? reaction_type,
    String? user_id,
  }) {
    return ReactionModel(
      count: count ?? this.count,
      post_id: post_id ?? this.post_id,
      reaction_type: reaction_type ?? this.reaction_type,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'post_id': post_id,
      'reaction_type': reaction_type,
      'user_id': user_id,
    };
  }

  factory ReactionModel.fromMap(Map<String, dynamic> map) {
    return ReactionModel(
      count: map['count'] != null ? map['count'] as int : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      reaction_type:
          map['reaction_type'] != null ? map['reaction_type'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReactionModel.fromJson(String source) =>
      ReactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReactionModel(count: $count, post_id: $post_id, reaction_type: $reaction_type, user_id: $user_id)';
  }

  @override
  bool operator ==(covariant ReactionModel other) {
    if (identical(this, other)) return true;

    return other.count == count &&
        other.post_id == post_id &&
        other.reaction_type == reaction_type &&
        other.user_id == user_id;
  }

  @override
  int get hashCode {
    return count.hashCode ^
        post_id.hashCode ^
        reaction_type.hashCode ^
        user_id.hashCode;
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
  String? designation;
  String? instituteTypeId;
  String? instituteId;
  String? instituteName;
  dynamic isStudying;
  String? startDate;
  String? endDate;
  String? description;
  String? privacy;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updateBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  InstituteId({
    this.id,
    this.userId,
    this.username,
    this.designation,
    this.instituteTypeId,
    this.instituteId,
    this.instituteName,
    required this.isStudying,
    this.startDate,
    this.endDate,
    this.description,
    this.privacy,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  InstituteId copyWith({
    String? id,
    String? userId,
    String? username,
    String? designation,
    String? instituteTypeId,
    String? instituteId,
    String? instituteName,
    dynamic isStudying,
    String? startDate,
    String? endDate,
    String? description,
    String? privacy,
    String? status,
    String? ipAddress,
    String? createdBy,
    String? updateBy,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return InstituteId(
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
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'username': username,
      'designation': designation,
      'instituteTypeId': instituteTypeId,
      'instituteId': instituteId,
      'institute_name': instituteName,
      'isStudying': isStudying,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'privacy': privacy,
      'status': status,
      'ipAddress': ipAddress,
      'createdBy': createdBy,
      'updateBy': updateBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory InstituteId.fromMap(Map<String, dynamic> map) {
    return InstituteId(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      designation:
          map['designation'] != null ? map['designation'] as String : null,
      instituteTypeId: map['instituteTypeId'] != null
          ? map['instituteTypeId'] as String
          : null,
      instituteId:
          map['instituteId'] != null ? map['instituteId'] as String : null,
      instituteName:
          map['institute_name'] != null ? map['institute_name'] as String : '',
      isStudying: map['isStudying'] as dynamic,
      startDate: map['startDate'] != null ? map['startDate'] as String : null,
      endDate: map['endDate'] != null ? map['endDate'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ipAddress: map['ipAddress'] != null ? map['ipAddress'] as String : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : null,
      updateBy: map['updateBy'] != null ? map['updateBy'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['v'] != null ? map['v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InstituteId.fromJson(String source) =>
      InstituteId.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InstituteId(id: $id, userId: $userId, username: $username, designation: $designation, instituteTypeId: $instituteTypeId, instituteId: $instituteId, instituteName: $instituteName, isStudying: $isStudying, startDate: $startDate, endDate: $endDate, description: $description, privacy: $privacy, status: $status, ipAddress: $ipAddress, createdBy: $createdBy, updateBy: $updateBy, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant InstituteId other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.username == username &&
        other.designation == designation &&
        other.instituteTypeId == instituteTypeId &&
        other.instituteId == instituteId &&
        other.instituteName == instituteName &&
        other.isStudying == isStudying &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.description == description &&
        other.privacy == privacy &&
        other.status == status &&
        other.ipAddress == ipAddress &&
        other.createdBy == createdBy &&
        other.updateBy == updateBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        designation.hashCode ^
        instituteTypeId.hashCode ^
        instituteId.hashCode ^
        instituteName.hashCode ^
        isStudying.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        description.hashCode ^
        privacy.hashCode ^
        status.hashCode ^
        ipAddress.hashCode ^
        createdBy.hashCode ^
        updateBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class GroupId {
  String? id;
  String? groupName;
  String? groupPrivacy;
  String? visibility;
  bool? isPostApprove;
  dynamic participantApproveBy;
  dynamic postApproveBy;
  String? groupCoverPic;
  String? groupDescription;
  String? location;
  dynamic customLink;
  String? address;
  String? zipCode;
  String? groupCreatedUserId;
  dynamic status;
  dynamic ipAddress;
  String? createdBy;
  dynamic createdDate;
  dynamic updateBy;
  dynamic updateDate;
  String? createdAt;
  int? v;

  GroupId({
    required this.id,
    required this.groupName,
    required this.groupPrivacy,
    required this.visibility,
    required this.isPostApprove,
    required this.participantApproveBy,
    required this.postApproveBy,
    required this.groupCoverPic,
    required this.groupDescription,
    required this.location,
    required this.customLink,
    required this.address,
    required this.zipCode,
    required this.groupCreatedUserId,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.createdDate,
    required this.updateBy,
    required this.updateDate,
    required this.createdAt,
    required this.v,
  });

  GroupId copyWith({
    String? id,
    String? groupName,
    String? groupPrivacy,
    String? visibility,
    dynamic deletedAt,
    bool? isPostApprove,
    dynamic participantApproveBy,
    dynamic postApproveBy,
    String? groupCoverPic,
    String? groupDescription,
    String? location,
    dynamic customLink,
    String? address,
    String? zipCode,
    String? groupCreatedUserId,
    dynamic status,
    dynamic ipAddress,
    String? createdBy,
    dynamic createdDate,
    String? createdAt,
    // int? v,
  }) =>
      GroupId(
        id: id ?? this.id,
        groupName: groupName ?? this.groupName,
        groupPrivacy: groupPrivacy ?? this.groupPrivacy,
        visibility: visibility ?? this.visibility,
        isPostApprove: isPostApprove ?? this.isPostApprove,
        participantApproveBy: participantApproveBy ?? this.participantApproveBy,
        postApproveBy: postApproveBy ?? this.postApproveBy,
        groupCoverPic: groupCoverPic ?? this.groupCoverPic,
        groupDescription: groupDescription ?? this.groupDescription,
        location: location ?? this.location,
        customLink: customLink ?? this.customLink,
        address: address ?? this.address,
        zipCode: zipCode ?? this.zipCode,
        groupCreatedUserId: groupCreatedUserId ?? this.groupCreatedUserId,
        status: status ?? this.status,
        ipAddress: ipAddress ?? this.ipAddress,
        createdBy: createdBy ?? this.createdBy,
        createdDate: createdDate ?? this.createdDate,
        updateBy: updateBy ?? updateBy,
        updateDate: updateDate ?? updateDate,
        createdAt: createdAt ?? this.createdAt,
        v: v ?? v,
      );

  factory GroupId.fromJson(Map<String, dynamic> json) {
    return GroupId(
      id: json['_id'] as String?,
      groupName: json['group_name'] as String?,
      groupPrivacy: json['group_privacy'] as String?,
      visibility: json['visibility'] as String?,
      isPostApprove: json['is_post_approve'] as bool?,
      participantApproveBy: json['participant_approve_by'] as String?,
      postApproveBy: json['post_approve_by'] as String?,
      groupCoverPic: json['group_cover_pic'] as String?,
      groupDescription: json['group_description'] as String?,
      location: json['location'] as String?,
      customLink: json['custom_link'] as String?,
      address: json['address'] as String?,
      zipCode: json['zip_code'] as String?,
      groupCreatedUserId: json['group_created_user_id'] as String?,
      status: json['status'] as String?,
      ipAddress: json['ip_address'] as String?,
      createdBy: json['created_by'] as String?,
      createdDate: json['created_date'] as String?,
      updateBy: json['update_by'] as String?,
      updateDate: json['update_Date'] as String?,
      createdAt: json['createdAt'] as String?,
      v: json['__v'] as int?, // Nullable field for __v
    );
  }

  factory GroupId.empty() => GroupId(
        id: '',
        groupName: '',
        groupPrivacy: '',
        visibility: '',
        isPostApprove: true,
        participantApproveBy: '',
        postApproveBy: '',
        groupCoverPic: '',
        groupDescription: '',
        location: '',
        customLink: '',
        address: '',
        zipCode: '',
        groupCreatedUserId: '',
        status: '',
        v: 0,
        createdAt: DateTime.now().toString(),
        createdBy: '',
        updateBy: '',
        ipAddress: null,
        createdDate: '',
        updateDate: '',
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'group_name': groupName,
        'group_privacy': groupPrivacy,
        'visibility': visibility,
        'is_post_approve': isPostApprove,
        'participant_approve_by': participantApproveBy,
        'post_approve_by': postApproveBy,
        'group_cover_pic': groupCoverPic,
        'group_description': groupDescription,
        'location': location,
        'custom_link': customLink,
        'address': address,
        'zip_code': zipCode,
        'group_created_user_id': groupCreatedUserId,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'created_date': createdDate,
        'update_by': updateBy,
        'update_Date': updateDate,
        'createdAt': createdAt,
        '__v': v,
      };
}

class FeelingId {
  String? id;
  String? feelingName;
  String? logo;

  FeelingId({
    required this.id,
    required this.feelingName,
    required this.logo,
  });

  FeelingId copyWith({
    String? id,
    String? feelingName,
    String? logo,
  }) =>
      FeelingId(
        id: id ?? this.id,
        feelingName: feelingName ?? this.feelingName,
        logo: logo ?? this.logo,
      );

  factory FeelingId.fromJson(Map<String, dynamic> json) => FeelingId(
        id: json['_id'],
        feelingName: json['feeling_name'],
        logo: json['logo'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'feeling_name': feelingName,
        'logo': logo,
      };
}

class LocationId {
  String? id;
  String? locationName;
  dynamic subAddress;
  String? city;
  String? lat;
  String? lng;
  String? country;
  String? countryCode;

  LocationId({
    required this.id,
    required this.locationName,
    required this.subAddress,
    this.city,
    this.lat,
    this.lng,
    this.country,
    this.countryCode,
  });

  LocationId copyWith({
    String? id,
    String? locationName,
    dynamic image,
    dynamic subAddress,
    String? city,
    String? lat,
    String? lng,
    String? country,
    String? countryCode,
  }) =>
      LocationId(
        id: id ?? this.id,
        locationName: locationName ?? this.locationName,
        subAddress: subAddress ?? this.subAddress,
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
      );

  factory LocationId.fromJson(Map<String, dynamic> json) => LocationId(
        id: json['_id'],
        locationName: json['location_name'],
        subAddress: json['sub_address'],
        city: json['city'],
        lat: json['lat'],
        lng: json['lng'],
        country: json['country'],
        countryCode: json['country_code'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'location_name': locationName,
        'sub_address': subAddress,
        'city': city,
        'lat': lat,
        'lng': lng,
        'country': country,
        'country_code': countryCode,
      };
}

class TaggedUserList {
  User? user;

  TaggedUserList({
    required this.user,
  });

  TaggedUserList copyWith({
    User? user,
  }) =>
      TaggedUserList(
        user: user != null ? this.user : null,
      );

  factory TaggedUserList.fromJson(Map<String, dynamic> json) => TaggedUserList(
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'user': user,
      };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
      };

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        username.hashCode;
  }
}

class PageId {
  String? id;
  String? pageName;
  String? bio;
  String? website;
  String? profilePic;
  String? coverPic;
  String? pageUserName;
  dynamic pageMessage;
  dynamic pageReaction;
  int? v;

  PageId({
    required this.id,
    required this.pageName,
    required this.bio,
    required this.website,
    required this.profilePic,
    required this.coverPic,
    required this.pageUserName,
    required this.pageMessage,
    required this.pageReaction,
    required this.v,
  });

  PageId copyWith({
    String? id,
    String? pageName,
    String? bio,
    String? website,
    String? profilePic,
    String? coverPic,
    dynamic pageMessage,
    dynamic pageReaction,
    int? v,
  }) =>
      PageId(
        id: id ?? this.id,
        pageName: pageName ?? this.pageName,
        bio: bio ?? this.bio,
        website: website ?? this.website,
        profilePic: profilePic ?? this.profilePic,
        coverPic: coverPic ?? this.coverPic,
        pageUserName: pageUserName ?? pageUserName,
        pageMessage: pageMessage ?? this.pageMessage,
        pageReaction: pageReaction ?? this.pageReaction,
        v: v ?? this.v,
      );

  factory PageId.fromJson(Map<String, dynamic> json) => PageId(
        id: json['_id'],
        pageName: json['page_name'],
        bio: json['bio'],
        website: json['website'],
        profilePic: json['profile_pic'],
        coverPic: json['cover_pic'],
        pageUserName: json['page_user_name'],
        pageMessage: json['page_message'],
        pageReaction: json['page_reaction'],
        v: json['__v'],
      );

  factory PageId.empty() => PageId(
        id: '',
        pageName: '',
        bio: '',
        website: '',
        profilePic: '',
        coverPic: '',
        pageUserName: '',
        pageMessage: '',
        pageReaction: '',
        v: 0,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'page_name': pageName,
        'bio': bio,
        'website': website,
        'profile_pic': profilePic,
        'cover_pic': coverPic,
        'page_user_name': pageUserName,
        'page_message': pageMessage,
        'page_reaction': pageReaction,
        '__v': v,
      };
}

class ShareReelsId {
  String? id;
  String? description;
  UserIdModel? userId;
  String? video;
  String? reelsPrivacy;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updatedBy;
  String? createdAt;
  DateTime? updatedAt;
  int v;

  ShareReelsId({
    required this.id,
    required this.description,
    required this.userId,
    required this.video,
    required this.reelsPrivacy,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  ShareReelsId copyWith({
    String? id,
    String? description,
    UserIdModel? userId,
    String? video,
    String? reelsPrivacy,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updatedBy,
    String? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      ShareReelsId(
        id: id ?? this.id,
        description: description ?? this.description,
        userId: userId ?? this.userId,
        video: video ?? this.video,
        reelsPrivacy: reelsPrivacy ?? this.reelsPrivacy,
        status: status ?? this.status,
        ipAddress: ipAddress ?? this.ipAddress,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory ShareReelsId.fromJson(Map<String, dynamic> json) => ShareReelsId(
        id: json['_id'],
        description: json['description'],
        userId: UserIdModel.fromMap(json['user_id']),
        video: json['video'],
        reelsPrivacy: json['reels_privacy'],
        status: json['status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['createdAt'],
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'description': description,
        'user_id': userId,
        'video': video,
        'reels_privacy': reelsPrivacy,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}

class LifeEventId {
  String? id;
  String? eventType;
  String? title;
  String? description;
  String? username;
  String? locationName;
  String? iconName;
  DateTime? date;
  ToUserId? toUserId;
  dynamic createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  LifeEventId({
    this.id,
    this.eventType,
    this.title,
    this.description,
    this.username,
    this.locationName,
    this.iconName,
    this.date,
    this.toUserId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  LifeEventId copyWith({
    String? id,
    String? eventType,
    String? title,
    String? description,
    String? username,
    String? locationName,
    String? iconName,
    DateTime? date,
    ToUserId? toUserId,
    dynamic createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      LifeEventId(
        id: id ?? this.id,
        eventType: eventType ?? this.eventType,
        title: title ?? this.title,
        description: description ?? this.description,
        username: username ?? this.username,
        locationName: locationName ?? this.locationName,
        iconName: iconName ?? this.iconName,
        date: date ?? this.date,
        toUserId: toUserId ?? this.toUserId,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory LifeEventId.fromJson(Map<String, dynamic> json) => LifeEventId(
        id: json['_id'],
        eventType: json['event_type'],
        title: json['title'],
        description: json['description'],
        username: json['username'],
        locationName: json['location_name'],
        iconName: json['icon_name'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        toUserId: json['to_user_id'] != null
            ? ToUserId.fromJson(json['to_user_id'])
            : null,
        createdBy: json['created_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'event_type': eventType,
        'title': title,
        'description': description,
        'username': username,
        'location_name': locationName,
        'icon_name': iconName,
        'date': date,
        'to_user_id': toUserId,
        'created_by': createdBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}

class ToUserId {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;
  dynamic profilePic;
  dynamic coverPic;
  dynamic userStatus;
  dynamic religion;
  dynamic userBio;
  dynamic relationStatus;
  dynamic userNickname;
  dynamic lockProfile;
  int? v;

  ToUserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.coverPic,
    required this.userStatus,
    required this.religion,
    required this.userBio,
    required this.relationStatus,
    required this.userNickname,
    required this.lockProfile,
    required this.v,
  });

  ToUserId copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    dynamic profilePic,
    dynamic coverPic,
    dynamic userStatus,
    dynamic religion,
    dynamic userBio,
    dynamic relationStatus,
    dynamic userNickname,
    dynamic lockProfile,
    int? v,
  }) =>
      ToUserId(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        profilePic: profilePic ?? this.profilePic,
        coverPic: coverPic ?? this.coverPic,
        userStatus: userStatus ?? this.userStatus,
        religion: religion ?? this.religion,
        userBio: userBio ?? this.userBio,
        relationStatus: relationStatus ?? this.relationStatus,
        userNickname: userNickname ?? this.userNickname,
        lockProfile: lockProfile ?? this.lockProfile,
        v: v ?? this.v,
      );

  factory ToUserId.fromJson(Map<String, dynamic> json) => ToUserId(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        profilePic: json['profile_pic'],
        coverPic: json['cover_pic'],
        userStatus: json['user_status'],
        religion: json['religion'],
        userBio: json['user_bio'],
        relationStatus: json['relation_status'],
        userNickname: json['user_nickname'],
        lockProfile: json['lock_profile'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone': phone,
        'profile_pic': profilePic,
        'cover_pic': coverPic,
        'user_status': userStatus,
        'religion': religion,
        'user_bio': userBio,
        'relation_status': relationStatus,
        'user_nickname': userNickname,
        'lock_profile': lockProfile,
        '__v': v,
      };
}

class Bookmark {
  String? id;
  String? postPrivacy;
  String? postId;
  String? userId;
  int v;

  Bookmark({
    required this.id,
    required this.postPrivacy,
    required this.postId,
    required this.userId,
    required this.v,
  });

  Bookmark copyWith({
    String? id,
    String? postPrivacy,
    String? postId,
    String? userId,
    int? v,
  }) =>
      Bookmark(
        id: id ?? this.id,
        postPrivacy: postPrivacy ?? this.postPrivacy,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        v: v ?? this.v,
      );

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['_id'],
        postPrivacy: json['post_privacy'],
        postId: json['post_id'],
        userId: json['user_id'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'post_privacy': postPrivacy,
        'post_id': postId,
        'user_id': userId,
        '__v': v,
      };
}
