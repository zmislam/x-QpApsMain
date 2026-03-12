class ProfilPicturesemodel {
  String? id;
  String? caption;
  String? media;
  String? postId;
  String? albumId;
  String? status;
  int? ipAddress;
  String? createdBy;
  String? updateBy;
  int? v;
  String? createdAt;
  String? updatedAt;

  /// ✅ New key field
  String? key;

  ProfilPicturesemodel({
    this.id,
    this.caption,
    this.media,
    this.postId,
    this.albumId,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.key, // <-- added
  });

  ProfilPicturesemodel copyWith({
    String? id,
    String? caption,
    String? media,
    String? postId,
    String? albumId,
    String? status,
    int? ipAddress,
    String? createdBy,
    String? updateBy,
    int? v,
    String? createdAt,
    String? updatedAt,
    String? key, // <-- added
  }) {
    return ProfilPicturesemodel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      media: media ?? this.media,
      postId: postId ?? this.postId,
      albumId: albumId ?? this.albumId,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      key: key ?? this.key, // <-- added
    );
  }

  factory ProfilPicturesemodel.fromMap(Map<String, dynamic> map) {
    return ProfilPicturesemodel(
      id: map['_id'],
      caption: map['caption'],
      media: map['media'],
      postId: map['post_id'],
      albumId: map['album_id'],
      status: map['status'],
      ipAddress: map['ip_address'],
      createdBy: map['created_by'],
      updateBy: map['update_by'],
      v: map['__v'],
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      key: map['key'], // <-- added
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'caption': caption,
    'media': media,
    'post_id': postId,
    'album_id': albumId,
    'status': status,
    'ip_address': ipAddress,
    'created_by': createdBy,
    'update_by': updateBy,
    '__v': v,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'key': key, // <-- added
  };
}
