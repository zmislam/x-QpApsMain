import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/refund_model.dart';

class BuyerRefundsController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();
  final ImagePicker _picker = ImagePicker();

  // ─── Refund list state ──────────────────────────────────────
  RxList<RefundListItem> refunds = <RefundListItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxInt totalCount = 0.obs;

  static const int _pageSize = 20;
  int _currentSkip = 0;

  // ─── Refund detail state ────────────────────────────────────
  Rx<RefundDetailModel?> refundDetail = Rx<RefundDetailModel?>(null);
  RxBool isLoadingDetail = false.obs;

  // ─── Refund chat state ──────────────────────────────────────
  RxList<RefundChatMessage> chatMessages = <RefundChatMessage>[].obs;
  RxBool isLoadingChat = false.obs;
  final chatTextController = TextEditingController();
  RxBool isSendingChat = false.obs;
  RxList<XFile> chatImages = <XFile>[].obs;
  final ScrollController chatScrollController = ScrollController();

  // ─── Create refund form state ───────────────────────────────
  RxBool isSubmitting = false.obs;
  final noteController = TextEditingController();
  RxList<XFile> refundImages = <XFile>[].obs;
  RxDouble deliveryCharge = 0.0.obs;

  /// Each item: { product_id, variant_id, refund_quantity, sell_price, refund_note }
  RxList<Map<String, dynamic>> refundItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRefunds();
  }

  @override
  void onClose() {
    chatTextController.dispose();
    noteController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════
  //  REFUND LIST
  // ═══════════════════════════════════════════════════════════

  Future<void> fetchRefunds({bool refresh = false}) async {
    if (refresh) {
      _currentSkip = 0;
      hasMoreData.value = true;
    }
    isLoading.value = true;

    final response = await _repo.getRefundList(
      skip: 0,
      limit: _pageSize,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => RefundListItem.fromMap(e as Map<String, dynamic>))
          .toList();
      refunds.value = items;
      _currentSkip = items.length;
      hasMoreData.value = items.length >= _pageSize;
    } else {
      debugPrint('Error fetching refunds: ${response.message}');
    }
  }

  Future<void> loadMoreRefunds() async {
    if (isLoadingMore.value || !hasMoreData.value) return;
    isLoadingMore.value = true;

    final response = await _repo.getRefundList(
      skip: _currentSkip,
      limit: _pageSize,
    );

    isLoadingMore.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => RefundListItem.fromMap(e as Map<String, dynamic>))
          .toList();
      refunds.addAll(items);
      _currentSkip += items.length;
      hasMoreData.value = items.length >= _pageSize;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  REFUND DETAIL
  // ═══════════════════════════════════════════════════════════

  Future<void> fetchRefundDetail(String refundId) async {
    isLoadingDetail.value = true;
    refundDetail.value = null;

    final response = await _repo.getRefundDetails(refundId: refundId);

    isLoadingDetail.value = false;

    if (response.isSuccessful && response.data is Map<String, dynamic>) {
      refundDetail.value =
          RefundDetailModel.fromMap(response.data as Map<String, dynamic>);
      // Also fetch chat for this refund
      fetchRefundChat(refundId);
    } else {
      AppSnackbar.showError('Failed to load refund details');
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  REFUND CHAT
  // ═══════════════════════════════════════════════════════════

  Future<void> fetchRefundChat(String refundId) async {
    isLoadingChat.value = true;

    final response = await _repo.getRefundChat(refundId: refundId);

    isLoadingChat.value = false;

    if (response.isSuccessful && response.data is List) {
      chatMessages.value = (response.data as List)
          .map((e) => RefundChatMessage.fromMap(e as Map<String, dynamic>))
          .toList();
      _scrollChatToBottom();
    }
  }

  Future<void> sendChatMessage(String refundId) async {
    final text = chatTextController.text.trim();
    if (text.isEmpty && chatImages.isEmpty) return;

    isSendingChat.value = true;

    final response = await _repo.sendRefundChat(
      refundId: refundId,
      text: text.isNotEmpty ? text : ' ',
      mediaFiles: chatImages.toList(),
    );

    isSendingChat.value = false;

    if (response.isSuccessful) {
      chatTextController.clear();
      chatImages.clear();
      fetchRefundChat(refundId);
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to send message');
    }
  }

  Future<void> pickChatImage() async {
    if (chatImages.length >= 3) {
      AppSnackbar.showError('Maximum 3 images allowed');
      return;
    }
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      chatImages.add(picked);
    }
  }

  void removeChatImage(int index) {
    chatImages.removeAt(index);
  }

  void _scrollChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ═══════════════════════════════════════════════════════════
  //  CREATE REFUND
  // ═══════════════════════════════════════════════════════════

  void addRefundItem(Map<String, dynamic> item) {
    refundItems.add(item);
  }

  void removeRefundItem(int index) {
    refundItems.removeAt(index);
  }

  void updateRefundItem(int index, Map<String, dynamic> updated) {
    refundItems[index] = updated;
    refundItems.refresh();
  }

  Future<void> pickRefundImage() async {
    if (refundImages.length >= 5) {
      AppSnackbar.showError('Maximum 5 images allowed');
      return;
    }
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      refundImages.add(picked);
    }
  }

  void removeRefundImage(int index) {
    refundImages.removeAt(index);
  }

  Future<void> submitRefund({
    required String orderSubDetailsId,
  }) async {
    if (refundItems.isEmpty) {
      AppSnackbar.showError('Add at least one item to refund');
      return;
    }

    isSubmitting.value = true;

    final response = await _repo.saveRefund(
      orderSubDetailsId: orderSubDetailsId,
      deliveryCharge: deliveryCharge.value,
      note: noteController.text.trim().isNotEmpty
          ? noteController.text.trim()
          : null,
      refundDetailsJson: jsonEncode(refundItems.toList()),
      mediaFiles: refundImages.toList(),
    );

    isSubmitting.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Refund request submitted successfully');
      resetRefundForm();
      fetchRefunds(refresh: true);
      Get.back(); // Close the sheet/page
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to submit refund');
    }
  }

  void resetRefundForm() {
    noteController.clear();
    refundImages.clear();
    refundItems.clear();
    deliveryCharge.value = 0.0;
  }
}
