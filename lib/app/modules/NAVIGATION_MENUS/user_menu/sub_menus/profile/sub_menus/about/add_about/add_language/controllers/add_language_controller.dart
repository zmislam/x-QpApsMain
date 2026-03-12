import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../models/language.dart';
import '../../../../../../../../../../models/profile_model.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';

class AddLanguageController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController languageController;
  AboutController aboutcontroller = Get.find();
  RxString contactDropdownalue = 'Email'.obs;

  Rx<LanguageModel?> languageModel = Rx(null);
  bool isEditing = false;

  AboutController aboutController = Get.find();

  Rx<PrivacySearchModel?> privacyModel = Rx(null);
/*=============== ADD Langauge API=====================*/
  Future<void> onTapAddLangaugePatch() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'settings-privacy/add-phone-email-language',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'language': languageController.text,
        'language_privacy':
            getPrivacyDescription(privacyModel.value?.privacy ?? ''),
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

/*=============== Edit Language API=====================*/
  Future<void> onTapEditLanguagePacth({String? Id}) async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'settings-privacy/edit-phone-email-language',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'language': languageController.text,
        'language_privacy': privacyModel.value?.privacy ?? 'public',
        'language_id': languageModel.value?.id
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  void setSelectedDropdownValue(LanguageModel languageModel) {
    isEditing = aboutController.profileModel.value?.language != null;

    if (isEditing) {
      languageController.text = languageModel.language ?? '';
      privacyModel.value = getPrivacyModel(languageModel.privacy ?? 'public');
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
      case 'only_me':
        return 'only_me';
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

    languageController = TextEditingController();

    languageModel.value = Get.arguments;
    if (languageModel.value != null) {
      setSelectedDropdownValue(languageModel.value!);
    }
    userModel = _loginCredential.getUserData();
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
