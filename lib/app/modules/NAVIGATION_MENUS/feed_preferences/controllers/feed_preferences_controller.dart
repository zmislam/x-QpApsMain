import 'package:get/get.dart';
import '../../../../repository/edgerank_repository.dart';

class FeedPreferencesController extends GetxController {
  final EdgeRankRepository _edgeRankRepo = Get.find<EdgeRankRepository>();

  // Observable values for sliders (0.0 to 1.0)
  final RxDouble viralScore = 0.5.obs;
  final RxDouble freshnessScore = 0.5.obs;
  final RxDouble friendsFamilyScore = 0.5.obs;
  final RxDouble discoveryScore = 0.5.obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    isLoading.value = true;
    try {
      // TODO: Fetch existing preferences from API
      // For now, simulate a delay and use defaults or mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data
      viralScore.value = 0.3;
      freshnessScore.value = 0.8;
      friendsFamilyScore.value = 0.6;
      discoveryScore.value = 0.4;
    } catch (e) {
      print('Error loading feed preferences: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePreferences() async {
    isLoading.value = true;
    try {
      // TODO: Send updated preferences to API
      // Map<String, dynamic> prefs = {
      //   'viral_score': viralScore.value,
      //   'freshness_score': freshnessScore.value,
      //   'friends_family_score': friendsFamilyScore.value,
      //   'discovery_score': discoveryScore.value,
      // };
      // await _edgeRankRepo.updateFeedPreferences(prefs);
      
      await Future.delayed(const Duration(milliseconds: 1000));
      
      Get.back();
      Get.snackbar(
        'Success',
        'Feed preferences updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update preferences',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetToDefault() {
    viralScore.value = 0.5;
    freshnessScore.value = 0.5;
    friendsFamilyScore.value = 0.5;
    discoveryScore.value = 0.5;
  }
}
