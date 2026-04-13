import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerProductsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxString statusFilter = ''.obs;
  final RxString searchQuery = ''.obs;

  static const int _pageSize = 10;
  int _skip = 0;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

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
      status: statusFilter.value.isEmpty ? null : statusFilter.value,
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

  void setStatusFilter(String status) {
    statusFilter.value = status;
    fetchProducts();
  }

  void search(String query) {
    searchQuery.value = query;
    fetchProducts();
  }

  Future<void> toggleStatus(String productId, String newStatus) async {
    final response = await _repo.toggleProductStatus(
      productId: productId,
      status: newStatus,
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Product status updated');
      fetchProducts();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to update status');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final response = await _repo.deleteProduct(productId: productId);
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Product deleted');
      products.removeWhere((p) => p['_id'] == productId);
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to delete product');
    }
  }
}
