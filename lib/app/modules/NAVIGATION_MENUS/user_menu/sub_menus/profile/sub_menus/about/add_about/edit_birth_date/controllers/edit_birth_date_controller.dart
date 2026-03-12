import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';

import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../config/constants/color.dart';

class EditBirthDateController extends GetxController {
  late  ApiCommunication _apiCommunication;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  String privacy = 'public';

  Rx<PrivacySearchModel?> selectedPrivacyModel = Rx(null);
  RxString selectedViewType = 'Date and month'.obs;
  List<String> viewTypeList = ['Date and month', 'Year', 'Full Date'];

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

  void updateBirthday() async {
    ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'update-user-birthday/',
      requestData: {
        'birth_date': selectedDate.value.toIso8601String(),
        'date_of_birth_show_type': getShowType(selectedViewType.value),
        'privacy': selectedPrivacyModel.value?.privacy,
      },
    );
    if (response.isSuccessful) {
      AboutController controller = Get.find();
      controller.getUserALLData();
      Get.back();
    } else {
      debugPrint('');
    }
  }

  String getShowType(String type) {
    switch (type) {
      case 'Date and month':
        return 'only_date';
      case 'Year':
        return 'only_year';
      case 'Full Date':
        return 'full_date';
      default:
        return 'public';
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    Map<String, dynamic> data = Get.arguments;

    String birthday = data['dob'];
     if(data['privacy'] == null ){
       privacy = 'public';
    }else{
       privacy = data['privacy'];

    }
    selectedPrivacyModel.value = getPrivacyModel(privacy);
    selectedDate.value = DateTime.parse(birthday).toLocal();
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
