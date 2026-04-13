import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../models/buyer_dashboard_model.dart';
import '../models/buyer_access_status_model.dart';

class BuyerDashboardController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();

  // Dashboard data
  Rx<BuyerDashboardModel?> dashboard = Rx<BuyerDashboardModel?>(null);
  Rx<BuyerAccessStatus?> accessStatus = Rx<BuyerAccessStatus?>(null);
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    hasError.value = false;

    final results = await Future.wait([
      _repo.getDashboardOverview(),
      _repo.getAccessStatus(),
    ]);

    final dashboardResponse = results[0];
    final accessResponse = results[1];

    if (dashboardResponse.isSuccessful &&
        dashboardResponse.data is Map<String, dynamic>) {
      dashboard.value = BuyerDashboardModel.fromMap(
          dashboardResponse.data as Map<String, dynamic>);
    } else {
      hasError.value = true;
      debugPrint('Error fetching buyer dashboard: ${dashboardResponse.message}');
    }

    if (accessResponse.isSuccessful &&
        accessResponse.data is Map<String, dynamic>) {
      accessStatus.value = BuyerAccessStatus.fromMap(
          accessResponse.data as Map<String, dynamic>);
    }

    isLoading.value = false;
  }

  Future<void> refreshDashboard() async {
    await fetchDashboard();
  }
}
