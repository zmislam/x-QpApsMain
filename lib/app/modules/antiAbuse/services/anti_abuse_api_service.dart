import '../../../services/api_communication.dart';
import '../models/anti_abuse_models.dart';

class AntiAbuseApiService {
  /// GET /api/anti-abuse/standing — Account risk standing
  Future<AccountStanding?> getAccountStanding() async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'anti-abuse/standing',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is Map) {
      return AccountStanding.fromJson(
          Map<String, dynamic>.from(response.data as Map));
    }
    return null;
  }

  /// POST /api/anti-abuse/appeal — Submit an appeal
  Future<bool> submitAppeal({
    required String reason,
    required String explanation,
    String? evidenceUrl,
  }) async {
    final body = {
      'reason': reason,
      'explanation': explanation,
      if (evidenceUrl != null) 'evidenceUrl': evidenceUrl,
    };
    final response = await ApiCommunication().doPostRequest(
      apiEndPoint: 'anti-abuse/appeal',
      requestData: body,
      responseDataKey: 'data',
    );
    return response.isSuccessful;
  }

  /// POST /api/anti-abuse/check-duplicate — Check duplicate content
  Future<DuplicateCheckResult> checkDuplicate(String content) async {
    final response = await ApiCommunication().doPostRequest(
      apiEndPoint: 'anti-abuse/check-duplicate',
      requestData: {'content': content},
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is Map) {
      return DuplicateCheckResult.fromJson(
          Map<String, dynamic>.from(response.data as Map));
    }
    return DuplicateCheckResult();
  }
}
