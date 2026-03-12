import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/api_response.dart';
import '../../../../services/api_communication.dart';

class ForgetpassProvider extends GetConnect {
  final ApiCommunication _apiCommunication = ApiCommunication();

  @override
  void onInit() {}

//================================= Send OTP ===================================//
  Future<dynamic> sendOtp({
    required String email,
  }) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'send-otp', requestData: {
      'email': email,
    });

    try {
      if (apiResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//================================= Verify OTP ===================================//

  Future<dynamic> verifyOtp({
    required String email,
    required String number1,
    required String number2,
    required String number3,
    required String number4,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'verify-otp',
        requestData: {
          'email': email,
          'otp': number1 + number2 + number3 + number4
        });

    try {
      if (apiResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//================================= Reset Password ===================================//

  Future<dynamic> resetPassword({
    required String email,
    required String password,
    required String newPassword,
  }) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'reset-password', requestData: {
      'email': email,
      'password': password,
      'new_password': newPassword,
    });

    try {
      if (apiResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
