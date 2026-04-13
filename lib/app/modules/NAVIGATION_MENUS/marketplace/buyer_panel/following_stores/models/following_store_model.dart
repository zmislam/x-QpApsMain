class FollowingStoreItem {
  final String? id;
  final StoreInfo? store;
  final bool notifyNewListings;
  final int newListingsCount;
  final DateTime? followedAt;

  FollowingStoreItem({
    this.id,
    this.store,
    this.notifyNewListings = true,
    this.newListingsCount = 0,
    this.followedAt,
  });

  factory FollowingStoreItem.fromJson(Map<String, dynamic> json) {
    return FollowingStoreItem(
      id: json['_id']?.toString(),
      store: json['store_id'] is Map<String, dynamic>
          ? StoreInfo.fromJson(json['store_id'])
          : null,
      notifyNewListings: json['notify_new_listings'] ?? true,
      newListingsCount: json['new_listings_count'] ?? 0,
      followedAt: json['followedAt'] != null
          ? DateTime.tryParse(json['followedAt'].toString())
          : null,
    );
  }
}

class StoreInfo {
  final String? id;
  final String? storeName;
  final String? storeLogo;
  final bool isVerified;

  StoreInfo({
    this.id,
    this.storeName,
    this.storeLogo,
    this.isVerified = false,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['_id']?.toString(),
      storeName: json['store_name'],
      storeLogo: json['store_logo'],
      isVerified: json['is_verified'] ?? false,
    );
  }
}
