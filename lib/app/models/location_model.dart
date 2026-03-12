// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  int? status;
  List<AllLocation>? allLocation;

  LocationModel({
    required this.status,
    required this.allLocation,
  });

  LocationModel copyWith({
    int? status,
    List<AllLocation>? allLocation,
  }) =>
      LocationModel(
        status: status ?? this.status,
        allLocation: allLocation ?? this.allLocation,
      );

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        status: json['status'],
        allLocation: List<AllLocation>.from(
            json['allLocation'].map((x) => AllLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'allLocation': List<dynamic>.from(allLocation!.map((x) => x.toJson())),
      };
}

class AllLocation {
  // String? city;
  // String? lat;
  // String? lng;
  // String? country;
  // String? countryCode;
  // String? id;
  String? locationName;
  // dynamic image;
  // dynamic subAddress;

  AllLocation({
    // required this.city,
    // required this.lat,
    // required this.lng,
    // required this.country,
    // required this.countryCode,
    // required this.id,
    required this.locationName,
    // required this.image,
    // required this.subAddress,
  });

  AllLocation copyWith({
    // String? city,
    // String? lat,
    // String? lng,
    // String? country,
    // String? countryCode,
    // String? id,
    String? locationName,
  }) =>
      AllLocation(
        // city: city ?? this.city,
        // lat: lat ?? this.lat,
        // lng: lng ?? this.lng,
        // country: country ?? this.country,
        // countryCode: countryCode ?? this.countryCode,
        // id: id ?? this.id,
        locationName: locationName ?? this.locationName,
        // image: image ?? image,
        // subAddress: subAddress ?? subAddress,
      );

  factory AllLocation.fromJson(Map<String, dynamic> json) => AllLocation(
        // city: json['city'],
        // lat: json['lat'],
        // lng: json['lng'],
        // country: json['country'],
        // countryCode: json['country_code'],
        // id: json['_id'],
        locationName: json['formatted'],
        // image: json['image'],
        // subAddress: json['sub_address'],
      );

  Map<String, dynamic> toJson() => {
        // 'city': city,
        // 'lat': lat,
        // 'lng': lng,
        // 'country': country,
        // 'country_code': countryCode,
        // '_id': id,
        'formatted': locationName,
        // 'image': image,
        // 'sub_address': subAddress,
      };

  @override
  String toString() {
    return locationName ?? '';
  }
}
