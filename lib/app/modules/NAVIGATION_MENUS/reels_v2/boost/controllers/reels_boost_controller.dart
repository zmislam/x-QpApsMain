import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../models/api_response.dart';
import '../../utils/reel_constants.dart';

/// Controller for the Boost Reel flow.
/// Manages budget, audience, schedule, CTA configuration
/// and submits boost campaigns to the backend.
class ReelsBoostController extends GetxController {
  final ApiCommunication _api = ApiCommunication();

  // ─── Arguments ─────────────────────────────────────────
  String? reelId;
  String? reelThumbnail;
  String? reelCaption;

  // ─── Budget ────────────────────────────────────────────
  final RxDouble dailyBudget = 5.0.obs;
  final RxInt durationDays = 7.obs;
  double get totalBudget => dailyBudget.value * durationDays.value;

  // ─── Audience ──────────────────────────────────────────
  final RxString audienceType = 'automatic'.obs; // automatic, custom
  final RxInt minAge = 18.obs;
  final RxInt maxAge = 65.obs;
  final RxString gender = 'all'.obs; // all, male, female
  final RxList<String> interests = <String>[].obs;
  final RxList<String> locations = <String>[].obs;

  // ─── Schedule ──────────────────────────────────────────
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // ─── CTA ───────────────────────────────────────────────
  final RxString ctaType = 'learn_more'.obs;
  final RxString ctaUrl = ''.obs;

  static const List<Map<String, String>> ctaOptions = [
    {'value': 'learn_more', 'label': 'Learn More'},
    {'value': 'shop_now', 'label': 'Shop Now'},
    {'value': 'sign_up', 'label': 'Sign Up'},
    {'value': 'download', 'label': 'Download'},
    {'value': 'contact_us', 'label': 'Contact Us'},
    {'value': 'book_now', 'label': 'Book Now'},
    {'value': 'watch_more', 'label': 'Watch More'},
  ];

  // ─── Status ────────────────────────────────────────────
  final RxBool isSubmitting = false.obs;
  final RxString boostStatus = 'draft'.obs; // draft, pending, active, paused, completed
  final Rx<Map<String, dynamic>> boostAnalytics = Rx<Map<String, dynamic>>({});

  // ─── Existing Boosts ───────────────────────────────────
  final RxList<Map<String, dynamic>> existingBoosts = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingBoosts = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    reelId = args['reelId'] as String?;
    reelThumbnail = args['thumbnail'] as String?;
    reelCaption = args['caption'] as String?;

    // Auto-compute end date from duration
    ever(durationDays, (_) {
      endDate.value = startDate.value.add(Duration(days: durationDays.value));
    });
    endDate.value = startDate.value.add(Duration(days: durationDays.value));
  }

  /// Submit the boost campaign.
  Future<bool> submitBoost() async {
    if (reelId == null) return false;
    if (ctaUrl.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a destination URL');
      return false;
    }

    isSubmitting.value = true;
    try {
      final response = await _api.doPostRequest(
        apiEndPoint: ReelConstants.boostCreate,
        requestData: {
          'reelId': reelId,
          'budget': {
            'daily': dailyBudget.value,
            'total': totalBudget,
            'currency': 'USD',
          },
          'duration': durationDays.value,
          'audience': {
            'type': audienceType.value,
            if (audienceType.value == 'custom') ...{
              'ageRange': {'min': minAge.value, 'max': maxAge.value},
              'gender': gender.value,
              'interests': interests,
              'locations': locations,
            },
          },
          'schedule': {
            'startDate': startDate.value.toIso8601String(),
            'endDate': endDate.value?.toIso8601String(),
          },
          'cta': {
            'type': ctaType.value,
            'url': ctaUrl.value,
          },
        },
      );

      if (response.isSuccessful) {
        boostStatus.value = 'pending';
        Get.snackbar('Success', 'Boost submitted for review!',
            backgroundColor: Colors.green[700], colorText: Colors.white);
        return true;
      } else {
        Get.snackbar('Error', response.message ?? 'Failed to submit boost');
        return false;
      }
    } catch (e) {
      debugPrint('[BoostCtrl] Error submitting boost: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Load existing boosts for the user's reels.
  Future<void> loadExistingBoosts() async {
    isLoadingBoosts.value = true;
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: ReelConstants.boostList,
      );
      if (response.isSuccessful && response.data != null) {
        final list = response.data is List
            ? response.data as List
            : ((response.data as Map<String, dynamic>)['boosts'] as List?) ?? [];
        existingBoosts.assignAll(
          list.map((e) => e as Map<String, dynamic>).toList(),
        );
      }
    } catch (e) {
      debugPrint('[BoostCtrl] Error loading boosts: $e');
    } finally {
      isLoadingBoosts.value = false;
    }
  }

  /// Load live analytics for an active boost.
  Future<void> loadBoostAnalytics(String boostId) async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: ReelConstants.boostAnalytics(boostId),
      );
      if (response.isSuccessful && response.data != null) {
        boostAnalytics.value = response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[BoostCtrl] Error loading analytics: $e');
    }
  }

  /// Pause / resume a boost.
  Future<bool> toggleBoostStatus(String boostId, String action) async {
    try {
      final response = await _api.doPutRequest(
        apiEndPoint: ReelConstants.boostAction(boostId),
        requestData: {'action': action},
      );
      if (response.isSuccessful) {
        boostStatus.value = action == 'pause' ? 'paused' : 'active';
        return true;
      }
    } catch (e) {
      debugPrint('[BoostCtrl] Error toggling boost: $e');
    }
    return false;
  }
}
