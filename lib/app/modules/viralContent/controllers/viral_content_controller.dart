import 'package:get/get.dart';
import '../../../modules/earnDashboard/services/earning_config_service.dart';
import '../models/viral_content_models.dart';
import '../services/viral_api_service.dart';

class ViralContentController extends GetxController {
  final _apiService = ViralApiService();
  late final EarningConfigService _configService;

  // State
  final isLoading = true.obs;
  final trendingPosts = <TrendingPost>[].obs;
  final myViralPosts = Rxn<MyViralPostsResponse>();
  final sortBy = 'score'.obs;

  // Config-driven
  bool get viralEnabled {
    try {
      return _configService.viralEnabled;
    } catch (_) {
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _configService = Get.find<EarningConfigService>();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _apiService.fetchTrending(sortBy: sortBy.value),
        _apiService.fetchMyViralPosts(),
      ]);
      trendingPosts.value = results[0] as List<TrendingPost>;
      myViralPosts.value = results[1] as MyViralPostsResponse;
    } catch (_) {
      // Silently handle — empty lists shown
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  void changeSortBy(String value) {
    sortBy.value = value;
    _apiService.fetchTrending(sortBy: value).then((posts) {
      trendingPosts.value = posts;
    });
  }

  Future<ViralScoreBreakdown?> getScoreBreakdown(String postId) {
    return _apiService.fetchScoreBreakdown(postId);
  }
}
