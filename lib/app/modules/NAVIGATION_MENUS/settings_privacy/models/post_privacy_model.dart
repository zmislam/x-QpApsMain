class PostPrivacy {
  String? id;
  String? userId;
  String? postType;
  String? whoCanSee;
  String? whoCanShare;
  String? whoCanComment;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostPrivacy({
    this.id,
    this.userId,
    this.postType,
    this.whoCanSee,
    this.whoCanShare,
    this.whoCanComment,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // fromMap method with nullable properties
  factory PostPrivacy.fromMap(Map<String, dynamic>? map) {
    if (map == null) return PostPrivacy();

    return PostPrivacy(
      id: map['_id'] as String?,
      userId: map['user_id'] as String?,
      postType: map['post_type'] as String?,
      whoCanSee: map['who_can_see'] as String?,
      whoCanShare: map['who_can_share'] as String?,
      whoCanComment: map['who_can_comment'] as String?,
      createdBy: map['created_by'] as String?,
      updatedBy: map['update_by'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // toMap method with nullable fields
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'post_type': postType,
      'who_can_see': whoCanSee,
      'who_can_share': whoCanShare,
      'who_can_comment': whoCanComment,
      'created_by': createdBy,
      'update_by': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
