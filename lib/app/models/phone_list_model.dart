import 'dart:convert';

class PhoneListModel {
  String? id;
  String? user_id;
  String? privacy;
  String? phone;
  bool? is_phone_verified;
  String? token;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  PhoneListModel({
    this.id,
    this.user_id,
    this.privacy,
    this.phone,
    this.is_phone_verified,
    this.token,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PhoneListModel copyWith({
    String? id,
    String? user_id,
    String? privacy,
    String? phone,
    bool? is_phone_verified,
    String? token,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return PhoneListModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      privacy: privacy ?? this.privacy,
      phone: phone ?? this.phone,
      is_phone_verified: is_phone_verified ?? this.is_phone_verified,
      token: token ?? this.token,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'privacy': privacy,
      'phone': phone,
      'is_phone_verified': is_phone_verified,
      'token': token,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory PhoneListModel.fromMap(Map<String, dynamic> map) {
    return PhoneListModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      is_phone_verified: map['is_phone_verified'] != null
          ? map['is_phone_verified'] as bool
          : null,
      token: map['token'] != null ? map['token'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['_v'] != null ? map['_v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhoneListModel.fromJson(String source) =>
      PhoneListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhoneListModel(id: $id, user_id: $user_id, privacy: $privacy, phone: $phone, is_phone_verified: $is_phone_verified, token: $token, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant PhoneListModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.privacy == privacy &&
        other.phone == phone &&
        other.is_phone_verified == is_phone_verified &&
        other.token == token &&
        other.status == status &&
        other.ip_address == ip_address &&
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
        privacy.hashCode ^
        phone.hashCode ^
        is_phone_verified.hashCode ^
        token.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}