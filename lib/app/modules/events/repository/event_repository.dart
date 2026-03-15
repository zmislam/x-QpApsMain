import '../../../config/constants/api_constant.dart';
import '../../../models/api_response.dart';
import '../../../services/api_communication.dart';

class EventRepository {
  final ApiCommunication _api = ApiCommunication();

  /// Fetch events with tab filter
  Future<ApiResponse> getEvents({
    required String tab,
    String? city,
    int page = 1,
    int limit = 10,
  }) async {
    String query = 'events?tab=$tab&page=$page&limit=$limit';
    if (city != null && city.isNotEmpty) {
      query += '&city=${Uri.encodeComponent(city)}';
    }
    return await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: query,
      enableCache: false,
      enableLoading: false,
    );
  }

  /// Get single event detail
  Future<ApiResponse> getEventById(String eventId) async {
    return await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/$eventId',
      enableCache: false,
      enableLoading: false,
    );
  }

  /// Create event
  Future<ApiResponse> createEvent(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/create',
      requestData: data,
    );
  }

  /// Toggle interested
  Future<ApiResponse> toggleInterested(String eventId) async {
    return await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/interested',
      requestData: {'event_id': eventId},
    );
  }

  /// Toggle going
  Future<ApiResponse> toggleGoing(String eventId) async {
    return await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/going',
      requestData: {'event_id': eventId},
    );
  }

  /// Update event
  Future<ApiResponse> updateEvent(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/update',
      requestData: data,
    );
  }

  /// Delete event
  Future<ApiResponse> deleteEvent(String eventId) async {
    return await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/delete',
      requestData: {'event_id': eventId},
    );
  }

  /// Get my events
  Future<ApiResponse> getMyEvents({int page = 1, int limit = 10}) async {
    return await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'events/my-events?page=$page&limit=$limit',
      enableCache: false,
      enableLoading: false,
    );
  }
}
