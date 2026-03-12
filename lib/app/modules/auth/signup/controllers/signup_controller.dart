import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../enum/singing_character.dart';
import '../../../../models/api_response.dart';
import '../../../../models/gender.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/snackbar.dart';
import '../../../shared/modules/create_post/models/imageCheckerModel.dart';
import '../../../shared/modules/create_post/service/imageCheckerService.dart';

class SignupController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController passwordController;
  Rx<bool> obscureText = true.obs;

  final GlobalKey<FormState> nameFormKey = GlobalKey();
  final GlobalKey<FormState> emailFormKey = GlobalKey();
  final GlobalKey<FormState> otpFormKey = GlobalKey();
  final GlobalKey<FormState> mobileFormKey = GlobalKey();
  final GlobalKey<FormState> passwordFormKey = GlobalKey();

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<File?> selectedProfileImage = Rx<File?>(null);
  Rx<String?> processedProfileImageName = Rx<String?>(null);
  Rx<double> year = 0.0.obs;
  var otp = ''.obs;
  var remainingSeconds = 60.obs;
  var resendEnabled = true.obs;
  Timer? timer;
  String? newEmail;

  Rx<List<GenderModel>> genderList = Rx([]);
  XFile? xFile;

  Rx<Gender> character = Gender.Male.obs;
  Rx<GenderModel?> selectedGender = Rx(null);
  Rx<bool> agreeToTermsAndCondition = false.obs;

  void verifyOtp(String otp) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'otp-verification',
      requestData: {'email': emailController.text, 'otp': otp},
    );

    if (otp.isEmpty) {
      showErrorSnackkbar(message: 'Please Provide your OTP'.tr);
    } else if (apiResponse.isSuccessful) {
      Get.toNamed(Routes.PASSWORD);
      showSuccessSnackkbar(message: '${apiResponse.message}');
    } else {
      showErrorSnackkbar(message: '${apiResponse.message}');
    }
  }

  bool validateAge() {
    if (selectedDate.value.year - DateTime.now().year < 13) {
      return false;
    } else {
      return true;
    }
  }

  void onTapPickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final ImageCheckerModel? checkerResponse =
          await ImageCheckerService.checkImageForVulgarity(pickedFile);

      if (checkerResponse != null) {
        if (checkerResponse.sexual == true) {
          showErrorSnackkbar(
              message:
                  'This image contains inappropriate content and cannot be used as profile picture'.tr);
          return;
        } else {
          selectedProfileImage.value = File(pickedFile.path);
          processedProfileImageName.value = checkerResponse.data;
          debugPrint('✅ Original file path: ${pickedFile.path}');
          debugPrint('✅ Processed filename: ${checkerResponse.data}');
          showSuccessSnackkbar(message: 'Profile image selected successfully'.tr);
        }
      } else {
        showErrorSnackkbar(
            message:
                'Unable to verify image content. Please try again or choose a different image.'.tr);
        debugPrint('❌ Profile image rejected - API verification failed');
        return;
      }
    }
  }

  void removeProfileImage() {
    selectedProfileImage.value = null;
  }

  String? validateProfilePic() {
    if (selectedProfileImage.value == null) {
      return 'Profile Pic cannot be empty'.tr;
    }
    return null;
  }

  void sendOtp() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'email-verification',
      requestData: {
        'email': emailController.text,
      },
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: '${apiResponse.message}');
    } else {
      showErrorSnackkbar(message: '${apiResponse.message}');
    }
  }

  void startOtpResendTimer() {
    remainingSeconds.value = 120;
    resendEnabled.value = false;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 120), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        resendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp(String email) {
    debugPrint('${'Resending OTP to email'.tr}: $email');
    startOtpResendTimer();
  }

  void onSelectDate(DateTime dateTime) {
    selectedDate.value = dateTime;
    Duration difference = DateTime.now().difference(selectedDate.value);
    year.value = difference.inDays / 365;
  }

  void getGenders() async {
    final ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'gender',
      responseDataKey: 'allGender',
    );
    if (apiResponse.isSuccessful) {
      genderList.value = (apiResponse.data as List)
          .map((element) => GenderModel.fromMap(element))
          .toList();
    } else {}
  }

  void onClickNextFromGender() {
    if (selectedGender.value == null) {
      showWarningSnackkbar(message: 'Please select gender first'.tr);
    } else {
      Get.toNamed(Routes.NUMBER);
    }
  }

  void signUp() async {
    if (!agreeToTermsAndCondition.value) {
      showErrorSnackkbar(
        message: 'To use this app you must agree to the Privacy Policy'.tr,
      );
      return;
    }

    if (passwordFormKey.currentState!.validate()) {
      // Build the request data map
      Map<String, dynamic> requestData = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'otp': otp.value,
        'password': passwordController.text,
        'phone': mobileController.text,
        'gender': selectedGender.value?.id,
        'day': selectedDate.value.day.toString(),
        'month': selectedDate.value.month.toString(),
        'year': selectedDate.value.year.toString(),
        'user_role': '1',
        'isAccept': 'true',
      };

      if (processedProfileImageName.value != null &&
          processedProfileImageName.value!.isNotEmpty) {
        requestData['profile_pic'] = processedProfileImageName.value!;
      }

      final ApiResponse apiResponse = await _apiCommunication.newDoPostRequest(
        apiEndPoint: 'signup',
        isFormData: false,
        requestData: requestData,
      );

      if (apiResponse.isSuccessful) {
        await autoLoginAfterSignup();
      } else {
        showErrorSnackkbar(
            message: apiResponse.message ?? 'Registration failed'.tr);
      }
    }
  }

  Future autoLoginAfterSignup() async {
    try {
      final ApiResponse loginResponse = await _apiCommunication.doPostRequest(
        enableLoading: true,
        apiEndPoint: 'login',
        requestData: {
          'email': emailController.text.toLowerCase(),
          'password': passwordController.text,
        },
        isFormData: false,
        responseDataKey: ApiConstant.FULL_RESPONSE, // ✅ use same constant
      );

      if (loginResponse.isSuccessful && loginResponse.statusCode == 200) {
        showSuccessSnackkbar(
            message: 'Registration successful! Welcome to the app'.tr);

        /// ✅ safely cast the response
        final data = loginResponse.data;
        if (data is Map<String, dynamic>) {
          _loginCredential.handleLoginCredential(data);

          await getDeviceInfo();

          /// ✅ Navigate to Home
          Get.offAllNamed(Routes.TAB);
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        showWarningSnackkbar(
          message: 'Registration successful. Please login to continue'.tr,
        );
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      debugPrint('Auto-login error: $e');
      showWarningSnackkbar(
        message: 'Registration successful. Please login to continue'.tr,
      );
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('=========== get token: $token ==========');

    Map<String, dynamic> requestData = {
      'fcm_token': token,
    };

    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      requestData['device_id'] = androidInfo.id;
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      requestData['device_id'] = iosInfo.identifierForVendor;
    } else {
      requestData['device_id'] = "unsupported_platform";
    }

    ApiResponse response = await ApiCommunication()
        .doPostRequest(apiEndPoint: 'manage-token', requestData: requestData);

    if (response.isSuccessful) {
      debugPrint('Device info & token sent successfully ✅');
    } else {
      debugPrint('Failed to send device info ❌');
    }
  }

  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    passwordController = TextEditingController();
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    onSelectDate(DateTime(2000, 01, 01));
    super.onInit();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    _apiCommunication.endConnection();
    super.onClose();
  }
}
