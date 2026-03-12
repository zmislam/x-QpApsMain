// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StickerEmojiModel {
  String? id;
  String? name;
  String? type;
  String? file_name;
  String? createdAt;
  String? updatedAt;
  int? v;
  StickerEmojiModel({
    this.id,
    this.name,
    this.type,
    this.file_name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'type': type,
      'file_name': file_name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '_v': v,
    };
  }

  factory StickerEmojiModel.fromMap(Map<String, dynamic> map) {
    return StickerEmojiModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      file_name: map['file_name'] != null ? map['file_name'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  @override
  String toString() {
    return 'StickerEmojiModel(id: $id, name: $name, type: $type, file_name: $file_name, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant StickerEmojiModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.file_name == file_name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        file_name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }

  StickerEmojiModel copyWith({
    String? id,
    String? name,
    String? type,
    String? file_name,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return StickerEmojiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      file_name: file_name ?? this.file_name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  String toJson() => json.encode(toMap());

  factory StickerEmojiModel.fromJson(String source) =>
      StickerEmojiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
