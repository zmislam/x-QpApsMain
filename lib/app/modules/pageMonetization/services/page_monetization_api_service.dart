import 'package:quantum_possibilities_flutter/app/services/api_communication.dart';
import 'package:quantum_possibilities_flutter/app/models/api_response.dart';

class PageMonetizationApiService {
  final ApiCommunication _api = ApiCommunication();

  /// Check page eligibility for monetization
  Future<ApiResponse> checkEligibility(String pageId) {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/eligibility/$pageId',
      responseDataKey: 'data',
    );
  }

  /// Submit monetization application
  Future<ApiResponse> applyForMonetization(String pageId) {
    return _api.doPostRequest(
      apiEndPoint: 'page-monetization/apply/$pageId',
      requestData: {},
      responseDataKey: 'data',
    );
  }

  /// Get monetization status for a page
  Future<ApiResponse> getStatus(String pageId) {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/status/$pageId',
      responseDataKey: 'data',
    );
  }

  /// List all user's pages with monetization status
  Future<ApiResponse> getMyPages() {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/my-pages',
      responseDataKey: 'data',
    );
  }

  /// Get tier info for a page
  Future<ApiResponse> getTierInfo(String pageId) {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/tier/$pageId',
      responseDataKey: 'data',
    );
  }

  /// Get tier history for a page
  Future<ApiResponse> getTierHistory(String pageId) {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/tier-history/$pageId',
      responseDataKey: 'data',
    );
  }

  /// Get viral content list for a page
  Future<ApiResponse> getViralContent(String pageId) {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/viral/$pageId',
      responseDataKey: 'data',
    );
  }

  /// Get risk profile for a page
  Future<ApiResponse> getRiskProfile(String pageId) {
    return _api.doGetRequest(
      apiEndPoint: 'page-monetization/risk/$pageId',
      responseDataKey: 'data',
    );
  }
}
