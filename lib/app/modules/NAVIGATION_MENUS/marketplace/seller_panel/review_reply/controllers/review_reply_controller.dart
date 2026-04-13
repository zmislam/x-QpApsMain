import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class ReviewReplyController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final products = <Map<String, dynamic>>[].obs;
  final selectedProductId = ''.obs;
  final reviews = <Map<String, dynamic>>[].obs;
  final isReviewsLoading = false.obs;
  final isReplying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    isLoading.value = true;
    final res = await _repo.getMyProducts(skip: 0, limit: 100);
    isLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      products.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      // Auto-load reviews for first product
      if (products.isNotEmpty) {
        final id = products.first['_id']?.toString() ?? '';
        if (id.isNotEmpty) loadReviews(id);
      }
    }
  }

  Future<void> loadReviews(String productId) async {
    selectedProductId.value = productId;
    isReviewsLoading.value = true;
    final res = await _repo.getProductReviews(productId: productId);
    isReviewsLoading.value = false;
    if (res.isSuccessful) {
      if (res.data is Map) {
        final reviewList = (res.data as Map)['reviews'];
        if (reviewList is List) {
          reviews.value = reviewList
              .map(
                  (e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
              .toList();
          return;
        }
      }
      if (res.data is List) {
        reviews.value = (res.data as List)
            .map(
                (e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
        return;
      }
    }
    reviews.clear();
  }

  Future<void> replyToReview(String reviewId, String reply) async {
    if (selectedProductId.value.isEmpty || reply.trim().isEmpty) return;
    isReplying.value = true;
    final res = await _repo.replyToReview(
      productId: selectedProductId.value,
      reviewId: reviewId,
      reply: reply.trim(),
    );
    isReplying.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Reply sent');
      loadReviews(selectedProductId.value);
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to send reply');
    }
  }
}
