import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';

/// Controller for seller verification — submit form + check status.
class SellerVerificationController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Verification status: null (not submitted), pending, under_review, approved, rejected
  final verificationData = Rxn<Map<String, dynamic>>();
  String get status =>
      verificationData.value?['status']?.toString() ?? '';
  String get rejectionReason =>
      verificationData.value?['rejection_reason']?.toString() ?? '';

  // Stores for selection
  final stores = <Map<String, dynamic>>[].obs;
  final selectedStoreId = ''.obs;
  final selectedStoreName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStores();
    fetchVerificationStatus();
  }

  Future<void> _loadStores() async {
    final resp = await _repo.getMyStores();
    if (resp.isSuccessful && resp.data != null) {
      final list = resp.data is List ? resp.data as List : [];
      stores.value = list.cast<Map<String, dynamic>>();
      if (stores.isNotEmpty) {
        selectedStoreId.value = stores.first['_id']?.toString() ?? '';
        selectedStoreName.value =
            stores.first['store_name']?.toString() ?? 'Store';
      }
    }
  }

  void selectStore(String id, String name) {
    selectedStoreId.value = id;
    selectedStoreName.value = name;
  }

  Future<void> fetchVerificationStatus() async {
    isLoading.value = true;
    try {
      final resp = await _repo.getVerificationStatus();
      if (resp.isSuccessful && resp.data != null) {
        if (resp.data is Map<String, dynamic>) {
          verificationData.value = resp.data as Map<String, dynamic>;
        }
      } else {
        verificationData.value = null;
      }
    } catch (_) {
      verificationData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitVerification({
    required String businessName,
    required String businessType,
    String? taxId,
    String? bankName,
    String? bankAccount,
    String? bankRouting,
  }) async {
    if (selectedStoreId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a store',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isSubmitting.value = true;
    try {
      final data = <String, dynamic>{
        'store_id': selectedStoreId.value,
        'business_name': businessName,
        'business_type': businessType,
      };
      if (taxId != null && taxId.isNotEmpty) data['tax_id'] = taxId;
      if (bankName != null && bankName.isNotEmpty) {
        data['bank_name'] = bankName;
      }
      if (bankAccount != null && bankAccount.isNotEmpty) {
        data['bank_account'] = bankAccount;
      }
      if (bankRouting != null && bankRouting.isNotEmpty) {
        data['bank_routing'] = bankRouting;
      }

      final resp = await _repo.submitVerification(verificationData: data);
      if (resp.isSuccessful) {
        Get.snackbar('Success', 'Verification submitted',
            snackPosition: SnackPosition.BOTTOM);
        await fetchVerificationStatus();
        return true;
      } else {
        Get.snackbar(
            'Error', resp.message ?? 'Failed to submit verification',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
