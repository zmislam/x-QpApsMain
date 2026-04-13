import '../services/api_communication.dart';
import '../models/api_response.dart';
import '../config/constants/api_constant.dart';

/// Repository for marketplace inbox/messaging API calls.
/// Endpoints prefixed with `market-place/inbox`.
class MarketplaceInboxRepository {
  final ApiCommunication _api = ApiCommunication();

  /// Fetch inbox conversations with optional tab filter.
  /// [tab] — "all", "buying", or "selling"
  Future<ApiResponse> getConversations({
    String tab = 'all',
    String? label,
    int page = 1,
    int limit = 20,
  }) async {
    final Map<String, dynamic> params = {
      'tab': tab,
      'page': page,
      'limit': limit,
    };
    if (label != null && label.isNotEmpty) params['label'] = label;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/inbox',
      queryParameters: params,
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
  }

  /// Fetch conversation detail (messages).
  Future<ApiResponse> getConversationDetail({
    required String conversationId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/inbox/$conversationId',
      responseDataKey: 'data',
    );
  }

  /// Send a reply in a conversation.
  Future<ApiResponse> sendReply({
    required String conversationId,
    required String message,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/inbox/$conversationId/reply',
      requestData: {'message': message},
    );
  }
}
