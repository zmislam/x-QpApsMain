import 'dart:convert';

SinglePostModel singlePostModelFromJson(String str) =>
    SinglePostModel.fromJson(json.decode(str));

String singlePostModelToJson(SinglePostModel data) =>
    json.encode(data.toJson());

class SinglePostModel {
  int? status;
  List<Post>? post;

  SinglePostModel({
    this.status,
    this.post,
  });

  factory SinglePostModel.fromJson(Map<String, dynamic> json) =>
      SinglePostModel(
        status: json['status'],
        post: List<Post>.from(json['post'].map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'post': List<dynamic>.from(post!.map((x) => x.toJson())),
      };
}

class Post {
  String id;
  dynamic description;
  String postType;
  dynamic toUserId;
  dynamic eventType;
  dynamic eventSubType;
  User userId;
  dynamic locationId;
  dynamic feelingId;
  dynamic activityId;
  dynamic subActivityId;
  String postPrivacy;
  dynamic pageId;
  dynamic campaignId;
  dynamic sharePostId;
  dynamic shareReelsId;
  dynamic workplaceId;
  dynamic instituteId;
  dynamic link;
  dynamic linkTitle;
  dynamic linkDescription;
  dynamic linkImage;
  dynamic postBackgroundColor;
  dynamic status;
  dynamic ipAddress;
  bool isHidden;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int totalComments;
  int reactionCount;
  List<ReactionTypeCountsByPost> reactionTypeCountsByPost;
  List<dynamic> taggedUserList;
  List<Media> media;
  List<dynamic> comments;
  List<dynamic> shareMedia;
  int postShareCount;

  Post({
    required this.id,
    required this.description,
    required this.postType,
    required this.toUserId,
    required this.eventType,
    required this.eventSubType,
    required this.userId,
    required this.locationId,
    required this.feelingId,
    required this.activityId,
    required this.subActivityId,
    required this.postPrivacy,
    required this.pageId,
    required this.campaignId,
    required this.sharePostId,
    required this.shareReelsId,
    required this.workplaceId,
    required this.instituteId,
    required this.link,
    required this.linkTitle,
    required this.linkDescription,
    required this.linkImage,
    required this.postBackgroundColor,
    required this.status,
    required this.ipAddress,
    required this.isHidden,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.totalComments,
    required this.reactionCount,
    required this.reactionTypeCountsByPost,
    required this.taggedUserList,
    required this.media,
    required this.comments,
    required this.shareMedia,
    required this.postShareCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['_id'],
        description: json['description'],
        postType: json['post_type'],
        toUserId: json['to_user_id'],
        eventType: json['event_type'],
        eventSubType: json['event_sub_type'],
        userId: User.fromJson(json['user_id']),
        locationId: json['location_id'],
        feelingId: json['feeling_id'],
        activityId: json['activity_id'],
        subActivityId: json['sub_activity_id'],
        postPrivacy: json['post_privacy'],
        pageId: json['page_id'],
        campaignId: json['campaign_id'],
        sharePostId: json['share_post_id'],
        shareReelsId: json['share_reels_id'],
        workplaceId: json['workplace_id'],
        instituteId: json['institute_id'],
        link: json['link'],
        linkTitle: json['link_title'],
        linkDescription: json['link_description'],
        linkImage: json['link_image'],
        postBackgroundColor: json['post_background_color'],
        status: json['status'],
        ipAddress: json['ip_address'],
        isHidden: json['is_hidden'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        totalComments: json['totalComments'],
        reactionCount: json['reactionCount'],
        reactionTypeCountsByPost: List<ReactionTypeCountsByPost>.from(
            json['reactionTypeCountsByPost']
                .map((x) => ReactionTypeCountsByPost.fromJson(x))),
        taggedUserList:
            List<dynamic>.from(json['tagged_user_list'].map((x) => x)),
        media: List<Media>.from(json['media'].map((x) => Media.fromJson(x))),
        comments: List<dynamic>.from(json['comments'].map((x) => x)),
        shareMedia: List<dynamic>.from(json['shareMedia'].map((x) => x)),
        postShareCount: json['postShareCount'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'description': description,
        'post_type': postType,
        'to_user_id': toUserId,
        'event_type': eventType,
        'event_sub_type': eventSubType,
        'user_id': userId.toJson(),
        'location_id': locationId,
        'feeling_id': feelingId,
        'activity_id': activityId,
        'sub_activity_id': subActivityId,
        'post_privacy': postPrivacy,
        'page_id': pageId,
        'campaign_id': campaignId,
        'share_post_id': sharePostId,
        'share_reels_id': shareReelsId,
        'workplace_id': workplaceId,
        'institute_id': instituteId,
        'link': link,
        'link_title': linkTitle,
        'link_description': linkDescription,
        'link_image': linkImage,
        'post_background_color': postBackgroundColor,
        'status': status,
        'ip_address': ipAddress,
        'is_hidden': isHidden,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'totalComments': totalComments,
        'reactionCount': reactionCount,
        'reactionTypeCountsByPost':
            List<dynamic>.from(reactionTypeCountsByPost.map((x) => x.toJson())),
        'tagged_user_list': List<dynamic>.from(taggedUserList.map((x) => x)),
        'media': List<dynamic>.from(media.map((x) => x.toJson())),
        'comments': List<dynamic>.from(comments.map((x) => x)),
        'shareMedia': List<dynamic>.from(shareMedia.map((x) => x)),
        'postShareCount': postShareCount,
      };
}

class Media {
  String id;
  dynamic caption;
  String media;
  String postId;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Media({
    required this.id,
    required this.caption,
    required this.media,
    required this.postId,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json['_id'],
        caption: json['caption'],
        media: json['media'],
        postId: json['post_id'],
        status: json['status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'caption': caption,
        'media': media,
        'post_id': postId,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

class ReactionTypeCountsByPost {
  int count;
  String postId;
  String userId;
  String reactionType;
  User userDetails;

  ReactionTypeCountsByPost({
    required this.count,
    required this.postId,
    required this.userId,
    required this.reactionType,
    required this.userDetails,
  });

  factory ReactionTypeCountsByPost.fromJson(Map<String, dynamic> json) =>
      ReactionTypeCountsByPost(
        count: json['count'],
        postId: json['post_id'],
        userId: json['user_id'],
        reactionType: json['reaction_type'],
        userDetails: User.fromJson(json['user_details']),
      );

  Map<String, dynamic> toJson() => {
        'count': count,
        'post_id': postId,
        'user_id': userId,
        'reaction_type': reactionType,
        'user_details': userDetails.toJson(),
      };
}

class User {
  String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phone;
  String password;
  String profilePic;
  String coverPic;
  dynamic userStatus;
  String gender;
  String? religion;
  DateTime dateOfBirth;
  String? userBio;
  dynamic language;
  dynamic passport;
  String lastLogin;
  dynamic user2FaStatus;
  dynamic secondaryEmail;
  dynamic recoveryEmail;
  String? relationStatus;
  String homeTown;
  String? birthPlace;
  dynamic bloodGroup;
  String? resetPasswordToken;
  String? resetPasswordTokenExpires;
  dynamic userRole;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? presentTown;
  List<dynamic> emailList;
  List<String> phoneList;
  String? lockProfile;
  String? userAbout;
  String? userNickname;
  dynamic websites;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePic,
    required this.coverPic,
    required this.userStatus,
    required this.gender,
    required this.religion,
    required this.dateOfBirth,
    required this.userBio,
    required this.language,
    required this.passport,
    required this.lastLogin,
    required this.user2FaStatus,
    required this.secondaryEmail,
    required this.recoveryEmail,
    required this.relationStatus,
    required this.homeTown,
    required this.birthPlace,
    required this.bloodGroup,
    required this.resetPasswordToken,
    required this.resetPasswordTokenExpires,
    required this.userRole,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.presentTown,
    required this.emailList,
    required this.phoneList,
    this.lockProfile,
    this.userAbout,
    this.userNickname,
    this.websites,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        profilePic: json['profile_pic'],
        coverPic: json['cover_pic'],
        userStatus: json['user_status'],
        gender: json['gender'],
        religion: json['religion'],
        dateOfBirth: DateTime.parse(json['date_of_birth']),
        userBio: json['user_bio'],
        language: json['language'],
        passport: json['passport'],
        lastLogin: json['last_login'],
        user2FaStatus: json['user_2fa_status'],
        secondaryEmail: json['secondary_email'],
        recoveryEmail: json['recovery_email'],
        relationStatus: json['relation_status'],
        homeTown: json['home_town'],
        birthPlace: json['birth_place'],
        bloodGroup: json['blood_group'],
        resetPasswordToken: json['reset_password_token'],
        resetPasswordTokenExpires: json['reset_password_token_expires'],
        userRole: json['user_role'],
        status: json['status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        presentTown: json['present_town'],
        emailList: List<dynamic>.from(json['email_list'].map((x) => x)),
        phoneList: List<String>.from(json['phone_list'].map((x) => x)),
        lockProfile: json['lock_profile'],
        userAbout: json['user_about'],
        userNickname: json['user_nickname'],
        websites: json['websites'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'profile_pic': profilePic,
        'cover_pic': coverPic,
        'user_status': userStatus,
        'gender': gender,
        'religion': religion,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'user_bio': userBio,
        'language': language,
        'passport': passport,
        'last_login': lastLogin,
        'user_2fa_status': user2FaStatus,
        'secondary_email': secondaryEmail,
        'recovery_email': recoveryEmail,
        'relation_status': relationStatus,
        'home_town': homeTown,
        'birth_place': birthPlace,
        'blood_group': bloodGroup,
        'reset_password_token': resetPasswordToken,
        'reset_password_token_expires': resetPasswordTokenExpires,
        'user_role': userRole,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'present_town': presentTown,
        'email_list': List<dynamic>.from(emailList.map((x) => x)),
        'phone_list': List<dynamic>.from(phoneList.map((x) => x)),
        'lock_profile': lockProfile,
        'user_about': userAbout,
        'user_nickname': userNickname,
        'websites': websites,
      };
}
