// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReelsTextModel {
  String? reelsText;
  String? reelsTextFont;
  int? textColor;
  int? textBgColor;
  double? textPositionX;
  double? textPositionY;
  double? textScale;

  ReelsTextModel(
      {this.reelsText,
      this.reelsTextFont,
      this.textColor,
      this.textBgColor,
      this.textPositionX,
      this.textPositionY,
      this.textScale});

  ReelsTextModel copyWith(
      {String? reelsText,
      String? reelsTextFont,
      int? textColor,
      int? textBgColor,
      double? textPositionX,
      double? textPositionY,
      double? textScale}) {
    return ReelsTextModel(
        reelsText: reelsText ?? this.reelsText,
        reelsTextFont: reelsTextFont ?? this.reelsTextFont,
        textColor: textColor ?? this.textColor,
        textBgColor: textBgColor ?? this.textBgColor,
        textPositionX: textPositionX ?? this.textPositionX,
        textPositionY: textPositionY ?? this.textPositionY,
        textScale: textScale ?? this.textScale);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reelsText': reelsText,
      'reelsTextFont': reelsTextFont,
      'textColor': textColor,
      'textBgColor': textBgColor,
      'textPositionX': textPositionX,
      'textPositionY': textPositionY,
      'textScale': textScale
    };
  }

  factory ReelsTextModel.fromMap(Map<String, dynamic> map) {
    return ReelsTextModel(
      reelsText: map['reelsText'] != null ? map['reelsText'] as String : null,
      reelsTextFont:
          map['reelsTextFont'] != null ? map['reelsTextFont'] as String : null,
      textColor: map['textColor'] != null ? map['textColor'] as int : null,
      textBgColor:
          map['textBgColor'] != null ? map['textBgColor'] as int : null,
      textPositionX: map['textPositionX'] != null
          ? double.parse('${map['textPositionX']}')
          : null,
      textPositionY: map['textPositionY'] != null
          ? double.parse('${map['textPositionY']}')
          : null,
      textScale: map['textScale'] != null
          ? (double.parse('${map['textScale']}'))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsTextModel.fromJson(String source) =>
      ReelsTextModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelsTextModel(reelsText: $reelsText, textScale:$textScale, reelsTextFont: $reelsTextFont, textColor: $textColor, textBgColor: $textBgColor, textPositionX: $textPositionX, textPositionY: $textPositionY)';
  }

  @override
  bool operator ==(covariant ReelsTextModel other) {
    if (identical(this, other)) return true;

    return other.reelsText == reelsText &&
        other.reelsTextFont == reelsTextFont &&
        other.textColor == textColor &&
        other.textBgColor == textBgColor &&
        other.textPositionX == textPositionX &&
        other.textPositionY == textPositionY &&
        other.textScale == textScale;
  }

  @override
  int get hashCode {
    return reelsText.hashCode ^
        reelsTextFont.hashCode ^
        textColor.hashCode ^
        textBgColor.hashCode ^
        textPositionX.hashCode ^
        textPositionY.hashCode ^
        textScale.hashCode;
  }
}
