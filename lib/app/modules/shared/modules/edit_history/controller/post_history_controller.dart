import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/constants/api_constant.dart';
import '../../../../../services/api_communication.dart';

/// Lightweight model for a single edit-history snapshot.
class EditHistoryEntry {
  final String id;
  final String? description;
  final String? postBackgroundColor;
  final List<Map<String, dynamic>> postMedia;
  final String? feelingName;
  final String? feelingLogo;
  final String? activityName;
  final String? locationName;
  final String? postPrivacy;
  final DateTime createdAt;

  EditHistoryEntry({
    required this.id,
    this.description,
    this.postBackgroundColor,
    this.postMedia = const [],
    this.feelingName,
    this.feelingLogo,
    this.activityName,
    this.locationName,
    this.postPrivacy,
    required this.createdAt,
  });

  factory EditHistoryEntry.fromMap(Map<String, dynamic> map) {
    // Parse feeling
    String? feelingName;
    String? feelingLogo;
    if (map['feeling_id'] is Map) {
      feelingName = map['feeling_id']['feelingName'];
      feelingLogo = map['feeling_id']['logo'];
    }

    // Parse activity
    String? activityName;
    if (map['activity_id'] is Map) {
      activityName = map['activity_id']['activityName'];
    }

    // Parse location
    String? locationName = map['location_name'];
    if (locationName == null && map['location_id'] is Map) {
      locationName = map['location_id']['name'];
    }

    // Parse media
    List<Map<String, dynamic>> media = [];
    if (map['post_media'] is List) {
      media = List<Map<String, dynamic>>.from(
        (map['post_media'] as List).map(
            (e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}),
      );
    }

    return EditHistoryEntry(
      id: map['_id'] ?? '',
      description: map['description'],
      postBackgroundColor: map['post_background_color'],
      postMedia: media,
      feelingName: feelingName,
      feelingLogo: feelingLogo,
      activityName: activityName,
      locationName: locationName,
      postPrivacy: map['post_privacy'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class PostHistoryController extends GetxController {
  late ApiCommunication _apiCommunication;

  final entries = <EditHistoryEntry>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  String get postId => Get.arguments?.toString() ?? '';

  @override
  void onInit() {
    super.onInit();
    _apiCommunication = ApiCommunication();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    if (postId.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'No post ID provided';
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final apiResponse = await _apiCommunication.doGetRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'get-post-edit-history/$postId',
        enableLoading: false,
      );

      if (apiResponse.isSuccessful) {
        final results = (apiResponse.data as Map<String, dynamic>)['results'];
        if (results is List) {
          entries.value = results
              .map((e) => EditHistoryEntry.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load edit history';
      }
    } catch (e) {
      debugPrint('EditHistory error: $e');
      hasError.value = true;
      errorMessage.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHistory() => _fetchHistory();

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
