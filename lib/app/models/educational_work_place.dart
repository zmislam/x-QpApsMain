// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EducationalWorkPlace {
  String? id;
  String? user_id;
  String? institute_type_id;
  String? institute_id;
  String? institute_name;
  String? startDate;
  String? endDate;
  String? designation;
  String? department_id;
  String? designation_id;
  bool? edu_or_ins;
  String? description;
  String? privacy;
  int? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  EducationalWorkPlace({
    this.id,
    this.user_id,
    this.institute_type_id,
    this.institute_id,
    this.startDate,
    this.endDate,
    this.designation,
    this.department_id,
    this.designation_id,
    this.edu_or_ins,
    this.description,
    this.privacy,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.institute_name,
    this.v,
  });

  EducationalWorkPlace copyWith({
    String? id,
    String? user_id,
    String? institute_type_id,
    String? institute_id,
    String? start_at,
    String? end_at,
    String? department_id,
    String? designation,
    String? designation_id,
    bool? edu_or_ins,
    String? description,
    String? privacy,
    int? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    String? institute_name,
    int? v,
  }) {
    return EducationalWorkPlace(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      institute_type_id: institute_type_id ?? this.institute_type_id,
      institute_id: institute_id ?? this.institute_id,
      startDate: startDate ?? startDate,
      endDate: endDate ?? endDate,
      department_id: department_id ?? this.department_id,
      designation: designation ?? this.designation,
      designation_id: designation_id ?? this.designation_id,
      edu_or_ins: edu_or_ins ?? this.edu_or_ins,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      institute_name: institute_name ?? this.institute_name,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'user_id': user_id,
      'institute_type_id': institute_type_id,
      'institute_id': institute_id,
      'startDate': startDate,
      'endDate': endDate,
      'department_id': department_id,
      'designation': designation,
      'designation_id': designation_id,
      'edu_or_ins': edu_or_ins,
      'description': description,
      'privacy': privacy,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'institute_name': institute_name,
      '__v': v,
    };
  }

  factory EducationalWorkPlace.fromMap(Map<String, dynamic> map) {
    return EducationalWorkPlace(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      institute_type_id: map['institute_type_id'] != null
          ? map['institute_type_id'] as String
          : null,
      institute_id:
          map['institute_id'] != null ? map['institute_id'] as String : null,
      startDate: map['startDate'] != null ? map['startDate'] as String : null,
      endDate: map['endDate'] != null ? map['endDate'] as String : null,
      department_id:
          map['department_id'] != null ? map['department_id'] as String : null,
      designation_id: map['designation_id'] != null
          ? map['designation_id'] as String
          : null,
      edu_or_ins: map['edu_or_ins'] != null ? map['edu_or_ins'] as bool : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      institute_name: map['institute_name'] != null
          ? map['institute_name'] as String
          : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EducationalWorkPlace.fromJson(String source) =>
      EducationalWorkPlace.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EducationalWorkPlace(id: $id, user_id: $user_id, institute_type_id: $institute_type_id, institute_id: $institute_id, startDate: $startDate, endDate: $endDate, department_id: $department_id, designation_id: $designation_id, edu_or_ins: $edu_or_ins, description: $description, privacy: $privacy, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant EducationalWorkPlace other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.institute_type_id == institute_type_id &&
        other.institute_id == institute_id &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.department_id == department_id &&
        other.designation_id == designation_id &&
        other.edu_or_ins == edu_or_ins &&
        other.description == description &&
        other.privacy == privacy &&
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
        institute_type_id.hashCode ^
        institute_id.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        department_id.hashCode ^
        designation_id.hashCode ^
        edu_or_ins.hashCode ^
        description.hashCode ^
        privacy.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
