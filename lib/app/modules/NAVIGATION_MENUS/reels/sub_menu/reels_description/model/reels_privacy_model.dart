// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class ReelsPrivacyModel {
  IconData? icon;
  String? privacyStatus;
  ReelsPrivacyModel({
    this.icon,
    this.privacyStatus,
  });

  ReelsPrivacyModel copyWith({
    IconData? icon,
    String? privacyStatus,
  }) {
    return ReelsPrivacyModel(
      icon: icon ?? this.icon,
      privacyStatus: privacyStatus ?? this.privacyStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon?.codePoint,
      'privacyStatus': privacyStatus,
    };
  }

  factory ReelsPrivacyModel.fromMap(Map<String, dynamic> map) {
    return ReelsPrivacyModel(
      icon: map['icon'] != null
          ? IconData(map['icon'] as int, fontFamily: 'MaterialIcons')
          : null,
      privacyStatus:
          map['privacyStatus'] != null ? map['privacyStatus'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsPrivacyModel.fromJson(String source) =>
      ReelsPrivacyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReelsPrivacyModel(icon: $icon, privacyStatus: $privacyStatus)';

  @override
  bool operator ==(covariant ReelsPrivacyModel other) {
    if (identical(this, other)) return true;

    return other.icon == icon && other.privacyStatus == privacyStatus;
  }

  @override
  int get hashCode => icon.hashCode ^ privacyStatus.hashCode;
}
