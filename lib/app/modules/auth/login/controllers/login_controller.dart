import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quantum_possibilities_flutter/app/utils/logger/logger.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/api_response.dart';
import '../../../../models/profile_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/Localization/lib/app/modules/changeLanguage/controllers/languageController.dart';
import '../../../../utils/snackbar.dart';

class LoginController extends GetxController {
  late final TextEditingController userIdController;
  late final TextEditingController passwordController;
  Rx<bool> obscureText = true.obs;
  final GlobalKey<FormState> loginFormKey = GlobalKey();
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  void onPressedLogin() async {
    debugPrint(
        '--Log in response starting point-----------------------------------');
    String userId = userIdController.text.toLowerCase();
    String password = passwordController.text;

    if (loginFormKey.currentState!.validate()) {
      final ApiResponse response = await _apiCommunication.doPostRequest(
        enableLoading: true,
        apiEndPoint: 'login',
        requestData: {
          'email': userId,
          'password': password,
        },
        isFormData: false,
        responseDataKey: ApiConstant.FULL_RESPONSE,
      );
      if (response.isSuccessful && response.statusCode == 200) {
        showSuccessSnackkbar(message: 'You are successfully logged in'.tr);
        Map<String, dynamic> fullResponse =
            response.data as Map<String, dynamic>;
        debugPrint(fullResponse.toString());
        _loginCredential.handleLoginCredential(fullResponse);
        await getDeviceInfo();
        Get.offAllNamed(Routes.TAB);
      } else {
        showErrorSnackkbar(message: response.message ?? 'Login error'.tr);
      }
    }
  }

  Future<void> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String? apnsToken;
    String? fcmToken;

    try {
      if (Platform.isIOS) {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        final Duration apnsTimeout = const Duration(seconds: 6);
        final Duration pollInterval = const Duration(milliseconds: 500);
        final DateTime start = DateTime.now();

        while (DateTime.now().difference(start) < apnsTimeout) {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null && apnsToken.isNotEmpty) break;
          await Future.delayed(pollInterval);
        }
      }

      // Try to obtain the FCM token (may throw if APNs is required and not ready)
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        // If getToken throws because APNs not ready, log and try a short retry once more
        try {
          await Future.delayed(const Duration(seconds: 1));
          fcmToken = await FirebaseMessaging.instance.getToken();
        } catch (_) {
          fcmToken = null;
        }
      }
    } catch (e) {
      // Any unexpected error while obtaining tokens — proceed with what we have
      fcmToken = fcmToken;
      apnsToken = apnsToken;
    }

    final Map<String, dynamic> requestData = <String, dynamic>{};
    requestData['fcm_token'] = fcmToken;
    if (apnsToken != null && apnsToken.isNotEmpty) {
      requestData['apns_token'] = apnsToken;
    }

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      requestData['device_id'] = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      requestData['device_id'] = iosInfo.identifierForVendor;
    } else {
      requestData['device_id'] = 'unsupported_platform';
    }

    final response = await ApiCommunication()
        .doPostRequest(apiEndPoint: 'manage-token', requestData: requestData);

    if (response.isSuccessful) {
      debugPrint('Device info & token sent successfully ✅');
    } else {
      debugPrint('Failed to send device info ❌');
    }
  }


  @override
  void onInit() {
    super.onInit();
    final languageController = Get.find<LanguageController>();
    debugPrint(
        'Current language on screen: ${languageController.getCurrentLanguageCode()}');
    userIdController = TextEditingController();
    passwordController = TextEditingController();
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
  }

  @override
  void onClose() {
    super.onClose();
    userIdController.dispose();
    passwordController.dispose();
    _apiCommunication.endConnection();
  }
}
