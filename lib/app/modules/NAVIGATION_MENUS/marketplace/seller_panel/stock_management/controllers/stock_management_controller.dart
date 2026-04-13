import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class StockManagementController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SellerRepository _repo = SellerRepository();

  // ─── Products tab state ───────────────────────────────────
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxString searchQuery = ''.obs;
  int _skip = 0;
  static const int _pageSize = 10;

  // ─── Variant stocks state (per product) ───────────────────
  final RxBool isLoadingVariants = false.obs;
  final RxList<Map<String, dynamic>> variants = <Map<String, dynamic>>[].obs;
  final RxString selectedProductId = ''.obs;
  final RxString selectedProductName = ''.obs;

  // ─── Stock history state ──────────────────────────────────
  final RxBool isLoadingHistory = false.obs;
  final RxList<Map<String, dynamic>> stockHistory =
      <Map<String, dynamic>>[].obs;
  final RxInt historyTotalCount = 0.obs;
  final RxBool hasMoreHistory = true.obs;
  int _historySkip = 0;
  static const int _historyPageSize = 20;

  // ─── Alerts state ─────────────────────────────────────────
  final RxList<Map<String, dynamic>> alerts = <Map<String, dynamic>>[].obs;
  final RxInt alertCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchAlerts();
  }

  // ─── Products ─────────────────────────────────────────────
  Future<void> fetchProducts({bool loadMore = false}) async {
    if (loadMore) {
      _skip += _pageSize;
    } else {
      _skip = 0;
      products.clear();
      isLoading.value = true;
    }

    final response = await _repo.getMyProducts(
      skip: _skip,
      limit: _pageSize,
      keyword: searchQuery.value.isEmpty ? null : searchQuery.value,
    );
    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      products.addAll(items);
      hasMore.value = items.length >= _pageSize;
    } else if (!loadMore) {
      AppSnackbar.showError(response.message ?? 'Failed to load products');
    }
  }

  void search(String query) {
    searchQuery.value = query;
    fetchProducts();
  }

  // ─── Variant Stocks ───────────────────────────────────────
  Future<void> fetchVariantStocks(String productId) async {
    selectedProductId.value = productId;
    isLoadingVariants.value = true;
    variants.clear();

    final response = await _repo.getStockByVariant(productId: productId);
    isLoadingVariants.value = false;

    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      selectedProductName.value =
          data['product_name'] as String? ?? 'Product';
      final variantList = data['product_variants'] as List? ?? [];
      variants.value = variantList
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to load variant stocks');
    }
  }

  Future<void> updateStocks(
    String productId,
    List<Map<String, dynamic>> variantUpdates,
  ) async {
    final response = await _repo.updateStocks(
      productId: productId,
      variants: variantUpdates,
    );

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Stocks updated successfully');
      // Refresh variant stocks
      await fetchVariantStocks(productId);
      // Refresh alerts
      fetchAlerts();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to update stocks');
    }
  }

  Future<void> setThreshold(String variantId, int threshold) async {
    final response = await _repo.setStockThreshold(
      variantId: variantId,
      threshold: threshold,
    );

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Threshold updated');
      // Refresh variant stocks for current product
      if (selectedProductId.value.isNotEmpty) {
        fetchVariantStocks(selectedProductId.value);
      }
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to set threshold');
    }
  }

  // ─── Stock History ────────────────────────────────────────
  Future<void> fetchStockHistory({bool loadMore = false}) async {
    if (loadMore) {
      _historySkip += _historyPageSize;
    } else {
      _historySkip = 0;
      stockHistory.clear();
      isLoadingHistory.value = true;
    }

    final response = await _repo.getStockHistoryList(
      skip: _historySkip,
      limit: _historyPageSize,
    );
    isLoadingHistory.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      if (data is List) {
        final items = data
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
        stockHistory.addAll(items);
        hasMoreHistory.value = items.length >= _historyPageSize;
      } else if (data is Map) {
        final list = (data['data'] as List?) ?? [];
        final items = list
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
        stockHistory.addAll(items);
        historyTotalCount.value = data['totalCount'] as int? ?? 0;
        hasMoreHistory.value = items.length >= _historyPageSize;
      }
    } else if (!loadMore) {
      AppSnackbar.showError(
          response.message ?? 'Failed to load stock history');
    }
  }

  // ─── Alerts ───────────────────────────────────────────────
  Future<void> fetchAlerts() async {
    final response = await _repo.getInventoryAlerts();
    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final alertList = data['alerts'] as List? ?? [];
      alerts.value = alertList
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      final pagination = data['pagination'] as Map<String, dynamic>? ?? {};
      alertCount.value = pagination['total'] as int? ?? alertList.length;
    }
  }
}
