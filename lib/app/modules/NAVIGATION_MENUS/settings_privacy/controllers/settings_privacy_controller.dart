import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/api_response.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/user.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/snackbar.dart';
import '../../home/controllers/home_controller.dart';
import '../../user_menu/controllers/user_menu_controller.dart';
import '../models/block_list_model.dart';
import '../models/post_privacy_model.dart';

class SettingsPrivacyController extends GetxController {
  late ApiCommunication _apiCommunication;
  RxBool isLoadingSettings = true.obs;
  RxBool isLoadingBlockList = true.obs;
  var isPrivacyLoading = false.obs;
  var seePost = ''.obs;
  var sharePost = ''.obs;
  var commentPost = ''.obs;

  late final LoginCredential loginCredential;
  Rx<ProfileModel?> profileModel = Rx(null);
  String? dobString;
  Rx<List<Blocklist>> blockList = Rx([]);
  Rx<PostPrivacy> privacyModel = Rx(PostPrivacy());

  // Make these reactive controllers
  Rx<TextEditingController> firstNameController = Rx(TextEditingController());
  Rx<TextEditingController> lastNameController = Rx(TextEditingController());
  Rx<TextEditingController> emailAddressController =
      Rx(TextEditingController());
  Rx<TextEditingController> phoneController = Rx(TextEditingController());
  Rx<TextEditingController> dobController = Rx(TextEditingController());
  Rx<TextEditingController> addPhoneController = Rx(TextEditingController());
  Rx<TextEditingController> addEmailAddressController =
      Rx(TextEditingController());
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  Rx<TextEditingController> oldPasswordController = Rx(TextEditingController());
  Rx<TextEditingController> newPasswordController = Rx(TextEditingController());
  Rx<TextEditingController> confirmPasswordController =
      Rx(TextEditingController());

  RxString fullPhoneNumber = ''.obs;
  RxString oldPassword = ''.obs;
  RxString newPassword = ''.obs;
  RxString confirmPassword = ''.obs;
  var obscureOldPassword = true.obs;
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var isPasswordTooShort = false.obs;
  var isPasswordInvalid = false.obs;
  var isPasswordMismatch = false.obs;
  UserMenuController userMenuController = Get.find();
//==========================Get USer Personal Details ===================================//
  Future getUserData() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-user-info',
      requestData: {'username': '${loginCredential.getUserData().username}'},
      responseDataKey: 'userInfo',
    );
    if (apiResponse.isSuccessful) {
      debugPrint('Response success');
      profileModel.value =
          ProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
      debugPrint('My Profile Model: ${profileModel.value}');

      // Update controllers with fetched data
      firstNameController.value =
          TextEditingController(text: profileModel.value?.first_name ?? '');
      lastNameController.value =
          TextEditingController(text: profileModel.value?.last_name ?? '');
      emailAddressController.value =
          TextEditingController(text: profileModel.value?.email ?? '');
      phoneController.value =
          TextEditingController(text: profileModel.value?.phone ?? '');
      dobString = profileModel.value?.date_of_birth;
      if (dobString != null) {
        try {
          DateTime dob = DateTime.parse(dobString ?? '');

          String formattedDob = DateFormat('MMM dd, yyyy').format(dob);

          dobController.value = TextEditingController(text: formattedDob);
        } catch (e) {
          debugPrint('Error parsing date of birth: $e');
          dobController.value = TextEditingController(text: 'Invalid date'.tr);
        }
      } else {
        dobController.value = TextEditingController(text: 'No date provided'.tr);
      }

      isLoadingSettings.value = false;
    } else {
      debugPrint('Response failed');
    }
  }

//====================================== Update Personal Info =========================================//
  Future<void> updatePersonalInfo() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'settings-privacy/personal-details',
      enableLoading: true,
      requestData: {
        'first_name': firstNameController.value.text,
        'last_name': lastNameController.value.text,
        'email': emailAddressController.value.text,
        'phone': phoneController.value.text,
        'date_of_birth': dobController.value.text,
      },
    );

    if (response.isSuccessful) {
      getUserData();
      UserMenuController userMenuController = Get.find();
      HomeController homeController = Get.find();

      UserModel userModel = homeController.userModel;
      userModel.first_name = firstNameController.value.text;
      userModel.last_name = lastNameController.value.text;
      userModel.email = emailAddressController.value.text;
      userModel.phone = phoneController.value.text;
      userModel.date_of_birth = dobController.value.text;
      userMenuController.userModel.value = userModel;
      loginCredential.saveUserData(userModel);
      showSuccessSnackkbar(message: 'Personal Details Updated successfully');
    } else {
      debugPrint('Error updating personal details');
    }
  }

  //===================== All Toggle Visibility Func =================================//
  void toggleOldPasswordVisibility() {
    obscureOldPassword.value = !obscureOldPassword.value;
    debugPrint(
        'Old Pass Toggle value:::::::::::::${obscureOldPassword.value.toString()}');
  }

  // Toggle visibility for new password
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  // Toggle visibility for confirm password
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // UserModel? user ;
  /*=============== ADD Contact API=====================*/
  // Add contact API method
  Future<void> onTapAddContactPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'settings-privacy/add-phone-email-language',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'phone': fullPhoneNumber.value,
        'email': addEmailAddressController.value.text,
      },
    );

    if (response.isSuccessful) {
      Get.back();
      resetContactData();
      // UserMenuController userMenuController = Get.find();
      // userMenuController.loginCredential.saveUserData(user!);
      // userMenuController.loginCredential.getUserData();
      showSuccessSnackkbar(message: 'Contact Info Added Successfully');
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  // Delete Account API method
  Future<void> deleteAccount() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-user',
      isFormData: false,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      Get.offAllNamed(Routes.LOGIN);
      UserMenuController userMenuController = Get.find();
      userMenuController.loginCredential.getUserData();
      showSuccessSnackkbar(
          message: 'Your account has been successfully deleted.');
    } else {
      showErrorSnackkbar(message: 'Your account deletion process has failed');
      debugPrint('API ERROR: ${response.message}');
    }
  }

  Future<void> deactivatedAccount() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'account-deactivate',
      isFormData: false,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      Get.offAllNamed(Routes.LOGIN);
      UserMenuController userMenuController = Get.find();
      userMenuController.loginCredential.getUserData();
      showSuccessSnackkbar(
          message: 'Your account has been successfully deactivated.');
    } else {
      showErrorSnackkbar(message: 'Your account deactivation process has failed');
      debugPrint('API ERROR: ${response.message}');
    }
  }

  // Reset Phone and Email Data
  void resetContactData() {
    addPhoneController.value.clear();
    addEmailAddressController.value.clear();
  }

  /*=============== Change Password API=====================*/
  // Add contact API method
  Future<void> onTapChangePasswordPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'settings-privacy/password-change',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'password': oldPasswordController.value.text,
        'newPassword': newPasswordController.value.text,
        'confirmPassword': confirmPasswordController.value.text
      },
    );

    if (response.isSuccessful) {
      resetPasswordData();

      showSuccessSnackkbar(message: 'Password changed Successfully');
    } else {
      showErrorSnackkbar(message: 'Password change failed');
      debugPrint('API ERROR: ${response.message}');
    }
  }

  // Validate password conditions
  void validatePasswordConditions() {
    isPasswordTooShort.value = newPassword.value.length < 8;
    isPasswordInvalid.value =
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])')
            .hasMatch(newPassword.value);
    isPasswordMismatch.value = newPassword.value != confirmPassword.value;
  }

  // Validates password form
  bool validatePasswordForm() {
    return !isPasswordTooShort.value &&
        !isPasswordInvalid.value &&
        !isPasswordMismatch.value;
  }

// reset Password fields
  void resetPasswordData() {
    oldPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
    oldPasswordController.value.clear();
    newPasswordController.value.clear();
    confirmPasswordController.value.clear();
  }

  //======================================================== BlockList and Unblock Functions ===============================================//

  Future<void> getBlockList() async {
    isLoadingBlockList.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'settings-privacy/get-blocklist',
    );
    isLoadingBlockList.value = false;

    if (apiResponse.isSuccessful) {
      blockList.value =
          (((apiResponse.data as Map<String, dynamic>)['blocklist']) as List)
              .map((element) => Blocklist.fromMap(element))
              .toList();
      debugPrint(blockList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    debugPrint('-Settings controller---------------------------$apiResponse');
  }

//======================================Unblock From Block List =================================================//
  Future<void> unBlockFriends({required String userId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'settings-privacy/unblock-user/$userId',
        // requestData: {
        //   'block_user_id': userId,
        // },
        enableLoading: true,
        errorMessage: 'unblock failed');

    debugPrint(
        '===============================================UnBlock API Call End');

    if (apiResponse.isSuccessful) {
      getBlockList();

      showSuccessSnackkbar(message: 'Unblock  Successful');
      debugPrint(
          '===============================================UnBlock Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('Settings controller---------------------------$apiResponse');
  }

  //======================================= Posts/ Stories Privacy ==================================//
  Future<void> getPostOrStoryPrivacy(String postType) async {
    isPrivacyLoading.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'settings-privacy/get-post-privacy?post_type=$postType',
    );

    isPrivacyLoading.value = false;

    if (apiResponse.isSuccessful) {
      // If the API call is successful, parse the data and map it to your PostPrivacy model
      privacyModel.value = PostPrivacy.fromMap(
        (apiResponse.data as Map<String, dynamic>)['privacy']
            as Map<String, dynamic>?,
      );
    } else {
      // Handle error
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
      debugPrint("API Call Failed: ${apiResponse.message ?? 'Unknown error'}");
    }

    debugPrint('-Settings controller---------------------------$apiResponse');
  }

  //====================================== Update Privacy Info =========================================//

  Future<void> updatePrivacyInfo(
    String postType,
    String canSee,
    String canShare,
    String canComment,
  ) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'settings-privacy/update-post-privacy',
      enableLoading: true,
      requestData: {
        'who_can_see': seePost.value,
        'who_can_share': sharePost.value,
        'who_can_comment': commentPost.value,
        'post_type': postType,
      },
    );

    if (response.isSuccessful) {
      // Handle successful update
      getPostOrStoryPrivacy(postType);
      // Get.back();
      // Get.back();
      showSuccessSnackkbar(message: 'Privacy Updated successfully');
    } else {
      debugPrint('Error updating personal details');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    getUserData();
    getBlockList();
  }

  @override
  void onClose() {
    firstNameController.value.dispose();
    lastNameController.value.dispose();
    emailAddressController.value.dispose();
    phoneController.value.dispose();
    super.onClose();
  }
}
