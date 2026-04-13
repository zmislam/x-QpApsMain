import 'package:get/get.dart';
import '../../../../../../repository/buyer_repository.dart';

class RecentActivityItem {
  final String type; // "purchased" or "saved"
  final Map<String, dynamic>? product;
  final Map<String, dynamic>? store;
  final String? orderId;
  final int? quantity;
  final num? price;
  final String? date;

  RecentActivityItem({
    required this.type,
    this.product,
    this.store,
    this.orderId,
    this.quantity,
    this.price,
    this.date,
  });

  factory RecentActivityItem.fromMap(Map<String, dynamic> map) {
    return RecentActivityItem(
      type: map['type'] ?? '',
      product: map['product'] as Map<String, dynamic>?,
      store: map['store'] as Map<String, dynamic>?,
      orderId: map['order_id']?.toString(),
      quantity: map['quantity'],
      price: map['price'],
      date: map['date']?.toString(),
    );
  }

  String get productName => product?['product_name'] ?? 'Unknown Product';
  List<dynamic> get productMedia => (product?['media'] as List?) ?? [];
  String? get productId => product?['_id']?.toString();
  String? get storeName => store?['store_name'];
}

class BuyerRecentActivityController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();

  RxList<RecentActivityItem> activities = <RecentActivityItem>[].obs;
  RxBool isLoading = true.obs;
  RxString filterType = ''.obs;

  List<RecentActivityItem> get filteredActivities {
    if (filterType.value.isEmpty) return activities;
    return activities.where((a) => a.type == filterType.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchActivity();
  }

  Future<void> fetchActivity() async {
    isLoading.value = true;
    final response = await _repo.getRecentActivity();
    if (response.isSuccessful && response.data is List) {
      activities.value = (response.data as List)
          .map((e) =>
              RecentActivityItem.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      activities.clear();
    }
    isLoading.value = false;
  }
}
