import 'package:get/get.dart';
import '../../../../../../repository/market_place_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/following_store_model.dart';

class FollowingStoresController extends GetxController {
  final MarketPlaceRepository _repo = MarketPlaceRepository();

  RxList<FollowingStoreItem> stores = <FollowingStoreItem>[].obs;
  RxList<FollowingStoreItem> filteredStores = <FollowingStoreItem>[].obs;
  RxBool isLoading = true.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFollowingStores();
    debounce(searchQuery, (_) => _filterStores(),
        time: const Duration(milliseconds: 300));
  }

  Future<void> fetchFollowingStores() async {
    isLoading.value = true;
    final response = await _repo.getFollowingStores();
    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => FollowingStoreItem.fromJson(e as Map<String, dynamic>))
          .toList();
      stores.assignAll(items);
      filteredStores.assignAll(items);
    }
  }

  void _filterStores() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredStores.assignAll(stores);
    } else {
      filteredStores.assignAll(stores
          .where((s) =>
              s.store?.storeName?.toLowerCase().contains(query) ?? false)
          .toList());
    }
  }

  Future<void> unfollowStore(String storeId) async {
    final response = await _repo.toggleStoreFollow(storeId: storeId);
    if (response.isSuccessful) {
      stores.removeWhere((s) => s.store?.id == storeId);
      filteredStores.removeWhere((s) => s.store?.id == storeId);
      showSuccessSnackkbar(message: 'Store unfollowed');
    } else {
      showErrorSnackkbar(message: response.message ?? 'Failed to unfollow');
    }
  }
}
