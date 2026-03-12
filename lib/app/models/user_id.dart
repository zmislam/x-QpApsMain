import 'dart:convert';

class UserIdModel {
  String? websites;
  String? user_nickname;
  String? user_about;
  String? present_town;
  String? id;
  String? page_id;
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
  List<String>? language;
  String? passport;
  String? last_login;
  String? user_2fa_status;
  String? secondary_email;
  String? recovery_email;
  String? relation_status;
  bool? isProfileVerified;
  bool? isFollowing;
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

  UserIdModel({
    this.websites,
    this.user_nickname,
    this.user_about,
    this.present_town,
    this.id,
    this.page_id,
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
    this.language,
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
    this.isFollowing,
    this.isProfileVerified,
  });

  UserIdModel copyWith(
      {String? websites,
      String? user_nickname,
      String? user_about,
      String? present_town,
      String? id,
      String? page_id,
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
      List<String>? language,
      String? passport,
      String? last_login,
      String? user_2fa_status,
      bool? isProfileVerified,
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
      bool? isFollowing}) {
    return UserIdModel(
        websites: websites ?? this.websites,
        user_nickname: user_nickname ?? this.user_nickname,
        user_about: user_about ?? this.user_about,
        present_town: present_town ?? this.present_town,
        id: id ?? this.id,
        page_id: page_id ?? this.page_id,
        first_name: first_name ?? this.first_name,
        last_name: last_name ?? this.last_name,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        isProfileVerified: isProfileVerified ?? this.isProfileVerified,
        password: password ?? this.password,
        profile_pic: profile_pic ?? this.profile_pic,
        cover_pic: cover_pic ?? this.cover_pic,
        user_status: user_status ?? this.user_status,
        gender: gender ?? this.gender,
        religion: religion ?? this.religion,
        date_of_birth: date_of_birth ?? this.date_of_birth,
        user_bio: user_bio ?? this.user_bio,
        language: language ?? this.language,
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
        isFollowing: isFollowing ?? this.isFollowing);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'websites': websites,
      'user_nickname': user_nickname,
      'user_about': user_about,
      'present_town': present_town,
      '_id': id,
      'page_id': page_id,
      'first_name': first_name,
      'last_name': last_name ?? '',
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
      'isProfileVerified': isProfileVerified,
      'user_bio': user_bio,
      'language': language,
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
      'isFollowing': isFollowing
    };
  }

  factory UserIdModel.fromMap(Map<String, dynamic> map) {
    return UserIdModel(
      // websites: map['websites'] != null ? map['websites'] as String : null,
      user_nickname:
          map['user_nickname'] != null ? map['user_nickname'] as String : null,
      user_about:
          map['user_about'] != null ? map['user_about'] as String : null,
      present_town:
          map['present_town'] != null ? map['present_town'] as String : null,
      id: map['_id'] != null ? map['_id'] as String : null,
      page_id: map['page_id'] != null ? map['page_id'] as String : null,
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
      language: map['language'] != null
          ? (map['language'] as List).map((e) => e.toString()).toList()
          : null,
      passport: map['passport'] != null ? map['passport'] as String : null,
      // last_login:
      //     map['last_login'] != null ? map['last_login'] as String : null,
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
      isFollowing:
          map['isFollowing'] != null ? map['isFollowing'] as bool : null,
      isProfileVerified: map['isProfileVerified'] != null
          ? map['isProfileVerified'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserIdModel.fromJson(String source) =>
      UserIdModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserIdModel(websites: $websites, user_nickname: $user_nickname, user_about: $user_about, present_town: $present_town, id: $id,page_id:$page_id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, isProfileVerified: $isProfileVerified, profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio, language: $language, passport: $passport, last_login: $last_login, user_2fa_status: $user_2fa_status, secondary_email: $secondary_email, recovery_email: $recovery_email, relation_status: $relation_status, home_town: $home_town, birth_place: $birth_place, blood_group: $blood_group, reset_password_token: $reset_password_token, reset_password_token_expires: $reset_password_token_expires, user_role: $user_role, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, lock_profile: $lock_profile)';
  }

  @override
  bool operator ==(covariant UserIdModel other) {
    if (identical(this, other)) return true;

    return other.websites == websites &&
        other.user_nickname == user_nickname &&
        other.user_about == user_about &&
        other.present_town == present_town &&
        other.id == id &&
        other.page_id == page_id &&
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
        other.language == language &&
        other.passport == passport &&
        other.isProfileVerified == isProfileVerified &&
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
        isProfileVerified.hashCode ^
        id.hashCode ^
        page_id.hashCode ^
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
        language.hashCode ^
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
