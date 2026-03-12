
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

class AddAboutYourselfController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  AboutController aboutcontroller = Get.find();
  bool isEditing = false;
 RxInt aboutYouLength = 0.obs;
 String aboutyou ='';
 String privacy='public';



late TextEditingController aboutYourselfController ;
  AboutController aboutController = Get.find();

  Rx<PrivacySearchModel?> privacyModel = Rx(null);

  Rx<ProfileModel?> profileModel = Rx(null);

/*=============== Edit About  API=====================*/
   Future<void> onTapEditAboutPatch() async {
     if (aboutYourselfController.text.length > 400) {
      // showValidationMessage();
      return;
    }

    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'update-user-about',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'user_about': aboutYourselfController.text,
        'privacy': getPrivacyDescription(privacyModel.value?.privacy ?? ''),
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }


  void updateBioLength(int length) {
    aboutYouLength.value = length;
  }

 
  setSelectedDropdownValue(String value) {
    isEditing = profileModel.value?.user_about != null;

    if (isEditing) {
      
     aboutYourselfController  .text = profileModel.value?.user_about ?? '';
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
    aboutYourselfController =TextEditingController(text:aboutController.profileModel.value?.user_about ??'');

    userModel = _loginCredential.getUserData();
    Map<String, dynamic> data = Get.arguments;
     data['aboutyou']!=null?aboutyou = data['aboutyou']:aboutyou;
    data['privacy']!=null? privacy = data['privacy']:privacy;
    setSelectedDropdownValue(aboutyou);
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
