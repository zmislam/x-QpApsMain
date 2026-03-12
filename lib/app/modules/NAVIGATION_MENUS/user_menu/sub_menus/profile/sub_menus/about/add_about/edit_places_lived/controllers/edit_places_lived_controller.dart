import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';

class EditPlacesLivedController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController placeAddressController;
  AboutController aboutcontroller = Get.find();
  RxString placeDropdownalue = 'Home Town'.obs;
  RxBool isEditing = false.obs;
// Rx<ProfileModel>? profileModel ;

  AboutController aboutController = Get.find();
  PrivacySearchModel? privacyModel;
/*=============== Update User Location API=====================*/
  Future<void> onTapEditPlacesLivedPost() async {
    final String placeKey = getPlaceKey();
    final String privacyKey = getPrivacyKey();

    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'update-user-location',
      isFormData: false,
      enableLoading: true,
      requestData: {
        placeKey: placeAddressController.text,
        privacyKey: privacyModel?.privacy ?? 'public',
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

//set Selected Dropdown

  void setSelectedDropdownValue(String value) {
    placeDropdownalue.value = value;
    isEditing.value =
        aboutcontroller.profileModel.value?.present_town != null ||
            aboutcontroller.profileModel.value?.home_town != null;

    if (isEditing.value) {
      if (value == 'Home Town') {
        placeAddressController.text =
            aboutController.profileModel.value?.home_town ?? '';
        privacyModel = getPrivacyModel(
            aboutController.profileModel.value?.home_town ?? 'public');
        getPrivacyDescription(
            aboutController.profileModel.value?.privacy?.home_town ?? 'public');
      } else {
        placeAddressController.text =
            aboutController.profileModel.value?.present_town ?? '';
        privacyModel = getPrivacyModel(
            aboutController.profileModel.value?.privacy?.present_town ??
                'public');
        getPrivacyDescription(
            aboutController.profileModel.value?.privacy?.present_town ??
                'public');
      }
    }
  }

//get place Key
  String getPlaceKey() {
    switch (placeDropdownalue.value) {
      case 'Home Town':
        return 'home_town';
      case 'Current City':
        return 'present_town';
      default:
        return '';
    }
  }

//get privacy key
  String getPrivacyKey() {
    switch (placeDropdownalue.value) {
      case 'Home Town':
        return 'home_town_privacy';
      case 'Current City':
        return 'present_town_privacy';
      default:
        return '';
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

  //get privacy description
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

    placeAddressController = TextEditingController();
    userModel = _loginCredential.getUserData();

    Map<String, dynamic>? arguments = Get.arguments;
    int? id = arguments?['id'];
    aboutcontroller.profileModel.value = arguments?['model'];
    if (aboutcontroller.profileModel.value?.home_town != null ||
        aboutcontroller.profileModel.value?.present_town != null) {
      if (id == 2) {
        setSelectedDropdownValue('Home Town');
        getPrivacyDescription(privacyModel?.privacy ?? 'public');
      } else if (id == 1) {
        setSelectedDropdownValue('Current City');
        getPrivacyDescription(privacyModel?.privacy ?? 'public');
      }
    }

    setSelectedDropdownValue(placeDropdownalue.value);
    // else {
    //   setInitialDropdownValue();
    // }

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
