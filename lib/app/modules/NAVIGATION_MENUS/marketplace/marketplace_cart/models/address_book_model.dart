class MyAddressData {
  String? id;
  String? userId;
  String? address;
  String? city;
  String? district;
  String? ward;
  String? recipientsName;
  String? recipientsPhoneNumber;
  String? createdAt;
  String? updatedAt;
  int? v;

  MyAddressData({
    this.id,
    this.userId,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.recipientsName,
    this.recipientsPhoneNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // From Map constructor with all properties nullable
  factory MyAddressData.fromMap(Map<String, dynamic> map) {
    return MyAddressData(
      id: map['_id'] as String?,
      userId: map['user_id'] as String?,
      address: map['address'] as String?,
      city: map['city'] as String?,
      district: map['district'] as String?,
      ward: map['ward'] as String?,
      recipientsName: map['recipients_name'] as String?,
      recipientsPhoneNumber: map['recipients_phone_number'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
    );
  }

  // Convert instance to a map
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'address': address,
      'city': city,
      'district': district,
      'ward': ward,
      'recipients_name': recipientsName,
      'recipients_phone_number': recipientsPhoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

// Example for parsing a list of MyAddressData from JSON response
class AddressResponse {
  int? status;
  int? totalCount;
  List<MyAddressData>? data;

  AddressResponse({this.status, this.totalCount, this.data});

  // Factory method for creating an instance from map
  factory AddressResponse.fromMap(Map<String, dynamic> map) {
    return AddressResponse(
      status: map['status'] as int?,
      totalCount: map['totalCount'] as int?,
      data: (map['data'] as List<dynamic>?)
          ?.map((e) => MyAddressData.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert instance to a map
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalCount': totalCount,
      'data': data?.map((e) => e.toMap()).toList(),
    };
  }
}
