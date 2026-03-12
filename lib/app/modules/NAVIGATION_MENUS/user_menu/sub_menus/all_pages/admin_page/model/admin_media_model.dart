class PageMediaModel {
  String? id;
  String? title;
  String? privacy;
  String? userId;
  String? pageId;
  String? groupId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Media? medias;

  /// ✅ New key field
  String? key;

  PageMediaModel({
    this.id,
    this.title,
    this.privacy,
    this.userId,
    this.pageId,
    this.groupId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.medias,
    this.key, // <-- added
  });

  PageMediaModel copyWith({
    String? id,
    String? title,
    String? privacy,
    String? userId,
    String? pageId,
    String? groupId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Media? medias,
    String? key, // <-- added
  }) {
    return PageMediaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      privacy: privacy ?? this.privacy,
      userId: userId ?? this.userId,
      pageId: pageId ?? this.pageId,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      medias: medias ?? this.medias,
      key: key ?? this.key,
    );
  }

  factory PageMediaModel.fromMap(Map<String, dynamic> json) {
    return PageMediaModel(
      id: json['_id'],
      title: json['title'],
      privacy: json['privacy'],
      userId: json['user_id'],
      pageId: json['page_id'],
      groupId: json['group_id'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
      medias: json['medias'] != null ? Media.fromJson(json['medias']) : null,
      key: json['key'], // <-- added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'privacy': privacy,
      'user_id': userId,
      'page_id': pageId,
      'group_id': groupId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'medias': medias?.toJson(),
      'key': key, // <-- added
    };
  }
}

class Media {
  String? id;
  String? fileName;
  int? count;

  Media({
    this.id,
    this.fileName,
    this.count,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'],
      fileName: json['fileName'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fileName': fileName,
      'count': count,
    };
  }
}
