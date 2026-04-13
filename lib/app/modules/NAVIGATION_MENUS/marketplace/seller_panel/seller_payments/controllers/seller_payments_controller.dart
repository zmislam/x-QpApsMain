import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerPaymentsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> payments = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxString statusFilter = ''.obs;
  final RxBool isTransferring = false.obs;

  static const int _pageSize = 10;
  int _skip = 0;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  Future<void> fetchPayments({bool loadMore = false}) async {
    if (loadMore) {
      _skip += _pageSize;
    } else {
      _skip = 0;
      payments.clear();
      isLoading.value = true;
    }

    final response = await _repo.getPaymentList(
      skip: _skip,
      limit: _pageSize,
      status: statusFilter.value.isEmpty ? null : statusFilter.value,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      payments.addAll(items);
      hasMore.value = items.length >= _pageSize;
    } else if (!loadMore) {
      AppSnackbar.showError(response.message ?? 'Failed to load payments');
    }
  }

  void setStatusFilter(String status) {
    statusFilter.value = status;
    fetchPayments();
  }

  Future<void> transferToWallet(double amount) async {
    if (amount <= 0) {
      AppSnackbar.showError('Invalid amount');
      return;
    }
    isTransferring.value = true;
    final response = await _repo.transferToWallet(totalAmount: amount);
    isTransferring.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Transfer successful');
      fetchPayments();
    } else {
      AppSnackbar.showError(response.message ?? 'Transfer failed');
    }
  }
}
