// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoryModel {
  String? id;
  String? title;
  String? color;
  String? text_color;
  String? font_family;
  String? font_size;
  String? media;
  String? text_position;
  String? text_alignment;
  UserModelId? user_id;
  String? privacy_id;
  String? status;
  String? location_id;
  String? feeling_id;
  String? activity_id;
  String? sub_activity_id;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  num? v;

  StoryModel({
    this.id,
    this.title,
    this.color,
    this.text_color,
    this.font_family,
    this.font_size,
    this.media,
    this.text_position,
    this.text_alignment,
    this.user_id,
    this.privacy_id,
    this.status,
    this.location_id,
    this.feeling_id,
    this.activity_id,
    this.sub_activity_id,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  StoryModel copyWith({
    String? id,
    String? title,
    String? color,
    String? text_color,
    String? font_family,
    String? font_size,
    String? media,
    String? text_position,
    String? text_alignment,
    UserModelId? user_id,
    String? privacy_id,
    String? status,
    String? location_id,
    String? feeling_id,
    String? activity_id,
    String? sub_activity_id,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    return StoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      text_color: text_color ?? this.text_color,
      font_family: font_family ?? this.font_family,
      font_size: font_size ?? this.font_size,
      media: media ?? this.media,
      text_position: text_position ?? this.text_position,
      text_alignment: text_alignment ?? this.text_alignment,
      user_id: user_id ?? this.user_id,
      privacy_id: privacy_id ?? this.privacy_id,
      status: status ?? this.status,
      location_id: location_id ?? this.location_id,
      feeling_id: feeling_id ?? this.feeling_id,
      activity_id: activity_id ?? this.activity_id,
      sub_activity_id: sub_activity_id ?? this.sub_activity_id,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'color': color,
      'text_color': text_color,
      'font_family': font_family,
      'font_size': font_size,
      'media': media,
      'text_position': text_position,
      'text_alignment': text_alignment,
      'user_id': user_id?.toMap(),
      'privacy_id': privacy_id,
      'status': status,
      'location_id': location_id,
      'feeling_id': feeling_id,
      'activity_id': activity_id,
      'sub_activity_id': sub_activity_id,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      text_color:
          map['text_color'] != null ? map['text_color'] as String : null,
      font_family:
          map['font_family'] != null ? map['font_family'] as String : null,
      font_size: map['font_size'] != null ? map['font_size'] as String : null,
      media: map['media'] != null ? map['media'] as String : null,
      text_position:
          map['text_position'] != null ? map['text_position'] as String : null,
      text_alignment: map['text_alignment'] != null
          ? map['text_alignment'] as String
          : null,
      user_id: map['user_id'] != null
          ? UserModelId.fromMap(map['user_id'] as Map<String, dynamic>)
          : null,
      privacy_id:
          map['privacy_id'] != null ? map['privacy_id'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      location_id:
          map['location_id'] != null ? map['location_id'] as String : null,
      feeling_id:
          map['feeling_id'] != null ? map['feeling_id'] as String : null,
      activity_id:
          map['activity_id'] != null ? map['activity_id'] as String : null,
      sub_activity_id: map['sub_activity_id'] != null
          ? map['sub_activity_id'] as String
          : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryModel(id: $id, title: $title, color: $color, text_color: $text_color, font_family: $font_family, font_size: $font_size, media: $media, text_position: $text_position, text_alignment: $text_alignment, user_id: $user_id, privacy_id: $privacy_id, status: $status, location_id: $location_id, feeling_id: $feeling_id, activity_id: $activity_id, sub_activity_id: $sub_activity_id, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant StoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.color == color &&
        other.text_color == text_color &&
        other.font_family == font_family &&
        other.font_size == font_size &&
        other.media == media &&
        other.text_position == text_position &&
        other.text_alignment == text_alignment &&
        other.user_id == user_id &&
        other.privacy_id == privacy_id &&
        other.status == status &&
        other.location_id == location_id &&
        other.feeling_id == feeling_id &&
        other.activity_id == activity_id &&
        other.sub_activity_id == sub_activity_id &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        color.hashCode ^
        text_color.hashCode ^
        font_family.hashCode ^
        font_size.hashCode ^
        media.hashCode ^
        text_position.hashCode ^
        text_alignment.hashCode ^
        user_id.hashCode ^
        privacy_id.hashCode ^
        status.hashCode ^
        location_id.hashCode ^
        feeling_id.hashCode ^
        activity_id.hashCode ^
        sub_activity_id.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class UserModelId {
  String? websites;
  String? user_nickname;
  String? user_about;
  String? present_town;
  String? id;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  String? gender;
  String? religion;
  String? date_of_birth;
  String? user_bio;

  // String? language;
  String? passport;
  String? last_login;
  String? user_2fa_status;
  String? secondary_email;
  String? recovery_email;
  String? relation_status;
  String? home_town;
  String? birth_place;
  String? blood_group;
  String? reset_password_token;
  String? reset_password_token_expires;
  String? user_role;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? lock_profile;

  UserModelId({
    this.websites,
    this.user_nickname,
    this.user_about,
    this.present_town,
    this.id,
    this.first_name,
    this.last_name,
    this.username,
    this.email,
    this.phone,
    this.password,
    this.profile_pic,
    this.cover_pic,
    this.user_status,
    this.gender,
    this.religion,
    this.date_of_birth,
    this.user_bio,
    // this.language,
    this.passport,
    this.last_login,
    this.user_2fa_status,
    this.secondary_email,
    this.recovery_email,
    this.relation_status,
    this.home_town,
    this.birth_place,
    this.blood_group,
    this.reset_password_token,
    this.reset_password_token_expires,
    this.user_role,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lock_profile,
  });

  UserModelId copyWith({
    String? websites,
    String? user_nickname,
    String? user_about,
    String? present_town,
    String? id,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    String? gender,
    String? religion,
    String? date_of_birth,
    String? user_bio,
    String? language,
    String? passport,
    String? last_login,
    String? user_2fa_status,
    String? secondary_email,
    String? recovery_email,
    String? relation_status,
    String? home_town,
    String? birth_place,
    String? blood_group,
    String? reset_password_token,
    String? reset_password_token_expires,
    String? user_role,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
    String? lock_profile,
  }) {
    return UserModelId(
      websites: websites ?? this.websites,
      user_nickname: user_nickname ?? this.user_nickname,
      user_about: user_about ?? this.user_about,
      present_town: present_town ?? this.present_town,
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profile_pic: profile_pic ?? this.profile_pic,
      cover_pic: cover_pic ?? this.cover_pic,
      user_status: user_status ?? this.user_status,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      user_bio: user_bio ?? this.user_bio,
      // language: language ?? this.language,
      passport: passport ?? this.passport,
      last_login: last_login ?? this.last_login,
      user_2fa_status: user_2fa_status ?? this.user_2fa_status,
      secondary_email: secondary_email ?? this.secondary_email,
      recovery_email: recovery_email ?? this.recovery_email,
      relation_status: relation_status ?? this.relation_status,
      home_town: home_town ?? this.home_town,
      birth_place: birth_place ?? this.birth_place,
      blood_group: blood_group ?? this.blood_group,
      reset_password_token: reset_password_token ?? this.reset_password_token,
      reset_password_token_expires:
          reset_password_token_expires ?? this.reset_password_token_expires,
      user_role: user_role ?? this.user_role,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      lock_profile: lock_profile ?? this.lock_profile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'websites': websites,
      'user_nickname': user_nickname,
      'user_about': user_about,
      'present_town': present_town,
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender,
      'religion': religion,
      'date_of_birth': date_of_birth,
      'user_bio': user_bio,
      // 'language': language,
      'passport': passport,
      'last_login': last_login,
      'user_2fa_status': user_2fa_status,
      'secondary_email': secondary_email,
      'recovery_email': recovery_email,
      'relation_status': relation_status,
      'home_town': home_town,
      'birth_place': birth_place,
      'blood_group': blood_group,
      'reset_password_token': reset_password_token,
      'reset_password_token_expires': reset_password_token_expires,
      'user_role': user_role,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'lock_profile': lock_profile,
    };
  }

  factory UserModelId.fromMap(Map<String, dynamic> map) {
    return UserModelId(
      websites: map['websites'] != null ? map['websites'] as String : null,
      user_nickname:
          map['user_nickname'] != null ? map['user_nickname'] as String : null,
      user_about:
          map['user_about'] != null ? map['user_about'] as String : null,
      present_town:
          map['present_town'] != null ? map['present_town'] as String : null,
      id: map['_id'] != null ? map['_id'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      cover_pic: map['cover_pic'] != null ? map['cover_pic'] as String : null,
      user_status:
          map['user_status'] != null ? map['user_status'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      date_of_birth:
          map['date_of_birth'] != null ? map['date_of_birth'] as String : null,
      user_bio: map['user_bio'] != null ? map['user_bio'] as String : null,
      // language: map['language'] != null ? map['language'] as String : null,
      passport: map['passport'] != null ? map['passport'] as String : null,
      last_login:
          map['last_login'] != null ? map['last_login'] as String : null,
      user_2fa_status: map['user_2fa_status'] != null
          ? map['user_2fa_status'] as String
          : null,
      secondary_email: map['secondary_email'] != null
          ? map['secondary_email'] as String
          : null,
      recovery_email: map['recovery_email'] != null
          ? map['recovery_email'] as String
          : null,
      relation_status: map['relation_status'] != null
          ? map['relation_status'] as String
          : null,
      home_town: map['home_town'] != null ? map['home_town'] as String : null,
      birth_place:
          map['birth_place'] != null ? map['birth_place'] as String : null,
      blood_group:
          map['blood_group'] != null ? map['blood_group'] as String : null,
      reset_password_token: map['reset_password_token'] != null
          ? map['reset_password_token'] as String
          : null,
      reset_password_token_expires: map['reset_password_token_expires'] != null
          ? map['reset_password_token_expires'] as String
          : null,
      user_role: map['user_role'] != null ? map['user_role'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
      lock_profile:
          map['lock_profile'] != null ? map['lock_profile'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelId.fromJson(String source) =>
      UserModelId.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModelId(websites: $websites, user_nickname: $user_nickname, user_about: $user_about, present_town: $present_town, id: $id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio,'
        // ' language: $language, '
        'passport: $passport, last_login: $last_login, user_2fa_status: $user_2fa_status, secondary_email: $secondary_email, recovery_email: $recovery_email, relation_status: $relation_status, home_town: $home_town, birth_place: $birth_place, blood_group: $blood_group, reset_password_token: $reset_password_token, reset_password_token_expires: $reset_password_token_expires, user_role: $user_role, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, lock_profile: $lock_profile)';
  }

  @override
  bool operator ==(covariant UserModelId other) {
    if (identical(this, other)) return true;

    return other.websites == websites &&
        other.user_nickname == user_nickname &&
        other.user_about == user_about &&
        other.present_town == present_town &&
        other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.user_status == user_status &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        other.user_bio == user_bio &&
        // other.language == language &&
        other.passport == passport &&
        other.last_login == last_login &&
        other.user_2fa_status == user_2fa_status &&
        other.secondary_email == secondary_email &&
        other.recovery_email == recovery_email &&
        other.relation_status == relation_status &&
        other.home_town == home_town &&
        other.birth_place == birth_place &&
        other.blood_group == blood_group &&
        other.reset_password_token == reset_password_token &&
        other.reset_password_token_expires == reset_password_token_expires &&
        other.user_role == user_role &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.lock_profile == lock_profile;
  }

  @override
  int get hashCode {
    return websites.hashCode ^
        user_nickname.hashCode ^
        user_about.hashCode ^
        present_town.hashCode ^
        id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        profile_pic.hashCode ^
        cover_pic.hashCode ^
        user_status.hashCode ^
        gender.hashCode ^
        religion.hashCode ^
        date_of_birth.hashCode ^
        user_bio.hashCode ^
        // language.hashCode ^
        passport.hashCode ^
        last_login.hashCode ^
        user_2fa_status.hashCode ^
        secondary_email.hashCode ^
        recovery_email.hashCode ^
        relation_status.hashCode ^
        home_town.hashCode ^
        birth_place.hashCode ^
        blood_group.hashCode ^
        reset_password_token.hashCode ^
        reset_password_token_expires.hashCode ^
        user_role.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        lock_profile.hashCode;
  }
}
