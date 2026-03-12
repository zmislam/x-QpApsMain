import 'dart:convert';

class SearchPeopleModel {
  String? id;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  String? gender;
  String? religion;
  String? date_of_birth;
  String? user_bio;
  String? passport;
  String? last_login;
  String? user_2fa_status;
  String? secondary_email;
  String? recovery_email;
  String? relation_status;
  String? home_town;
  String? birth_place;
  String? blood_group;
  String? websites;
  String? user_nickname;
  String? user_about;
  String? present_town;
  String? user_role;
  String? lock_profile;
  String? turn_on_earning_dashboard;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? full_name;
  bool? isFriendRequestSended;
  SearchPeopleModel({
    this.id,
    this.first_name,
    this.last_name,
    this.username,
    this.email,
    this.phone,
    this.profile_pic,
    this.cover_pic,
    this.user_status,
    this.gender,
    this.religion,
    this.date_of_birth,
    this.user_bio,
    this.passport,
    this.last_login,
    this.user_2fa_status,
    this.secondary_email,
    this.recovery_email,
    this.relation_status,
    this.home_town,
    this.birth_place,
    this.blood_group,
    this.websites,
    this.user_nickname,
    this.user_about,
    this.present_town,
    this.user_role,
    this.lock_profile,
    this.turn_on_earning_dashboard,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.full_name,
    this.isFriendRequestSended,
  });

  SearchPeopleModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    String? gender,
    String? religion,
    String? date_of_birth,
    String? user_bio,
    String? passport,
    String? last_login,
    String? user_2fa_status,
    String? secondary_email,
    String? recovery_email,
    String? relation_status,
    String? home_town,
    String? birth_place,
    String? blood_group,
    String? websites,
    String? user_nickname,
    String? user_about,
    String? present_town,
    String? user_role,
    String? lock_profile,
    String? turn_on_earning_dashboard,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
    String? full_name,
    bool? isFriendRequestSended,
  }) {
    return SearchPeopleModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profile_pic: profile_pic ?? this.profile_pic,
      cover_pic: cover_pic ?? this.cover_pic,
      user_status: user_status ?? this.user_status,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      user_bio: user_bio ?? this.user_bio,
      passport: passport ?? this.passport,
      last_login: last_login ?? this.last_login,
      user_2fa_status: user_2fa_status ?? this.user_2fa_status,
      secondary_email: secondary_email ?? this.secondary_email,
      recovery_email: recovery_email ?? this.recovery_email,
      relation_status: relation_status ?? this.relation_status,
      home_town: home_town ?? this.home_town,
      birth_place: birth_place ?? this.birth_place,
      blood_group: blood_group ?? this.blood_group,
      websites: websites ?? this.websites,
      user_nickname: user_nickname ?? this.user_nickname,
      user_about: user_about ?? this.user_about,
      present_town: present_town ?? this.present_town,
      user_role: user_role ?? this.user_role,
      lock_profile: lock_profile ?? this.lock_profile,
      turn_on_earning_dashboard:
          turn_on_earning_dashboard ?? this.turn_on_earning_dashboard,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      full_name: full_name ?? this.full_name,
      isFriendRequestSended:
          isFriendRequestSended ?? this.isFriendRequestSended,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender,
      'religion': religion,
      'date_of_birth': date_of_birth,
      'user_bio': user_bio,
      'passport': passport,
      'last_login': last_login,
      'user_2fa_status': user_2fa_status,
      'secondary_email': secondary_email,
      'recovery_email': recovery_email,
      'relation_status': relation_status,
      'home_town': home_town,
      'birth_place': birth_place,
      'blood_group': blood_group,
      'websites': websites,
      'user_nickname': user_nickname,
      'user_about': user_about,
      'present_town': present_town,
      'user_role': user_role,
      'lock_profile': lock_profile,
      'turn_on_earning_dashboard': turn_on_earning_dashboard,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'full_name': full_name,
      'isFriendRequestSended': isFriendRequestSended,
    };
  }

  factory SearchPeopleModel.fromMap(Map<String, dynamic> map) {
    return SearchPeopleModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
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
      websites: map['websites'] != null ? map['websites'] as String : null,
      user_nickname:
          map['user_nickname'] != null ? map['user_nickname'] as String : null,
      user_about:
          map['user_about'] != null ? map['user_about'] as String : null,
      present_town:
          map['present_town'] != null ? map['present_town'] as String : null,
      user_role: map['user_role'] != null ? map['user_role'] as String : null,
      lock_profile:
          map['lock_profile'] != null ? map['lock_profile'] as String : null,
      // turn_on_earning_dashboard: map['turn_on_earning_dashboard'] != null
      //     ? map['turn_on_earning_dashboard'] as String
      // : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
      full_name: map['full_name'] != null ? map['full_name'] as String : null,
      isFriendRequestSended: map['isFriendRequestSended'] != null
          ? map['isFriendRequestSended'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchPeopleModel.fromJson(String source) =>
      SearchPeopleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchPeopleModel(id: $id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio, passport: $passport, last_login: $last_login, user_2fa_status: $user_2fa_status, secondary_email: $secondary_email, recovery_email: $recovery_email, relation_status: $relation_status, home_town: $home_town, birth_place: $birth_place, blood_group: $blood_group, websites: $websites, user_nickname: $user_nickname, user_about: $user_about, present_town: $present_town, user_role: $user_role, lock_profile: $lock_profile, turn_on_earning_dashboard: $turn_on_earning_dashboard, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, full_name: $full_name, isFriendRequestSended: $isFriendRequestSended)';
  }

  @override
  bool operator ==(covariant SearchPeopleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.user_status == user_status &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        other.user_bio == user_bio &&
        other.passport == passport &&
        other.last_login == last_login &&
        other.user_2fa_status == user_2fa_status &&
        other.secondary_email == secondary_email &&
        other.recovery_email == recovery_email &&
        other.relation_status == relation_status &&
        other.home_town == home_town &&
        other.birth_place == birth_place &&
        other.blood_group == blood_group &&
        other.websites == websites &&
        other.user_nickname == user_nickname &&
        other.user_about == user_about &&
        other.present_town == present_town &&
        other.user_role == user_role &&
        other.lock_profile == lock_profile &&
        other.turn_on_earning_dashboard == turn_on_earning_dashboard &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.full_name == full_name &&
        other.isFriendRequestSended == isFriendRequestSended;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        profile_pic.hashCode ^
        cover_pic.hashCode ^
        user_status.hashCode ^
        gender.hashCode ^
        religion.hashCode ^
        date_of_birth.hashCode ^
        user_bio.hashCode ^
        passport.hashCode ^
        last_login.hashCode ^
        user_2fa_status.hashCode ^
        secondary_email.hashCode ^
        recovery_email.hashCode ^
        relation_status.hashCode ^
        home_town.hashCode ^
        birth_place.hashCode ^
        blood_group.hashCode ^
        websites.hashCode ^
        user_nickname.hashCode ^
        user_about.hashCode ^
        present_town.hashCode ^
        user_role.hashCode ^
        lock_profile.hashCode ^
        turn_on_earning_dashboard.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        full_name.hashCode ^
        isFriendRequestSended.hashCode;
  }
}
