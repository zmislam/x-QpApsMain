// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CampainModel {
  String? id;
  String? user_id;
  String? post_id;
  String? deleted_at;
  String? campaign_name;
  String? campaign_category;
  String? page_name;
  String? page_id;
  String? start_date;
  String? end_date;
  String? call_to_action;
  String? website_url;
  num? total_budget;
  num? daily_budget;
  String? gender;
  String? headline;
  String? description;
  String? phone_number;
  List<String>? campaign_cover_pic;
  String? ads_placement;
  String? destination;
  String? age_group;
  int? from_age;
  int? to_age;
  List<String>? locations;
  List<String>? keywords;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? created_by;
  String? updated_by;
  int? v;
  CampainModel({
    this.id,
    this.user_id,
    this.post_id,
    this.deleted_at,
    this.campaign_name,
    this.campaign_category,
    this.page_name,
    this.page_id,
    this.start_date,
    this.end_date,
    this.call_to_action,
    this.website_url,
    this.total_budget,
    this.daily_budget,
    this.gender,
    this.headline,
    this.description,
    this.phone_number,
    this.campaign_cover_pic,
    this.ads_placement,
    this.destination,
    this.age_group,
    this.from_age,
    this.to_age,
    this.locations,
    this.keywords,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.created_by,
    this.updated_by,
    this.v,
  });

  CampainModel copyWith({
    String? id,
    String? user_id,
    String? post_id,
    String? deleted_at,
    String? campaign_name,
    String? campaign_category,
    String? page_name,
    String? page_id,
    String? start_date,
    String? end_date,
    String? call_to_action,
    String? website_url,
    num? total_budget,
    num? daily_budget,
    String? gender,
    String? headline,
    String? description,
    String? phone_number,
    List<String>? campaign_cover_pic,
    String? ads_placement,
    String? destination,
    String? age_group,
    int? from_age,
    int? to_age,
    List<String>? locations,
    List<String>? keywords,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? created_by,
    String? updated_by,
    int? v,
  }) {
    return CampainModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      post_id: post_id ?? this.post_id,
      deleted_at: deleted_at ?? this.deleted_at,
      campaign_name: campaign_name ?? this.campaign_name,
      campaign_category: campaign_category ?? this.campaign_category,
      page_name: page_name ?? this.page_name,
      page_id: page_id ?? this.page_id,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      call_to_action: call_to_action ?? this.call_to_action,
      website_url: website_url ?? this.website_url,
      total_budget: total_budget ?? this.total_budget,
      daily_budget: daily_budget ?? this.daily_budget,
      gender: gender ?? this.gender,
      headline: headline ?? this.headline,
      description: description ?? this.description,
      phone_number: phone_number ?? this.phone_number,
      campaign_cover_pic: campaign_cover_pic ?? this.campaign_cover_pic,
      ads_placement: ads_placement ?? this.ads_placement,
      destination: destination ?? this.destination,
      age_group: age_group ?? this.age_group,
      from_age: from_age ?? this.from_age,
      to_age: to_age ?? this.to_age,
      locations: locations ?? this.locations,
      keywords: keywords ?? this.keywords,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'user_id': user_id,
      'post_id': post_id,
      'deleted_at': deleted_at,
      'campaign_name': campaign_name,
      'campaign_category': campaign_category,
      'page_name': page_name,
      'page_id': page_id,
      'start_date': start_date,
      'end_date': end_date,
      'call_to_action': call_to_action,
      'website_url': website_url,
      'total_budget': total_budget,
      'daily_budget': daily_budget,
      'gender': gender,
      'headline': headline,
      'description': description,
      'phone_number': phone_number,
      'campaign_cover_pic': campaign_cover_pic,
      'ads_placement': ads_placement,
      'destination': destination,
      'age_group': age_group,
      'from_age': from_age,
      'to_age': to_age,
      'locations': locations,
      'keywords': keywords,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'created_by': created_by,
      'updated_by': updated_by,
      '__v': v,
    };
  }

  factory CampainModel.fromMap(Map<String, dynamic> map) {
    return CampainModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      deleted_at:
          map['deleted_at'] != null ? map['deleted_at'] as String : null,
      campaign_name:
          map['campaign_name'] != null ? map['campaign_name'] as String : null,
      campaign_category: map['campaign_category'] != null
          ? map['campaign_category'] as String
          : null,
      page_name: map['page_name'] != null ? map['page_name'] as String : null,
      page_id: map['page_id'] != null ? map['page_id'] as String : null,
      start_date:
          map['start_date'] != null ? map['start_date'] as String : null,
      end_date: map['end_date'] != null ? map['end_date'] as String : null,
      call_to_action: map['call_to_action'] != null
          ? map['call_to_action'] as String
          : null,
      website_url:
          map['website_url'] != null ? map['website_url'] as String : null,
      total_budget:
          map['total_budget'] != null ? map['total_budget'] as num : null,
      daily_budget:
          map['daily_budget'] != null ? map['daily_budget'] as num : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      headline: map['headline'] != null ? map['headline'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
      campaign_cover_pic: map['campaign_cover_pic'] != null
          ? (map['campaign_cover_pic'] as List)
              .map((e) => e.toString())
              .toList()
          : null,
      ads_placement:
          map['ads_placement'] != null ? map['ads_placement'] as String : null,
      destination:
          map['destination'] != null ? map['destination'] as String : null,
      age_group: map['age_group'] != null ? map['age_group'] as String : null,
      from_age: map['from_age'] != null ? map['from_age'] as int : null,
      to_age: map['to_age'] != null ? map['to_age'] as int : null,
      locations: map['locations'] != null
          ? (map['locations'] as List).map((e) => e.toString()).toList()
          : null,
      keywords: map['keywords'] != null
          ? (map['keywords'] as List).map((e) => e.toString()).toList()
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CampainModel.fromJson(String source) =>
      CampainModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CampainModel(id: $id, user_id: $user_id, post_id: $post_id, deleted_at: $deleted_at, campaign_name: $campaign_name, campaign_category: $campaign_category, page_name: $page_name, page_id: $page_id, start_date: $start_date, end_date: $end_date, call_to_action: $call_to_action, website_url: $website_url, total_budget: $total_budget, daily_budget: $daily_budget, gender: $gender, headline: $headline, description: $description, phone_number: $phone_number, campaign_cover_pic: $campaign_cover_pic, ads_placement: $ads_placement, destination: $destination, age_group: $age_group, from_age: $from_age, to_age: $to_age, locations: $locations, keywords: $keywords, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, created_by: $created_by, updated_by: $updated_by, v: $v)';
  }

  @override
  bool operator ==(covariant CampainModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.post_id == post_id &&
        other.deleted_at == deleted_at &&
        other.campaign_name == campaign_name &&
        other.campaign_category == campaign_category &&
        other.page_name == page_name &&
        other.page_id == page_id &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.call_to_action == call_to_action &&
        other.website_url == website_url &&
        other.total_budget == total_budget &&
        other.daily_budget == daily_budget &&
        other.gender == gender &&
        other.headline == headline &&
        other.description == description &&
        other.phone_number == phone_number &&
        listEquals(other.campaign_cover_pic, campaign_cover_pic) &&
        other.ads_placement == ads_placement &&
        other.destination == destination &&
        other.age_group == age_group &&
        other.from_age == from_age &&
        other.to_age == to_age &&
        listEquals(other.locations, locations) &&
        listEquals(other.keywords, keywords) &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        post_id.hashCode ^
        deleted_at.hashCode ^
        campaign_name.hashCode ^
        campaign_category.hashCode ^
        page_name.hashCode ^
        page_id.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        call_to_action.hashCode ^
        website_url.hashCode ^
        total_budget.hashCode ^
        daily_budget.hashCode ^
        gender.hashCode ^
        headline.hashCode ^
        description.hashCode ^
        phone_number.hashCode ^
        campaign_cover_pic.hashCode ^
        ads_placement.hashCode ^
        destination.hashCode ^
        age_group.hashCode ^
        from_age.hashCode ^
        to_age.hashCode ^
        locations.hashCode ^
        keywords.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        v.hashCode;
  }
}
