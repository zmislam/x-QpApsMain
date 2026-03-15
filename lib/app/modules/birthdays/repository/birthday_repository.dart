// =============================================================================
// Birthday Repository — API calls for the Birthdays page
// =============================================================================

import '../../../config/constants/api_constant.dart';
import '../../../models/api_response.dart';
import '../../../services/api_communication.dart';

class BirthdayRepository {
  final ApiCommunication _api = ApiCommunication();

  /// GET /api/birthdays — returns { today, recent, upcoming, counts }
  Future<ApiResponse> getBirthdays() async {
    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'birthdays',
    );
    return response;
  }

  /// POST /api/birthday-post — create a birthday wall post
  Future<ApiResponse> createBirthdayPost({
    required String toUserId,
    required String description,
  }) async {
    final response = await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'birthday-post',
      requestData: {
        'to_user_id': toUserId,
        'description': description,
      },
    );
    return response;
  }
}
