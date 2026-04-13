/// Model for address list items.
/// Matches: GET /api/market-place/order/address-list
class AddressItem {
  final String id;
  final String? userId;
  final String? address;
  final String? address2;
  final String? address3;
  final String? country;
  final String? city;
  final String? district;
  final String? ward;
  final String? recipientsName;
  final String? recipientsPhone;
  final String? recipientsEmail;
  final String? createdAt;

  AddressItem({
    required this.id,
    this.userId,
    this.address,
    this.address2,
    this.address3,
    this.country,
    this.city,
    this.district,
    this.ward,
    this.recipientsName,
    this.recipientsPhone,
    this.recipientsEmail,
    this.createdAt,
  });

  factory AddressItem.fromMap(Map<String, dynamic> map) {
    return AddressItem(
      id: map['_id'] as String? ?? '',
      userId: map['user_id'] as String?,
      address: map['address'] as String?,
      address2: map['address2'] as String?,
      address3: map['address3'] as String?,
      country: map['country'] as String?,
      city: map['city'] as String?,
      district: map['district'] as String?,
      ward: map['ward'] as String?,
      recipientsName: map['recipients_name'] as String?,
      recipientsPhone: map['recipients_phone_number'] as String?,
      recipientsEmail: map['recipients_email'] as String?,
      createdAt: map['createdAt'] as String?,
    );
  }

  String get fullAddress {
    final parts = [address, address2, ward, district, city, country]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}
