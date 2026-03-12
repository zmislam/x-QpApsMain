import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../../../models/profile_model.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../../../../../../../../models/user_work_place.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';
import '../../../../../../../../../../utils/snackbar.dart';

import '../../../../../../../../../../config/constants/color.dart';

class AddWorkPlaceController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;

  late TextEditingController orgNameController;
  late TextEditingController designationController;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  ProfileModel? profileModel;

  AboutController aboutController = Get.find();
  Rx<String?> fromDate = Rx(null);

  Rx<String?> toDate = Rx(null);
    final formKey = GlobalKey<FormState>();


  String? id = '';
    var isSaveButtonEnabled = false.obs;


  Rx<bool> isWorking = false.obs;
  Rx<bool> isToDateEnabled= false.obs;
  PrivacySearchModel? privacyModel;

  //Editing
  bool isEditing = false;
  UserWorkPlaceModel? userWorkPlaceModel;

  Future<void> onTapAddWorkPlacePost({String? id}) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-workplace',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'org_name': orgNameController.text,
        'designation': designationController.text,
        'from_date': fromDate.value ?? '',
        'to_date': toDate.value,
        'is_working': getIsWorkingCurrently(isWorking.value),
        'privacy': getPrivacyDescription(privacyModel?.privacy ?? ''),
        'username': userModel.username ?? '',
        'workplace_id': id,
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('');
      showErrorSnackkbar(
          message: '!!!!!WorkPlace Added submission failed successfully!!!!!');
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

  getIsWorkingCurrently(bool value) {
    isWorking.value = value;
    if (value) {
      toDate.value = '';
      toDateController.clear();
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

    privacyModel = PrivacySearchModel();
    orgNameController = TextEditingController();
      designationController = TextEditingController();
      fromDateController = TextEditingController();
      toDateController = TextEditingController();
    userModel = _loginCredential.getUserData();

    userWorkPlaceModel = Get.arguments;
    isEditing = userWorkPlaceModel != null;

     


    if (isEditing) {
      orgNameController.text = userWorkPlaceModel?.org_name ?? '';

      designationController.text = userWorkPlaceModel?.designation ?? '';
      fromDateController.text =(userWorkPlaceModel?.from_date)?.toFormatDateOfBirth()??'';
      toDateController.text = (userWorkPlaceModel?.to_date )?.toFormatDateOfBirth()??'';
      fromDate.value = userWorkPlaceModel?.from_date ?? '';
      toDate.value = userWorkPlaceModel?.to_date ?? '';
      privacyModel?.privacy = userWorkPlaceModel?.privacy;
      toDate.value ==null || toDate.value =='' ? isWorking.value = true: isWorking.value = false;
    
    } 
 
    super.onInit();
  }



  @override
  void onReady() {
    aboutController;
    super.onReady();
  }
}
