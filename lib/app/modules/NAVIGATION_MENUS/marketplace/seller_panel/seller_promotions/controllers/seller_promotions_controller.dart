import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerPromotionsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  // ─── State ────────────────────────────────────────────────
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> promotions = <Map<String, dynamic>>[].obs;
  final RxString statusFilter = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalCount = 0.obs;
  final int pageSize = 10;

  // ─── Stores for create form ───────────────────────────────
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> storeProducts =
      <Map<String, dynamic>>[].obs;
  final RxBool isStoresLoading = false.obs;

  static const statusOptions = [
    '',
    'draft',
    'pending_review',
    'approved',
    'active',
    'paused',
    'completed',
    'cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchPromotions();
    _loadStores();
  }

  // ─── Fetch Promotions ─────────────────────────────────────
  Future<void> fetchPromotions({bool refresh = false}) async {
    if (refresh) currentPage.value = 1;
    isLoading.value = true;

    final response = await _repo.getMyPromotions(
      page: currentPage.value,
      limit: pageSize,
      status: statusFilter.value.isNotEmpty ? statusFilter.value : null,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      promotions.value = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    } else {
      promotions.clear();
    }
  }

  void onFilterChanged(String status) {
    statusFilter.value = status;
    fetchPromotions(refresh: true);
  }

  // ─── Lifecycle Actions ────────────────────────────────────
  Future<void> submitForReview(String id) async {
    final res = await _repo.submitPromotion(promotionId: id);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Submitted for review');
      fetchPromotions();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed');
    }
  }

  Future<void> pausePromotion(String id) async {
    final res = await _repo.pausePromotion(promotionId: id);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Promotion paused');
      fetchPromotions();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed');
    }
  }

  Future<void> resumePromotion(String id) async {
    final res = await _repo.resumePromotion(promotionId: id);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Promotion resumed');
      fetchPromotions();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed');
    }
  }

  Future<void> cancelPromotion(String id) async {
    final confirmed = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Cancel Promotion'),
            content:
                const Text('Are you sure? This action cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Get.back(result: true),
                  child:
                      const Text('Cancel It', style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    final res = await _repo.cancelPromotion(promotionId: id);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Promotion cancelled');
      fetchPromotions();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed');
    }
  }

  // ─── Stores loader (for create form) ─────────────────────
  Future<void> _loadStores() async {
    isStoresLoading.value = true;
    final res = await _repo.getMyStores(limit: 50);
    isStoresLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      stores.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  // ─── Helpers ──────────────────────────────────────────────
  String statusLabel(String status) {
    switch (status) {
      case 'pending_review':
        return 'Pending Review';
      case 'draft':
        return 'Draft';
      case 'approved':
        return 'Approved';
      case 'active':
        return 'Active';
      case 'paused':
        return 'Paused';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      default:
        return status.capitalizeFirst ?? status;
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'draft':
        return Colors.blueGrey;
      case 'pending_review':
        return Colors.blue;
      case 'approved':
        return Colors.teal;
      case 'completed':
        return Colors.indigo;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
