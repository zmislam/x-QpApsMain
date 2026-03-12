// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReligionModel {
  String? id;
  String? religion_name;
  String? data_status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  num? v;
  ReligionModel({
    this.id,
    this.religion_name,
    this.data_status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ReligionModel copyWith({
    String? id,
    String? religion_name,
    String? data_status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    return ReligionModel(
      id: id ?? this.id,
      religion_name: religion_name ?? this.religion_name,
      data_status: data_status ?? this.data_status,
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
      '_id': id,
      'religion_name': religion_name,
      'data_status': data_status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory ReligionModel.fromMap(Map<String, dynamic> map) {
    return ReligionModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      religion_name:
          map['religion_name'] != null ? map['religion_name'] as String : null,
      data_status:
          map['data_status'] != null ? map['data_status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReligionModel.fromJson(String source) =>
      ReligionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReligionModel(id: $id, religion_name: $religion_name, data_status: $data_status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant ReligionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.religion_name == religion_name &&
        other.data_status == data_status &&
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
        religion_name.hashCode ^
        data_status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
