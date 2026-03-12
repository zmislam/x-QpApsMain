// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PrivacyModel {
  String? dob;
  String? home_town;
  String? present_town;
  String? relationship;
  String? user_bio;
  String? gender;
  String? about;
  String? nickname;
  PrivacyModel({
    this.gender,
    this.about,
    this.nickname,
    this.dob,
    this.home_town,
    this.present_town,
    this.relationship,
    this.user_bio,
  });

  PrivacyModel copyWith({
    String? gender,
    String? about,
    String? nickname,
    String? dob,
    String? home_town,
    String? present_town,
    String? relationship,
    String? user_bio,
  }) {
    return PrivacyModel(
      gender: gender ?? this.gender,
      about: about ?? this.about,
      nickname: nickname ?? this.nickname,
      dob: dob ?? this.dob,
      home_town: home_town ?? this.home_town,
      present_town: present_town ?? this.present_town,
      relationship: relationship ?? this.relationship,
      user_bio: user_bio ?? this.user_bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': gender,
      'about': about,
      'nickname': nickname,
      'dob': dob,
      'home_town': home_town,
      'present_town': present_town,
     'relationship': relationship,
     'user_bio': user_bio,
    };
  }

  factory PrivacyModel.fromMap(Map<String, dynamic> map) {
    return PrivacyModel(
      gender: map['gender'] != null ? map['gender'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      nickname: map['nickname'] != null ? map['nickname'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      home_town: map['home_town'] != null ? map['home_town'] as String : null,
      present_town: map['present_town'] != null ? map['present_town'] as String : null,
      relationship: map['relationship'] != null ? map['relationship'] as String : null,
      user_bio: map['user_bio'] != null ? map['user_bio'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrivacyModel.fromJson(String source) =>
      PrivacyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PrivacyModel(gender: $gender, about: $about, nickname: $nickname, dob: $dob, home_town: $home_town, present_town: $present_town, relationship: $relationship, user_bio: $user_bio)';

  @override
  bool operator ==(covariant PrivacyModel other) {
    if (identical(this, other)) return true;

    return other.gender == gender &&
        other.about == about &&
        other.nickname == nickname &&
        other.dob == dob &&
        other.home_town == home_town &&
        other.present_town == present_town &&
        other.relationship == relationship &&
        other.user_bio == user_bio
        
        ;
  }

  @override
  int get hashCode => gender.hashCode ^ 
  about.hashCode ^ 
  nickname.hashCode ^
  dob.hashCode ^
  home_town.hashCode ^
  present_town.hashCode ^
  relationship.hashCode ^
  user_bio.hashCode ;

    
}
