import 'package:get/state_manager.dart';

import '../models/api_response.dart';
import '../models/video_campaign_model.dart';
import '../repository/ads_repository.dart';

class AdsService extends GetxService {
  /*
   * Ads Service for overall application
   */
  static final AdsService _instance = AdsService._internal();
  late AdsRepository _repository;
  List<VideoCampaignModel> videoAdList = [];

  factory AdsService() {
    return _instance;
  }
  AdsService._internal() {
    _repository = AdsRepository();
  }

  Future<void> getVideoAds() async {
    final ApiResponse apiResponse = await _repository.getVideoAds();
    if (apiResponse.isSuccessful) {
      videoAdList = apiResponse.data as List<VideoCampaignModel>;
    }
  }
}
