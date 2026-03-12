import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../../../models/educational_work_place.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';
import '../../../../../../../../../../config/constants/color.dart';

class AddEducationController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController instituteNameController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  EducationalWorkPlace? educationalWorkPlaceModel;
  bool isEditing = false;


    final formKey = GlobalKey<FormState>();
    var isSaveButtonEnabled = false.obs;

  AboutController aboutController = Get.find();
  Rx<String?> startDate = Rx(null);

  Rx<String?> endDate = Rx(null);

  Rx<bool> isStudying = false.obs;
  PrivacySearchModel? privacyModel;
/*=============== ADD EDUCATION API=====================*/
  Future<void> onTapAddEducationPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-education-info',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'institute_name': instituteNameController.text,
        'startDate': startDate.value ?? '',
        'endDate': endDate.value ,
        'is_studying': isStudying.value,
        'privacy': getPrivacyDescription(privacyModel?.privacy ?? ''),
        'username': userModel.username ?? ''
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }
/*=============== EDIT EDUCATION API=====================*/
  Future<void> onTapEditEducationPatch({String? id}) async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'update-user-education-info/$id',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'institute_name': instituteNameController.text,
        'startDate': startDate.value ?? '',
        'endDate': endDate.value ,
        'is_studying': isStudying.value,
        'privacy': getPrivacyDescription(privacyModel?.privacy ?? ''),
        'username': userModel.username ?? ''
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
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

 getIsStudyingCurrently(bool value) {
    isStudying.value = value;
    if (value) {
      endDate.value = null;
      endDateController.clear();

    }
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
    startDateController = TextEditingController();
      endDateController = TextEditingController();
    instituteNameController = TextEditingController();
     educationalWorkPlaceModel = Get.arguments;
    isEditing = educationalWorkPlaceModel != null;
     if (isEditing) {
      instituteNameController.text = educationalWorkPlaceModel?.institute_name ?? '';

      startDateController.text =(educationalWorkPlaceModel?.startDate)?.toFormatDateOfBirth()??'';
      endDateController.text = (educationalWorkPlaceModel?.endDate )?.toFormatDateOfBirth()??'';
      startDate.value = educationalWorkPlaceModel?.startDate ?? '';
      endDate.value = educationalWorkPlaceModel?.endDate ?? '';
      privacyModel?.privacy = educationalWorkPlaceModel?.privacy;
      endDate.value ==null || endDate.value == '' ? isStudying.value = true : isStudying.value = false;
    } 
 


    privacyModel = PrivacySearchModel();

    userModel = _loginCredential.getUserData();
    super.onInit();
  }

  @override
  void onReady() {
    aboutController;
    super.onReady();
  }
}
