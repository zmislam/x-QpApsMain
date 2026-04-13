class BuyerAccessStatus {
  final String accessLevel;
  final bool canSell;
  final bool canBuy;
  final int storeCount;
  final int listingCount;
  final int activeOrders;
  final String verificationStatus;
  final String? memberSince;
  final int profileHealthScore;
  final List<String> profileHealthMissing;

  BuyerAccessStatus({
    required this.accessLevel,
    required this.canSell,
    required this.canBuy,
    required this.storeCount,
    required this.listingCount,
    required this.activeOrders,
    required this.verificationStatus,
    this.memberSince,
    required this.profileHealthScore,
    required this.profileHealthMissing,
  });

  factory BuyerAccessStatus.fromMap(Map<String, dynamic> map) {
    final health = map['profile_health'] as Map<String, dynamic>? ?? {};
    return BuyerAccessStatus(
      accessLevel: map['access_level'] ?? 'full',
      canSell: map['can_sell'] ?? false,
      canBuy: map['can_buy'] ?? true,
      storeCount: map['store_count'] ?? 0,
      listingCount: map['listing_count'] ?? 0,
      activeOrders: map['active_orders'] ?? 0,
      verificationStatus: map['verification_status'] ?? 'not_submitted',
      memberSince: map['member_since'],
      profileHealthScore: health['score'] ?? 0,
      profileHealthMissing: List<String>.from(health['missing'] ?? []),
    );
  }
}
