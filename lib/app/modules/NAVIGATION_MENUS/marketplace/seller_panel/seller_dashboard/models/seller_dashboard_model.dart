/// Model for the seller dashboard-overview API response.
/// Matches: GET /api/market-place/seller/dashboard-overview
class SellerDashboardModel {
  final String storeName;
  final String storeImage;
  final int chatsToAnswer;
  final double sellerRating;
  final int totalReviews;
  final SellerMetrics metrics;
  final SellerListings listings;
  final List<SellerRecentOrder> recentOrders;
  final SellerCommission commission;

  SellerDashboardModel({
    required this.storeName,
    required this.storeImage,
    required this.chatsToAnswer,
    required this.sellerRating,
    required this.totalReviews,
    required this.metrics,
    required this.listings,
    required this.recentOrders,
    required this.commission,
  });

  factory SellerDashboardModel.fromMap(Map<String, dynamic> map) {
    return SellerDashboardModel(
      storeName: map['store_name'] as String? ?? '',
      storeImage: map['store_image'] as String? ?? '',
      chatsToAnswer: (map['chats_to_answer'] as num?)?.toInt() ?? 0,
      sellerRating: (map['seller_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (map['total_reviews'] as num?)?.toInt() ?? 0,
      metrics: SellerMetrics.fromMap(
          map['metrics'] as Map<String, dynamic>? ?? {}),
      listings: SellerListings.fromMap(
          map['listings'] as Map<String, dynamic>? ?? {}),
      recentOrders: (map['recent_orders'] as List<dynamic>?)
              ?.map((e) => SellerRecentOrder.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      commission: SellerCommission.fromMap(
          map['commission'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SellerMetrics {
  final double totalRevenue;
  final double thisMonthRevenue;
  final int totalOrders;
  final int thisMonthOrders;
  final int pendingOrders;
  final double conversionRate;
  final double revenueChange;
  final double ordersChange;
  final int totalViews;

  SellerMetrics({
    this.totalRevenue = 0,
    this.thisMonthRevenue = 0,
    this.totalOrders = 0,
    this.thisMonthOrders = 0,
    this.pendingOrders = 0,
    this.conversionRate = 0,
    this.revenueChange = 0,
    this.ordersChange = 0,
    this.totalViews = 0,
  });

  factory SellerMetrics.fromMap(Map<String, dynamic> map) {
    return SellerMetrics(
      totalRevenue: (map['total_revenue'] as num?)?.toDouble() ?? 0,
      thisMonthRevenue: (map['this_month_revenue'] as num?)?.toDouble() ?? 0,
      totalOrders: (map['total_orders'] as num?)?.toInt() ?? 0,
      thisMonthOrders: (map['this_month_orders'] as num?)?.toInt() ?? 0,
      pendingOrders: (map['pending_orders'] as num?)?.toInt() ?? 0,
      conversionRate: (map['conversion_rate'] as num?)?.toDouble() ?? 0,
      revenueChange: (map['revenue_change'] as num?)?.toDouble() ?? 0,
      ordersChange: (map['orders_change'] as num?)?.toDouble() ?? 0,
      totalViews: (map['total_views'] as num?)?.toInt() ?? 0,
    );
  }
}

class SellerListings {
  final int needsAttention;
  final int activePending;
  final int soldOutOfStock;
  final int drafts;
  final int toRenew;
  final int toDeleteRelist;
  final int total;

  SellerListings({
    this.needsAttention = 0,
    this.activePending = 0,
    this.soldOutOfStock = 0,
    this.drafts = 0,
    this.toRenew = 0,
    this.toDeleteRelist = 0,
    this.total = 0,
  });

  factory SellerListings.fromMap(Map<String, dynamic> map) {
    return SellerListings(
      needsAttention: (map['needs_attention'] as num?)?.toInt() ?? 0,
      activePending: (map['active_pending'] as num?)?.toInt() ?? 0,
      soldOutOfStock: (map['sold_out_of_stock'] as num?)?.toInt() ?? 0,
      drafts: (map['drafts'] as num?)?.toInt() ?? 0,
      toRenew: (map['to_renew'] as num?)?.toInt() ?? 0,
      toDeleteRelist: (map['to_delete_relist'] as num?)?.toInt() ?? 0,
      total: (map['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class SellerRecentOrder {
  final String orderId;
  final String invoiceNumber;
  final String buyerName;
  final double amount;
  final String status;
  final String createdAt;

  SellerRecentOrder({
    required this.orderId,
    required this.invoiceNumber,
    required this.buyerName,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory SellerRecentOrder.fromMap(Map<String, dynamic> map) {
    return SellerRecentOrder(
      orderId: map['order_id']?.toString() ?? map['_id']?.toString() ?? '',
      invoiceNumber: map['invoice_number'] as String? ?? '',
      buyerName: map['buyer_name'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'pending',
      createdAt: map['created_at'] as String? ?? map['createdAt'] as String? ?? '',
    );
  }
}

class SellerCommission {
  final double rate;
  final double thisMonthTotal;
  final double pendingPayout;
  final String? nextPayoutDate;

  SellerCommission({
    this.rate = 0,
    this.thisMonthTotal = 0,
    this.pendingPayout = 0,
    this.nextPayoutDate,
  });

  factory SellerCommission.fromMap(Map<String, dynamic> map) {
    return SellerCommission(
      rate: (map['rate'] as num?)?.toDouble() ?? 0,
      thisMonthTotal: (map['this_month_total'] as num?)?.toDouble() ?? 0,
      pendingPayout: (map['pending_payout'] as num?)?.toDouble() ?? 0,
      nextPayoutDate: map['next_payout_date'] as String?,
    );
  }
}
