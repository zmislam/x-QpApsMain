import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerCouponsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  // Stores
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxString selectedStoreId = ''.obs;
  final RxString selectedStoreName = ''.obs;

  // Coupons
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> coupons = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxInt totalCount = 0.obs;
  int _skip = 0;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    _loadStores();
  }

  Future<void> _loadStores() async {
    final response = await _repo.getMyStores(limit: 50);
    if (response.isSuccessful && response.data is List) {
      stores.value = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      if (stores.isNotEmpty) {
        selectedStoreId.value = stores.first['_id']?.toString() ?? '';
        selectedStoreName.value =
            stores.first['store_name']?.toString() ?? 'Store';
        fetchCoupons();
      } else {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  void selectStore(String storeId, String storeName) {
    selectedStoreId.value = storeId;
    selectedStoreName.value = storeName;
    fetchCoupons();
  }

  Future<void> fetchCoupons({bool loadMore = false}) async {
    if (selectedStoreId.value.isEmpty) return;

    if (loadMore) {
      _skip += _pageSize;
    } else {
      _skip = 0;
      coupons.clear();
      isLoading.value = true;
    }

    final response = await _repo.getCouponList(
      storeId: selectedStoreId.value,
      skip: _skip,
      limit: _pageSize,
    );
    isLoading.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      List<Map<String, dynamic>> items = [];
      if (data is List) {
        items = data
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      } else if (data is Map) {
        final mapData = data as Map<String, dynamic>;
        final list = mapData['data'] as List? ?? [];
        items = list
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
        totalCount.value = mapData['totalCount'] as int? ?? 0;
      }
      coupons.addAll(items);
      hasMore.value = items.length >= _pageSize;
    } else if (!loadMore) {
      AppSnackbar.showError(response.message ?? 'Failed to load coupons');
    }
  }

  Future<bool> createCoupon(Map<String, dynamic> data) async {
    data['store_id'] = selectedStoreId.value;
    final response = await _repo.createCoupon(couponData: data);
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Coupon created');
      fetchCoupons();
      return true;
    }
    AppSnackbar.showError(response.message ?? 'Failed to create coupon');
    return false;
  }

  Future<bool> updateCoupon(String couponId, Map<String, dynamic> data) async {
    final response =
        await _repo.updateCoupon(couponId: couponId, couponData: data);
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Coupon updated');
      fetchCoupons();
      return true;
    }
    AppSnackbar.showError(response.message ?? 'Failed to update coupon');
    return false;
  }

  Future<void> toggleCouponStatus(String couponId, String currentStatus) async {
    final newStatus = currentStatus == 'active' ? 'inactive' : 'active';
    await updateCoupon(couponId, {'status': newStatus});
  }
}
