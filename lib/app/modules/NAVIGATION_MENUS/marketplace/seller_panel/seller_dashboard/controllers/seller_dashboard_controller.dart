import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/seller_dashboard_model.dart';

class SellerDashboardController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final RxBool isLoading = true.obs;
  final Rx<SellerDashboardModel?> dashboard = Rx<SellerDashboardModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    final response = await _repo.getDashboardOverview();
    isLoading.value = false;

    if (response.isSuccessful && response.data is Map<String, dynamic>) {
      dashboard.value =
          SellerDashboardModel.fromMap(response.data as Map<String, dynamic>);
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to load dashboard');
    }
  }
}
