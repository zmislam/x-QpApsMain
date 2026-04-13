import 'package:get/get.dart';
import '../../../../../repository/market_place_repository.dart';

/// Controller for viewing and submitting store reviews.
class StoreReviewsController extends GetxController {
  final MarketPlaceRepository _repo = MarketPlaceRepository();

  final storeId = ''.obs;
  final storeName = ''.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Reviews list
  final reviews = <Map<String, dynamic>>[].obs;
  final averages = Rxn<Map<String, dynamic>>();
  final totalReviews = 0.obs;
  int _page = 1;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      storeId.value = args['store_id']?.toString() ?? '';
      storeName.value = args['store_name']?.toString() ?? '';
    }
    if (storeId.value.isNotEmpty) fetchReviews();
  }

  /// Load store_id externally (e.g. when embedded in a store page).
  void loadForStore(String id, String name) {
    storeId.value = id;
    storeName.value = name;
    _page = 1;
    reviews.clear();
    hasMore.value = true;
    fetchReviews();
  }

  Future<void> fetchReviews({bool loadMore = false}) async {
    if (storeId.value.isEmpty) return;
    if (loadMore) {
      _page++;
    } else {
      _page = 1;
      reviews.clear();
      hasMore.value = true;
    }

    isLoading.value = true;
    try {
      final resp = await _repo.getStoreReviews(
        storeId: storeId.value,
        page: _page,
        limit: 15,
      );
      if (resp.isSuccessful && resp.data != null) {
        final data = resp.data;
        if (data is Map<String, dynamic>) {
          // Shape: { reviews: [...], averages: {...}, pagination: {...} }
          final list = data['reviews'] as List? ?? [];
          reviews.addAll(list.cast<Map<String, dynamic>>());
          averages.value =
              data['averages'] as Map<String, dynamic>? ?? {};
          final pagination =
              data['pagination'] as Map<String, dynamic>? ?? {};
          totalReviews.value = pagination['total'] ?? reviews.length;
          if (list.length < 15) hasMore.value = false;
        } else if (data is List) {
          reviews.addAll(data.cast<Map<String, dynamic>>());
          if (data.length < 15) hasMore.value = false;
        }
      } else {
        if (!loadMore) reviews.clear();
        hasMore.value = false;
      }
    } catch (_) {
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitReview({
    required int overallRating,
    int? shippingRating,
    int? communicationRating,
    int? accuracyRating,
    String? reviewText,
    String? orderId,
  }) async {
    isSubmitting.value = true;
    try {
      final resp = await _repo.submitStoreReview(
        storeId: storeId.value,
        overallRating: overallRating,
        shippingRating: shippingRating,
        communicationRating: communicationRating,
        accuracyRating: accuracyRating,
        reviewText: reviewText,
        orderId: orderId,
      );
      if (resp.isSuccessful) {
        Get.snackbar('Success', 'Review submitted!',
            snackPosition: SnackPosition.BOTTOM);
        await fetchReviews();
        return true;
      } else {
        Get.snackbar('Error', resp.message ?? 'Failed to submit review',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
