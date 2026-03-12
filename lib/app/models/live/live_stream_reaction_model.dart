// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LiveStreamReactionModel {
  String? id;
  String? reaction_type;
  StreamReactionUserId? user_id;
  String? post_id;
  String? reels_id;
  String? createdAt;
  String? updatedAt;
  int? count;
  LiveStreamReactionModel({
    this.id,
    this.reaction_type,
    this.user_id,
    this.reels_id,
    this.post_id,
    this.createdAt,
    this.updatedAt,
    this.count,
  });

  LiveStreamReactionModel copyWith({
    String? id,
    String? reaction_type,
    StreamReactionUserId? user_id,
    String? post_id,
    String? reels_id,
    String? createdAt,
    String? updatedAt,
    int? count,
  }) {
    return LiveStreamReactionModel(
      id: id ?? this.id,
      reaction_type: reaction_type ?? this.reaction_type,
      user_id: user_id ?? this.user_id,
      post_id: post_id ?? this.post_id,
      reels_id: reels_id ?? this.reels_id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'reaction_type': reaction_type,
      'user_id': user_id?.toMap(),
      'post_id': post_id,
      'reels_id': reels_id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'count': count,
    };
  }

  factory LiveStreamReactionModel.fromMap(Map<String, dynamic> map) {
    return LiveStreamReactionModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      reaction_type:
          map['reaction_type'] != null ? map['reaction_type'] as String : null,
      user_id: map['user_id'] != null
          ? StreamReactionUserId.fromMap(map['user_id'] as Map<String, dynamic>)
          : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      count: map['count'] != null ? map['count'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LiveStreamReactionModel.fromJson(String source) =>
      LiveStreamReactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LiveStreamReactionModel(_id: $id, reaction_type: $reaction_type, user_id: $user_id, post_id: $post_id, createdAt: $createdAt, updatedAt: $updatedAt, count: $count)';
  }

  @override
  bool operator ==(covariant LiveStreamReactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.reaction_type == reaction_type &&
        other.user_id == user_id &&
        other.post_id == post_id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.count == count;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        reaction_type.hashCode ^
        user_id.hashCode ^
        post_id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        count.hashCode;
  }
}

class StreamReactionUserId {
  String? page_id;
  String? id;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? gender;
  String? religion;
  String? date_of_birth;
  String? user_bio;
  String? last_login;
  String? relation_status;
  String? home_town;
  String? birth_place;
  StreamReactionUserId({
    this.page_id,
    this.id,
    this.first_name,
    this.last_name,
    this.username,
    this.email,
    this.phone,
    this.password,
    this.profile_pic,
    this.cover_pic,
    this.gender,
    this.religion,
    this.date_of_birth,
    this.user_bio,
    this.last_login,
    this.relation_status,
    this.home_town,
    this.birth_place,
  });

  StreamReactionUserId copyWith({
    String? page_id,
    String? id,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? gender,
    String? religion,
    String? date_of_birth,
    String? user_bio,
    String? last_login,
    String? relation_status,
    String? home_town,
    String? birth_place,
  }) {
    return StreamReactionUserId(
      page_id: page_id ?? this.page_id,
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profile_pic: profile_pic ?? this.profile_pic,
      cover_pic: cover_pic ?? this.cover_pic,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      user_bio: user_bio ?? this.user_bio,
      last_login: last_login ?? this.last_login,
      relation_status: relation_status ?? this.relation_status,
      home_town: home_town ?? this.home_town,
      birth_place: birth_place ?? this.birth_place,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page_id': page_id,
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'gender': gender,
      'religion': religion,
      'date_of_birth': date_of_birth,
      'user_bio': user_bio,
      'last_login': last_login,
      'relation_status': relation_status,
      'home_town': home_town,
      'birth_place': birth_place,
    };
  }

  factory StreamReactionUserId.fromMap(Map<String, dynamic> map) {
    return StreamReactionUserId(
      page_id: map['page_id'] != null ? map['page_id'] as String : null,
      id: map['_id'] != null ? map['_id'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      cover_pic: map['cover_pic'] != null ? map['cover_pic'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      date_of_birth:
          map['date_of_birth'] != null ? map['date_of_birth'] as String : null,
      user_bio: map['user_bio'] != null ? map['user_bio'] as String : null,
      last_login:
          map['last_login'] != null ? map['last_login'] as String : null,
      relation_status: map['relation_status'] != null
          ? map['relation_status'] as String
          : null,
      home_town: map['home_town'] != null ? map['home_town'] as String : null,
      birth_place:
          map['birth_place'] != null ? map['birth_place'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamReactionUserId.fromJson(String source) =>
      StreamReactionUserId.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StreamReactionUserId(page_id: $page_id, _id: $id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, profile_pic: $profile_pic, cover_pic: $cover_pic, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio, last_login: $last_login, relation_status: $relation_status, home_town: $home_town, birth_place: $birth_place)';
  }

  @override
  bool operator ==(covariant StreamReactionUserId other) {
    if (identical(this, other)) return true;

    return other.page_id == page_id &&
        other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        other.user_bio == user_bio &&
        other.last_login == last_login &&
        other.relation_status == relation_status &&
        other.home_town == home_town &&
        other.birth_place == birth_place;
  }

  @override
  int get hashCode {
    return page_id.hashCode ^
        id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        profile_pic.hashCode ^
        cover_pic.hashCode ^
        gender.hashCode ^
        religion.hashCode ^
        date_of_birth.hashCode ^
        user_bio.hashCode ^
        last_login.hashCode ^
        relation_status.hashCode ^
        home_town.hashCode ^
        birth_place.hashCode;
  }
}
