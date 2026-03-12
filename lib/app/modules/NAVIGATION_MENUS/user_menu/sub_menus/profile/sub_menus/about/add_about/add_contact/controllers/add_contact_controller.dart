import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../utils/snackbar.dart';
import '../../../../../../../../../../models/email_list_model.dart';
import '../../../../../../../../../../models/phone_list_model.dart';
import '../../../../../../../../../../models/profile_model.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';

class AddContactController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController phoneEmailNameController;
  AboutController aboutcontroller = Get.find();
  RxString contactDropdownalue = 'Email'.obs;
  bool isEditing = false;
  var otp = ''.obs; // To store the entered OTP
  var remainingSeconds = 60.obs; // For countdown timer
  var resendEnabled = true.obs; // To enable/disable resend button
  Timer? timer;
  final GlobalKey<FormState> emailFormKey = GlobalKey();
  final GlobalKey<FormState> otpFormKey = GlobalKey();
  AboutController aboutController = Get.find();

  PrivacySearchModel? privacyModel;

  PhoneListModel? phoneListModel;
  EmailListModel? emailListModel;
  Rx<ProfileModel?> profileModel = Rx(null);

/*=============== ADD Contact API=====================*/
  Future<void> onTapAddContactPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'settings-privacy/add-phone-email-language',
      isFormData: false,
      enableLoading: true,
      requestData: {
        contactDropdownalue.value.toLowerCase(): phoneEmailNameController.text,
        'otp': otp.value
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  /*=============== Edit Contact API=====================*/
  Future<void> onTapEditContactPacth({String? Id}) async {
    final String privacyKey = getPrivacyKey();
    final String idKey = getIdKey();
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'settings-privacy/edit-phone-email-language',
      isFormData: false,
      enableLoading: true,
      requestData: {
        contactDropdownalue.value.toLowerCase(): phoneEmailNameController.text,
        privacyKey: privacyModel?.privacy ?? 'public',
        idKey: getIdNumber()
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  String getPrivacyKey() {
    switch (contactDropdownalue.value) {
      case 'Phone':
        return 'phone_privacy';
      case 'Email':
        return 'email_privacy';
      default:
        return '';
    }
  }

  String getIdNumber() {
    switch (contactDropdownalue.value) {
      case 'Phone':
        return '${phoneListModel?.id}';
      case 'Email':
        return '${emailListModel?.id}';
      default:
        return '';
    }
  }

  String getIdKey() {
    switch (contactDropdownalue.value) {
      case 'Phone':
        return 'phone_id';
      case 'Email':
        return 'email_id';
      default:
        return '';
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

  void setSelectedDropdownValue(String value) {
    contactDropdownalue.value = value;

    isEditing = emailListModel?.email != null || phoneListModel?.phone != null;

    if (isEditing) {
      if (value == 'Email') {
        phoneEmailNameController.text = emailListModel?.email ?? '';
        privacyModel = getPrivacyModel(emailListModel?.privacy ?? 'public');
      } else {
        phoneEmailNameController.text = phoneListModel?.phone ?? '';

        privacyModel = getPrivacyModel(phoneListModel?.privacy ?? 'public');
      }
    }
  }

  void sendOtp() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'email-verification',
      requestData: {
        'email': phoneEmailNameController.text,
      },
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: '${apiResponse.message}');
    } else {
      showErrorSnackkbar(message: '${apiResponse.message}');
    }
  }

  // Method to verify OTP
  void verifyOtp(String otp) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'otp-verification',
      requestData: {'email': phoneEmailNameController.text, 'otp': otp},
    );

    if (otp.isEmpty) {
      showErrorSnackkbar(message: 'Please Provide your OTP'.tr);
    } else if (apiResponse.isSuccessful) {
      // Get.toNamed(Routes.PASSWORD);
      onTapAddContactPost();
      //  Get.back();
      Get.back();
      showSuccessSnackkbar(message: '${apiResponse.message}');
    } else {
      showErrorSnackkbar(message: '${apiResponse.message}');
    }
  }

  PrivacySearchModel getPrivacyModel(String privacy) {
    switch (privacy) {
      case 'public':
        return PrivacySearchModel(id: '1', privacy: 'public');
      case 'friends':
        return PrivacySearchModel(id: '2', privacy: 'friends');
      case 'only_me':
        return PrivacySearchModel(id: '3', privacy: 'only_me');
      default:
        return PrivacySearchModel(id: '1', privacy: 'public');
    }
  }

  void showValidationMessage() {
    Get.snackbar(
      'Validation Error'.tr,
      'Please enter a toDate value before unchecking the box.'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  String getPrivacyDescription(String privacy) {
    switch (privacy) {
      case 'public':
        return 'public';
      case 'friends':
        return 'friends';
      case 'only_me':
        return 'only me';
      default:
        return 'public';
    }
  }

  Future<List<PrivacySearchModel>> getData(String filter) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, dynamic>> jsonData = [
      {
        'id': '1',
        'privacy': 'public',
      },
      {
        'id': '2',
        'privacy': 'friends',
      },
      {
        'id': '3',
        'privacy': 'only_me',
      },
    ];

    // Filtering the data based on the filter
    List<PrivacySearchModel>? filteredData =
        PrivacySearchModel.fromJsonList(jsonData)?.where((model) {
      return model.privacy?.toLowerCase().contains(filter.toLowerCase()) ??
          false;
    }).toList();

    return filteredData ?? List.empty();
  }

  Icon getIconForPrivacy(bool isPrivacySelected, String privacy) {
    isPrivacySelected = false;
    switch (privacy) {
      case 'public':
        return const Icon(Icons.public, color: PRIMARY_COLOR);
      case 'friends':
        return const Icon(Icons.group, color: PRIMARY_COLOR);
      case 'only_me':
        return const Icon(Icons.lock, color: PRIMARY_COLOR);
      default:
        return const Icon(Icons.help_outline);
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();

    phoneEmailNameController = TextEditingController();
    userModel = _loginCredential.getUserData();
    setSelectedDropdownValue(contactDropdownalue.value);
    getPrivacyDescription(privacyModel?.privacy.toString() ?? '');
    Map<String, dynamic>? arguments = Get.arguments;
    int? id = arguments?['id'];

    if (id == 2) {
      emailListModel = arguments?['model'];
      setSelectedDropdownValue('Email');
    } else if (id == 1) {
      phoneListModel = arguments?['model'];
      setSelectedDropdownValue('Phone');
    }
    super.onInit();
  }

  @override
  void onReady() {
    aboutController;
    super.onReady();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
