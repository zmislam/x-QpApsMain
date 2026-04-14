import '../../../services/api_communication.dart';
import '../models/tipping_models.dart';

class TippingApiService {
  /// POST /api/tips/send — Send a tip
  Future<bool> sendTip({
    required String toUserId,
    required double amount,
    String? message,
    String? postId,
  }) async {
    final body = {
      'toUserId': toUserId,
      'amount': amount,
      if (message != null) 'message': message,
      if (postId != null) 'postId': postId,
    };
    final response = await ApiCommunication().doPostRequest(
      apiEndPoint: 'tips/send',
      requestData: body,
      responseDataKey: 'data',
    );
    return response.isSuccessful;
  }

  /// GET /api/tips/history — Tip history
  Future<List<TipTransaction>> fetchHistory({String type = 'received'}) async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'tips/history?type=$type',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is List) {
      return (response.data as List)
          .map((e) => TipTransaction.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET /api/tips/summary — Overview
  Future<TipSummary?> fetchSummary() async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'tips/summary',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is Map) {
      return TipSummary.fromJson(Map<String, dynamic>.from(response.data as Map));
    }
    return null;
  }

  /// GET /api/tips/supporters — Top supporters
  Future<List<TopSupporter>> fetchSupporters() async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'tips/supporters',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is List) {
      return (response.data as List)
          .map((e) => TopSupporter.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET /api/tips/goals — Active tip goals
  Future<List<TipGoal>> fetchGoals() async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'tips/goals',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is List) {
      return (response.data as List)
          .map((e) => TipGoal.fromJson(e))
          .toList();
    }
    return [];
  }

  /// POST /api/tips/goals — Create/update tip goal
  Future<bool> createOrUpdateGoal({
    String? id,
    required String title,
    required double targetAmount,
    DateTime? deadline,
  }) async {
    final body = {
      if (id != null) 'id': id,
      'title': title,
      'targetAmount': targetAmount,
      if (deadline != null) 'deadline': deadline.toIso8601String(),
    };
    final response = await ApiCommunication().doPostRequest(
      apiEndPoint: 'tips/goals',
      requestData: body,
      responseDataKey: 'data',
    );
    return response.isSuccessful;
  }

  /// DELETE /api/tips/goals/:id — Remove tip goal
  Future<bool> deleteGoal(String goalId) async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'tips/goals/$goalId/delete',
      responseDataKey: 'data',
    );
    return response.isSuccessful;
  }
}
