import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../models/api_response.dart';
import '../../../../../services/api_communication.dart';
import '../models/imageCheckerModel.dart';

class ImageCheckerService {
  static Future<ImageCheckerModel?> checkImageForVulgarity(XFile file) async {
    try {
      final ApiCommunication api = ApiCommunication();
      ApiResponse response = await api.doPostRequest(
        apiEndPoint: 'image-checker',
        mediaXFiles: [file],
        isFormData: true,
        fileKey: 'file',
        enableLoading: false,
        responseDataKey: ApiConstant.FULL_RESPONSE, // ✅ Get full response
      );

      debugPrint('Raw API Response: ${response.toString()}');
      debugPrint('Response data type: ${response.data.runtimeType}');
      debugPrint('Response data: ${response.data}');

      // Check if API call was successful
      if (!response.isSuccessful || response.data == null) {
        debugPrint('❌ API call failed or returned null');
        return null;
      }

      // Response data should be a Map containing message, data, and sexual
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap = response.data as Map<String, dynamic>;

        final checkerModel = ImageCheckerModel.fromJson(responseMap);

        debugPrint('✅ Parsed response - sexual: ${checkerModel.sexual}, data: ${checkerModel.data}');

        return checkerModel;
      } else {
        debugPrint('❌ Unexpected response format: ${response.data.runtimeType}');
        return null;
      }

    } catch (e, stackTrace) {
      debugPrint('❌ Image checker exception: $e');
      debugPrint('StackTrace: $stackTrace');
      return null;
    }
  }

  static Future<ImageCheckerModel?> checkVideoForVulgarity(XFile file) async {
    try {
      final ApiCommunication api = ApiCommunication();
      ApiResponse response = await api.doPostRequest(
        apiEndPoint: 'image-checker',
        mediaXFiles: [file],
        isFormData: true,
        fileKey: 'file',
        enableLoading: false,
        responseDataKey: ApiConstant.FULL_RESPONSE, // ✅ Get full response
      );

      debugPrint('Raw API Response: ${response.toString()}');
      debugPrint('Response data type: ${response.data.runtimeType}');
      debugPrint('Response data: ${response.data}');

      // Check if API call was successful
      if (!response.isSuccessful || response.data == null) {
        debugPrint('❌ API call failed or returned null');
        return null;
      }

      // Response data should be a Map containing message, data, and sexual
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap = response.data as Map<String, dynamic>;

        final checkerModel = ImageCheckerModel.fromJson(responseMap);

        debugPrint('✅ Parsed response - sexual: ${checkerModel.sexual}, data: ${checkerModel.data}');

        return checkerModel;
      } else {
        debugPrint('❌ Unexpected response format: ${response.data.runtimeType}');
        return null;
      }

    } catch (e, stackTrace) {
      debugPrint('❌ Video checker exception: $e');
      debugPrint('StackTrace: $stackTrace');
      return null;
    }
  }
}
