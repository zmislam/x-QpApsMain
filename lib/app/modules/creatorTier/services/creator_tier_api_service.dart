import 'package:quantum_possibilities_flutter/app/services/api_communication.dart';
import 'package:quantum_possibilities_flutter/app/models/api_response.dart';

class CreatorTierApiService {
  final ApiCommunication _api = ApiCommunication();

  /// Get current tier info + dimensions
  Future<ApiResponse> getMyTier() {
    return _api.doGetRequest(
      apiEndPoint: 'creator/my-tier',
      responseDataKey: 'data',
    );
  }

  /// Check creator eligibility
  Future<ApiResponse> checkEligibility() {
    return _api.doGetRequest(
      apiEndPoint: 'creator/eligibility',
      responseDataKey: 'data',
    );
  }

  /// Apply for creator program
  Future<ApiResponse> apply() {
    return _api.doPostRequest(
      apiEndPoint: 'creator/apply',
      requestBody: {},
      responseDataKey: 'data',
    );
  }

  /// Get application status
  Future<ApiResponse> getApplicationStatus() {
    return _api.doGetRequest(
      apiEndPoint: 'creator/application-status',
      responseDataKey: 'data',
    );
  }

  /// Get detailed priority score breakdown
  Future<ApiResponse> getPriorityScore() {
    return _api.doGetRequest(
      apiEndPoint: 'creator/priority-score',
      responseDataKey: 'data',
    );
  }

  /// Get tier change history
  Future<ApiResponse> getTierHistory() {
    return _api.doGetRequest(
      apiEndPoint: 'creator/tier-history',
      responseDataKey: 'data',
    );
  }
}
