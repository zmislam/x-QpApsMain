// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReelsEmojiModel {
  double? positionX;
  double? positionY;
  double? emojiScale;
  String? emojiSrc;
  String? emojiType;

  ReelsEmojiModel({
    this.positionX,
    this.positionY,
    this.emojiScale,
    this.emojiSrc,
    this.emojiType,
  });

  ReelsEmojiModel copyWith({
    double? positionX,
    double? positionY,
    double? emojiScale,
    String? emojiSrc,
    String? emojiType,
  }) {
    return ReelsEmojiModel(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      emojiScale: emojiScale ?? this.emojiScale,
      emojiSrc: emojiSrc ?? this.emojiSrc,
      emojiType: emojiType ?? this.emojiType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'positionX': positionX,
      'positionY': positionY,
      'emojiScale': emojiScale,
      'emojiSrc': emojiSrc,
      'emojiType': emojiType,
    };
  }

  factory ReelsEmojiModel.fromMap(Map<String, dynamic> map) {
    return ReelsEmojiModel(
      positionX:
          map['positionX'] != null ? double.parse('${map['positionX']}') : null,
      positionY:
          map['positionY'] != null ? double.parse('${map['positionY']}') : null,
      emojiScale: map['emojiScale'] != null
          ? double.parse('${map['emojiScale']}')
          : null,
      emojiSrc: map['emojiSrc'] != null ? map['emojiSrc'] as String : null,
      emojiType: map['emojiType'] != null ? map['emojiType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsEmojiModel.fromJson(String source) =>
      ReelsEmojiModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelsEmojiModel(positionX: $positionX, positionY: $positionY, emojiSrc: $emojiSrc, emojiType: $emojiType, emojiScale: $emojiScale)';
  }

  @override
  bool operator ==(covariant ReelsEmojiModel other) {
    if (identical(this, other)) return true;

    return other.positionX == positionX &&
        other.positionY == positionY &&
        other.emojiSrc == emojiSrc &&
        other.emojiType == emojiType &&
        other.emojiScale == emojiScale;
  }

  @override
  int get hashCode {
    return positionX.hashCode ^
        positionY.hashCode ^
        emojiSrc.hashCode ^
        emojiType.hashCode ^
        emojiScale.hashCode;
  }
}
