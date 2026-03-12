import 'dart:convert';

class EmailListModel {
  String? id;
  String? user_id;
  String? email_type;
  String? privacy;
  String? email;
  bool? is_mail_verified;
  String? token;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  EmailListModel({
    this.id,
    this.user_id,
    this.email_type,
    this.privacy,
    this.email,
    this.is_mail_verified,
    this.token,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  EmailListModel copyWith({
    String? id,
    String? user_id,
    String? email_type,
    String? privacy,
    String? email,
    bool? is_mail_verified,
    String? token,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return EmailListModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      email_type: email_type ?? this.email_type,
      privacy: privacy ?? this.privacy,
      email: email ?? this.email,
      is_mail_verified: is_mail_verified ?? this.is_mail_verified,
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
      'email_type': email_type,
      'privacy': privacy,
      'email': email,
      'is_mail_verified': is_mail_verified,
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

  factory EmailListModel.fromMap(Map<String, dynamic> map) {
    return EmailListModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      email_type:
          map['email_type'] != null ? map['email_type'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      is_mail_verified: map['is_mail_verified'] != null
          ? map['is_mail_verified'] as bool
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

  factory EmailListModel.fromJson(String source) =>
      EmailListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmailListModel(id: $id, user_id: $user_id, email_type:$email_type, privacy: $privacy, email: $email, is_mail_verified: $is_mail_verified, token: $token, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant EmailListModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.email_type == email_type &&
        other.privacy == privacy &&
        other.email == email &&
        other.is_mail_verified == is_mail_verified &&
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
        email_type.hashCode ^
        privacy.hashCode ^
        email.hashCode ^
        is_mail_verified.hashCode ^
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
