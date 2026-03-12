class SharedReelsResponse {
  int? status;
  int? totalCount;
  List<SharedReelsModel>? data;

  SharedReelsResponse({this.status, this.totalCount, this.data});

  factory SharedReelsResponse.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SharedReelsResponse();
    return SharedReelsResponse(
      status: map['status'] as int?,
      totalCount: map['totalCount'] as int?,
      data: (map['data'] as List<dynamic>?)?.map((e) => SharedReelsModel.fromMap(e as Map<String, dynamic>?)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalCount': totalCount,
      'data': data?.map((e) => e.toMap()).toList(),
    };
  }
}

class SharedReelsModel {
  String? id;
  String? description;
  String? postType;
  String? userId;
  String? shareReelsId;
  String? createdAt;
  SharedReelDetails? reels;

  SharedReelsModel({
    this.id,
    this.description,
    this.postType,
    this.userId,
    this.shareReelsId,
    this.createdAt,
    this.reels,
  });

  factory SharedReelsModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SharedReelsModel();
    return SharedReelsModel(
      id: map['_id'] as String?,
      description: map['description'] as String?,
      postType: map['post_type'] as String?,
      userId: map['user_id'] as String?,
      shareReelsId: map['share_reels_id'] as String?,
      createdAt: map['createdAt'] as String?,
      reels: SharedReelDetails.fromMap(map['reels'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'description': description,
      'post_type': postType,
      'user_id': userId,
      'share_reels_id': shareReelsId,
      'createdAt': createdAt,
      'reels': reels?.toMap(),
    };
  }
}

class SharedReelDetails {
  String? id;
  String? description;
  String? userId;
  String? videoThumbnail;
  String? video;
  String? reelsPrivacy;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  ReelUser? reelUser;
  int? viewCount;

  SharedReelDetails({
    this.id,
    this.description,
    this.userId,
    this.videoThumbnail,
    this.video,
    this.reelsPrivacy,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.reelUser,
    this.viewCount,
  });

  factory SharedReelDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SharedReelDetails();
    return SharedReelDetails(
      id: map['_id'] as String?,
      description: map['description'] as String?,
      userId: map['user_id'] as String?,
      videoThumbnail: map['video_thumbnail'] as String?,
      video: map['video'] as String?,
      reelsPrivacy: map['reels_privacy'] as String?,
      status: map['status'] as String?,
      ipAddress: map['ip_address'] as String?,
      viewCount: map['view_count'] as int?,
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
      reelUser: ReelUser.fromMap(map['reel_user'] as Map<String, dynamic>?),
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'description': description,
      'user_id': userId,
      'video_thumbnail': videoThumbnail,
      'video': video,
      'reels_privacy': reelsPrivacy,
      'status': status,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'reel_user': reelUser?.toMap(),
      'view_count': viewCount,
    };
  }
}

class ReelUser {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? profilePic;

  ReelUser({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.profilePic,
  });

  factory ReelUser.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ReelUser();
    return ReelUser(
      id: map['_id'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      profilePic: map['profile_pic'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'profile_pic': profilePic,
    };
  }
}