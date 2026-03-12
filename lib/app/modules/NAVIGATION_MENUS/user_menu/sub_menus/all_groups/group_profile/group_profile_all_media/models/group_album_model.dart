import 'dart:convert';

class GroupAlbumModel {
  String? id;
  String? title;
  String? privacy;
  String? user_id;
  String? createdAt;
  String? updatedAt;
  int? v;
  MediaModel? medias;
  GroupAlbumModel({
    this.id,
    this.title,
    this.privacy,
    this.user_id,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.medias,
  });

  GroupAlbumModel copyWith({
    String? id,
    String? title,
    String? privacy,
    String? user_id,
    String? createdAt,
    String? updatedAt,
    int? v,
    MediaModel? medias,
  }) {
    return GroupAlbumModel(
      id: id ?? this.id,
      title: title ?? this.title,
      privacy: privacy ?? this.privacy,
      user_id: user_id ?? this.user_id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      medias: medias ?? this.medias,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'privacy': privacy,
      'user_id': user_id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'medias': medias?.toMap(),
    };
  }

  factory GroupAlbumModel.fromMap(Map<String, dynamic> map) {
    return GroupAlbumModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['_v'] != null ? map['_v'] as int : null,
      medias: map['medias'] != null
          ? MediaModel.fromMap(map['medias'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupAlbumModel.fromJson(String source) =>
      GroupAlbumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupAlbumModel(id: $id, title: $title, privacy: $privacy, user_id: $user_id, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, medias: $medias)';
  }

  @override
  bool operator ==(covariant GroupAlbumModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.privacy == privacy &&
        other.user_id == user_id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.medias == medias;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        privacy.hashCode ^
        user_id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        medias.hashCode;
  }
}

class MediaModel {
  String? id;
  String? fileName;
  int? count;
  MediaModel({
    this.id,
    this.fileName,
    this.count,
  });

  MediaModel copyWith({
    String? id,
    String? fileName,
    int? count,
  }) {
    return MediaModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'fileName': fileName,
      'count': count,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      fileName: map['fileName'] != null ? map['fileName'] as String : null,
      count: map['count'] != null ? map['count'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaModel.fromJson(String source) =>
      MediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MediaModel(id: $id, fileName: $fileName, count: $count)';

  @override
  bool operator ==(covariant MediaModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.fileName == fileName && other.count == count;
  }

  @override
  int get hashCode => id.hashCode ^ fileName.hashCode ^ count.hashCode;
}
