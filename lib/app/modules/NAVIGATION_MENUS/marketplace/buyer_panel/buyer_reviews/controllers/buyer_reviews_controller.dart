import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/buyer_review_model.dart';

class BuyerReviewsController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();
  final ImagePicker _picker = ImagePicker();

  // Reviews list
  RxList<BuyerReviewItem> reviews = <BuyerReviewItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxInt totalCount = 0.obs;

  static const int _pageSize = 20;
  int _currentSkip = 0;

  // Submit review form
  RxInt selectedRating = 5.obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RxList<XFile> selectedImages = <XFile>[].obs;
  RxBool isSubmitting = false.obs;
  RxBool isDeleting = false.obs;
  RxString deletingReviewId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // ─── Fetch Reviews ─────────────────────────────────────────
  Future<void> fetchReviews({bool refresh = false}) async {
    if (refresh) {
      _currentSkip = 0;
      hasMoreData.value = true;
    }
    isLoading.value = true;

    final response = await _repo.getAllReviews(
      skip: 0,
      limit: _pageSize,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => BuyerReviewItem.fromMap(e as Map<String, dynamic>))
          .toList();
      reviews.value = items;
      _currentSkip = items.length;
      hasMoreData.value = items.length >= _pageSize;
    } else {
      debugPrint('Error fetching reviews: ${response.message}');
    }
  }

  Future<void> loadMoreReviews() async {
    if (isLoadingMore.value || !hasMoreData.value) return;
    isLoadingMore.value = true;

    final response = await _repo.getAllReviews(
      skip: _currentSkip,
      limit: _pageSize,
    );

    isLoadingMore.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => BuyerReviewItem.fromMap(e as Map<String, dynamic>))
          .toList();
      reviews.addAll(items);
      _currentSkip = reviews.length;
      hasMoreData.value = reviews.length < totalCount.value;
    }
  }

  Future<void> refreshReviews() async {
    await fetchReviews(refresh: true);
  }

  // ─── Submit Review ─────────────────────────────────────────
  Future<void> pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      // Limit to 5 images
      final remaining = 5 - selectedImages.length;
      if (remaining > 0) {
        selectedImages.addAll(picked.take(remaining));
      }
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<bool> submitReview({
    required String productId,
    required String orderId,
  }) async {
    if (titleController.text.trim().isEmpty) {
      AppSnackbar.showError('Please enter a review title');
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      AppSnackbar.showError('Please enter a review description');
      return false;
    }

    isSubmitting.value = true;

    final mediaFiles = selectedImages.toList();

    final response = await _repo.saveProductReview(
      productId: productId,
      orderId: orderId,
      rating: selectedRating.value,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      mediaFiles: mediaFiles.isNotEmpty ? mediaFiles : null,
    );

    isSubmitting.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Review submitted successfully');
      _resetForm();
      refreshReviews();
      return true;
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to submit review');
      return false;
    }
  }

  // ─── Delete Review ─────────────────────────────────────────
  Future<void> deleteReview(String reviewId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isDeleting.value = true;
    deletingReviewId.value = reviewId;

    final response = await _repo.deleteReview(reviewId: reviewId);

    isDeleting.value = false;
    deletingReviewId.value = '';

    if (response.isSuccessful) {
      reviews.removeWhere((r) => r.id == reviewId);
      AppSnackbar.showSuccess('Review deleted');
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to delete review');
    }
  }

  void _resetForm() {
    selectedRating.value = 5;
    titleController.clear();
    descriptionController.clear();
    selectedImages.clear();
  }
}
