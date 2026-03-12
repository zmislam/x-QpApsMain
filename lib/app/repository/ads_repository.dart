import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/ads_management_models/campaign_model.dart';
import '../models/ads_management_models/campaign_status_model.dart';
import '../utils/snackbar.dart';

import '../config/constants/api_constant.dart';
import '../config/constants/data_const.dart';
import '../models/api_response.dart';
import '../models/video_campaign_model.dart';
import '../services/api_communication.dart';

class AdsRepository {
  /*
   * Ads Repository for overall application
   */
  final ApiCommunication _apiCommunication = ApiCommunication();
  List<VideoCampaignModel> videoAdsList = [];

  Future<ApiResponse> getVideoAds() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'campaign/get-video-ads',
    );

    if (apiResponse.isSuccessful) {
      videoAdsList =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => VideoCampaignModel.fromJson(element))
              .toList();
      ApiResponse apiResponseToPass = apiResponse.copyWith(data: videoAdsList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃   GET ALL CAMPAIGNS                                                   ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllCampaigns(
      {String? campaignName,
      String? status,
      DateTime? startDate,
      DateTime? endDate}) async {
    final Map<String, dynamic> filters = {
      'campaign_name': campaignName,
      'status': status,
      'from': startDate?.toIso8601String(),
      'to': endDate?.toIso8601String(),
    };

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: 'campaign',
      apiEndPoint: 'campaign/list',
      requestData: filters,
    );

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
          data: (apiResponse.data as List)
              .map((e) => CampaignModel.fromJson(e))
              .toList());
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  CREATE NEW CAMPAIGN                                                  ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> createNewCampaign({
    required CampaignModel campaignModel,
    required List<String> files,
  }) async {
    debugPrint('🟢 createNewCampaign() called');
    debugPrint('➡️ Endpoint: campaign/save');
    debugPrint('🧾 Request Data: ${campaignModel.toJson()}');
    debugPrint('📁 Processed Files: $files');

    final apiResponse = await _apiCommunication.doPostRequestNew(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'campaign/save',
      processedFileNames: files,
      requestData: campaignModel.toJson(),
      fileKey: 'images',
      enableLoading: true,
    );

    debugPrint('📨 Raw API Response Object: $apiResponse');
    debugPrint('✅ Success: ${apiResponse.isSuccessful}');
    debugPrint('💬 Message: ${apiResponse.message}');
    debugPrint('📦 Data: ${apiResponse.data}');
    debugPrint('🔢 Status Code: ${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(
        message: apiResponse.message ?? 'Campaign created Successfully',
      );
    } else {
      showErrorSnackkbar(
        message: apiResponse.message ?? 'Failed to create campaign',
      );
    }

    return apiResponse;
  }


  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  EDIT CAMPAIGN                                                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> editCampaign(
      {required CampaignModel campaignModel, required List<String> files}) async {
    final apiResponse = await _apiCommunication.doPostRequestNew(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      processedFileNames: files,
      apiEndPoint: 'campaign/edit/${campaignModel.id}',
      requestData: campaignModel.toJson(),
      fileKey: files.isNotEmpty ? 'images' : null,
      enableLoading: true,
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(
          message: apiResponse.message ?? 'Campaign Edited Successfully');
      return apiResponse;
    } else {
      showErrorSnackkbar(
          message: apiResponse.message ?? 'Failed to update, Please try again');
      return apiResponse;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SAVE CAMPAIGN SUBSCRIPTION                                           ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> saveCampaignSubscription({
    String? campaignId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalBudget,
    double? dailyBudget,
    String? websiteUrl,
    String? gender,
    String? ageGroup,
    List<String>? locations,
    List<String>? keywords,
    String? adsPlacement,
    int? fromAge,
    int? toAge,
  }) async {
    final requestData = {
      'campaign_id': campaignId,
      'start_date': startDate!.toIso8601String(),
      'end_date': endDate!.toIso8601String(),
      'total_budget': totalBudget,
      'daily_budget': dailyBudget,
      'website_url': websiteUrl,
      'gender': gender,
      'age_group': ageGroup,
      'locations': locations,
      'keywords': keywords,
      'ads_placement': adsPlacement,
    };

    if (ageGroup.toString().compareTo(ageSelection.last) == 0) {
      requestData.addAll({
        'from_age': fromAge,
        'to_age': toAge,
      });
    }

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'campaign/save-subscription',
      requestData: requestData,
      enableLoading: true,
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(
          message: apiResponse.message ??
              'Campaign Subscription Saved Successfully');
      return apiResponse;
    } else {
      showErrorSnackkbar(
          message: apiResponse.message ??
              'Failed to save subscription, Please try again');
      return apiResponse;
    }
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  DELETE CAMPAIGN WITH ID                                              ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteCampaign({required String id}) async {
    final apiResponse = await _apiCommunication.doDeleteRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'campaign/delete/$id',
      enableLoading: true,
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(
          message: apiResponse.message ?? 'Campaign Deleted Successfully');
      return apiResponse;
    } else {
      showErrorSnackkbar(
          message: apiResponse.message ?? 'Failed to delete, Please try again');
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃   GET ALL ADs CAMPAIGN STATUS                                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllCampaignStatus() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'result',
      apiEndPoint: 'campaign/status-list',
      // # ENABLE CACHE IF NEEDED
      // enableCache: true,
      // // @ STORE DATA FOR 10 DAYS
      // timeToLiveInSeconds: 60 * 60 * 24 * 10,
    );

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
        data: (apiResponse.data as List)
            .map(
              (e) => CampaignStatusModel.fromJson(e),
            )
            .toList(),
      );
    } else {
      return apiResponse;
    }
  }
}
