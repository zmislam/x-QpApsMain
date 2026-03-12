import 'package:flutter/material.dart';
import '../../reels/model/reels_model.dart';
import '../../../../models/api_response.dart';
import '../../../../services/api_communication.dart';

class ApiService {
  final ApiCommunication _apiCommunication = ApiCommunication();

  Future<List<ReelsModel>> getReels({required int skip, required int limit}) async {
    try {
      // API call using `_apiCommunication`
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'all-user-reels?limit=$limit&skip=$skip',
        // queryParameters: {
        //   'skip': skip,
        //   'limit': limit,
        // },
        responseDataKey: 'all_reels'
      );

      if (apiResponse.isSuccessful) {
        final data = apiResponse.data as List;
        return data.map((item) => ReelsModel.fromMap(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to fetch reels: ${apiResponse.message}');
      }
    } catch (e) {
      debugPrint('Error in ApiService.getReels: $e');
      return [];
    }
  }
}
