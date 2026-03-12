// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LanguageModel {
  String? id;
  String? user_id;

  String? privacy;
  String? language;
  bool? is_language_verified;

  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  LanguageModel({
    this.id,
    this.user_id,
    this.language,
    this.is_language_verified,
    this.privacy,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  LanguageModel copyWith(
      {String? id,
      String? user_id,
      bool? is_language_verified,
      String? language,
      String? privacy,
      String? created_by,
      String? update_by,
      String? createdAt,
      String? updatedAt,
      int? v}) {
    return LanguageModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      is_language_verified: is_language_verified ?? this.is_language_verified,
      language: language ?? this.language,
      privacy: privacy ?? this.privacy,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'user_id': user_id,
      'is_language_verified': is_language_verified,
      'language': language,
      'privacy': privacy,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      is_language_verified: map['is_language_verified'] != null
          ? map['is_language_verified'] as bool
          : null,
      language: map['language'] != null ? map['language'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) =>
      LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Language(id: $id, user_id: $user_id,'
        'language:$language,is_language_verified:$is_language_verified, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant LanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.is_language_verified == is_language_verified &&
        other.language == language &&
        other.privacy == privacy &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        is_language_verified.hashCode ^
        language.hashCode ^
        privacy.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
