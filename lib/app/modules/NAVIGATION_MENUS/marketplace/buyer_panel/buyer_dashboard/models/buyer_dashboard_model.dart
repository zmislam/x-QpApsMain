/// Model for the buyer dashboard-overview API response.
/// Matches: GET /api/market-place/buyer/dashboard-overview
class BuyerDashboardModel {
  final DashboardMetrics metrics;
  final QuickCounts quickCounts;
  final List<RecentOrder> recentOrders;
  final List<SpendingMonth> spendingChart;
  final List<TopStore> topStores;

  BuyerDashboardModel({
    required this.metrics,
    required this.quickCounts,
    required this.recentOrders,
    required this.spendingChart,
    required this.topStores,
  });

  factory BuyerDashboardModel.fromMap(Map<String, dynamic> map) {
    return BuyerDashboardModel(
      metrics: DashboardMetrics.fromMap(
          map['metrics'] as Map<String, dynamic>? ?? {}),
      quickCounts: QuickCounts.fromMap(
          map['quick_counts'] as Map<String, dynamic>? ?? {}),
      recentOrders: (map['recent_orders'] as List<dynamic>?)
              ?.map((e) => RecentOrder.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      spendingChart: (map['spending_chart'] as List<dynamic>?)
              ?.map((e) => SpendingMonth.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      topStores: (map['top_stores'] as List<dynamic>?)
              ?.map((e) => TopStore.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DashboardMetrics {
  final int totalOrders;
  final int pending;
  final int processing;
  final int accepted;
  final int delivered;
  final int canceled;
  final int refunded;
  final double totalSpent;
  final double inEscrow;
  final double refundAmount;
  final int ordersThisMonth;

  DashboardMetrics({
    this.totalOrders = 0,
    this.pending = 0,
    this.processing = 0,
    this.accepted = 0,
    this.delivered = 0,
    this.canceled = 0,
    this.refunded = 0,
    this.totalSpent = 0,
    this.inEscrow = 0,
    this.refundAmount = 0,
    this.ordersThisMonth = 0,
  });

  factory DashboardMetrics.fromMap(Map<String, dynamic> map) {
    return DashboardMetrics(
      totalOrders: map['total_orders'] as int? ?? 0,
      pending: map['pending'] as int? ?? 0,
      processing: map['processing'] as int? ?? 0,
      accepted: map['accepted'] as int? ?? 0,
      delivered: map['delivered'] as int? ?? 0,
      canceled: map['canceled'] as int? ?? 0,
      refunded: map['refunded'] as int? ?? 0,
      totalSpent: (map['total_spent'] as num?)?.toDouble() ?? 0,
      inEscrow: (map['in_escrow'] as num?)?.toDouble() ?? 0,
      refundAmount: (map['refund_amount'] as num?)?.toDouble() ?? 0,
      ordersThisMonth: map['orders_this_month'] as int? ?? 0,
    );
  }
}

class QuickCounts {
  final int savedItems;
  final int activeAlerts;
  final int followingStores;
  final int reviewsGiven;
  final int openComplaints;
  final int activeRefunds;

  QuickCounts({
    this.savedItems = 0,
    this.activeAlerts = 0,
    this.followingStores = 0,
    this.reviewsGiven = 0,
    this.openComplaints = 0,
    this.activeRefunds = 0,
  });

  factory QuickCounts.fromMap(Map<String, dynamic> map) {
    return QuickCounts(
      savedItems: map['saved_items'] as int? ?? 0,
      activeAlerts: map['active_alerts'] as int? ?? 0,
      followingStores: map['following_stores'] as int? ?? 0,
      reviewsGiven: map['reviews_given'] as int? ?? 0,
      openComplaints: map['open_complaints'] as int? ?? 0,
      activeRefunds: map['active_refunds'] as int? ?? 0,
    );
  }
}

class RecentOrder {
  final String id;
  final String? invoiceNumber;
  final String? createdAt;
  final String? storeName;
  final String? storeId;
  final String? status;
  final double totalAmount;
  final int itemCount;
  final String? firstProductImage;

  RecentOrder({
    required this.id,
    this.invoiceNumber,
    this.createdAt,
    this.storeName,
    this.storeId,
    this.status,
    this.totalAmount = 0,
    this.itemCount = 0,
    this.firstProductImage,
  });

  factory RecentOrder.fromMap(Map<String, dynamic> map) {
    return RecentOrder(
      id: map['_id'] as String? ?? '',
      invoiceNumber: map['invoice_number'] as String?,
      createdAt: map['createdAt'] as String?,
      storeName: map['store_name'] as String?,
      storeId: map['store_id'] as String?,
      status: map['status'] as String?,
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0,
      itemCount: map['item_count'] as int? ?? 0,
      firstProductImage: map['first_product_image'] as String?,
    );
  }
}

class SpendingMonth {
  final String month;
  final double amount;
  final int orders;

  SpendingMonth({
    required this.month,
    this.amount = 0,
    this.orders = 0,
  });

  factory SpendingMonth.fromMap(Map<String, dynamic> map) {
    return SpendingMonth(
      month: map['month'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      orders: map['orders'] as int? ?? 0,
    );
  }
}

class TopStore {
  final String storeId;
  final String? storeName;
  final String? storeLogo;
  final bool isVerified;
  final int orderCount;
  final double totalSpent;

  TopStore({
    required this.storeId,
    this.storeName,
    this.storeLogo,
    this.isVerified = false,
    this.orderCount = 0,
    this.totalSpent = 0,
  });

  factory TopStore.fromMap(Map<String, dynamic> map) {
    return TopStore(
      storeId: map['store_id'] as String? ?? '',
      storeName: map['store_name'] as String?,
      storeLogo: map['store_logo'] as String?,
      isVerified: map['is_verified'] as bool? ?? false,
      orderCount: map['order_count'] as int? ?? 0,
      totalSpent: (map['total_spent'] as num?)?.toDouble() ?? 0,
    );
  }
}
