import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../services/api_communication.dart';

class ChatRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET Chat DETAILS                                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getIndividualChatDetails({required String userId}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'chats/c/$userId',
    );
    return apiResponse;
  }
}
