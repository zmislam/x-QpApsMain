import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../models/profile_model.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';

class EditNickNameController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  AboutController aboutcontroller = Get.find();
  bool isEditing = false;
  String nickname = '';
  String privacy = 'public';

  late TextEditingController nickNameController;
  AboutController aboutController = Get.find();

  Rx<PrivacySearchModel?> privacyModel = Rx(null);

  Rx<ProfileModel?> profileModel = Rx(null);

/*=============== Edit NickName API=====================*/
  Future<void> onTapEditNickNamePatch() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'update-user-nickname',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'user_nickname': nickNameController.text,
        'privacy': privacyModel.value?.privacy,
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  setSelectedDropdownValue(String value) {
    isEditing = profileModel.value?.user_nickname != null;

    if (isEditing) {
      nickNameController.text = profileModel.value?.user_nickname ?? '';
      privacyModel.value =
          getPrivacyModel(profileModel.value?.privacy?.nickname ?? 'public');
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
      case 'only me':
        return PrivacySearchModel(id: '3', privacy: 'only_me');
      default:
        return PrivacySearchModel(id: '1', privacy: 'public');
    }
  }

  void showValidationMessage() {
    Get.snackbar(
      'Validation Error',
      'Please enter a toDate value before unchecking the box.',
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
      case 'only me':
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
    nickNameController = TextEditingController(
        text: aboutController.profileModel.value?.user_nickname ?? '');

    userModel = _loginCredential.getUserData();
    Map<String, dynamic> data = Get.arguments;
    data['nickname'] != null ? nickname = data['nickname'] : nickname;
    data['privacy'] != null ? privacy = data['privacy'] : privacy;
    setSelectedDropdownValue(nickname);
    getPrivacyDescription(privacy);
    privacyModel.value = getPrivacyModel(privacy);

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
