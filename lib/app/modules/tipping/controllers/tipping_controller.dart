import 'package:get/get.dart';
import '../models/tipping_models.dart';
import '../services/tipping_api_service.dart';

class TippingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _apiService = TippingApiService();

  // State
  final isLoading = true.obs;
  final summary = Rxn<TipSummary>();
  final receivedHistory = <TipTransaction>[].obs;
  final sentHistory = <TipTransaction>[].obs;
  final supporters = <TopSupporter>[].obs;
  final goals = <TipGoal>[].obs;
  final currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _apiService.fetchSummary(),
        _apiService.fetchHistory(type: 'received'),
        _apiService.fetchHistory(type: 'sent'),
        _apiService.fetchSupporters(),
        _apiService.fetchGoals(),
      ]);
      summary.value = results[0] as TipSummary?;
      receivedHistory.value = results[1] as List<TipTransaction>;
      sentHistory.value = results[2] as List<TipTransaction>;
      supporters.value = results[3] as List<TopSupporter>;
      goals.value = results[4] as List<TipGoal>;
    } catch (_) {
      // Silently handle
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  Future<bool> sendTip({
    required String toUserId,
    required double amount,
    String? message,
    String? postId,
  }) async {
    final success = await _apiService.sendTip(
      toUserId: toUserId,
      amount: amount,
      message: message,
      postId: postId,
    );
    if (success) {
      await loadData(); // Refresh after sending
    }
    return success;
  }

  Future<bool> saveGoal({
    String? id,
    required String title,
    required double targetAmount,
    DateTime? deadline,
  }) async {
    final success = await _apiService.createOrUpdateGoal(
      id: id,
      title: title,
      targetAmount: targetAmount,
      deadline: deadline,
    );
    if (success) {
      goals.value = await _apiService.fetchGoals();
    }
    return success;
  }

  Future<bool> removeGoal(String goalId) async {
    final success = await _apiService.deleteGoal(goalId);
    if (success) {
      goals.removeWhere((g) => g.id == goalId);
    }
    return success;
  }
}
