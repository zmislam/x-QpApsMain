import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/user.dart';
import '../../../../../../services/api_communication.dart';
import '../../../../../../config/constants/color.dart';
import '../../../controllers/reels_controller.dart';
import '../../../model/reels_model.dart';

class EditReelsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController reelsDescriptionControlller;
// Rx<ProfileModel>? profileModel ;
  String? reelId;
  String? key;
  int? skipLength;
  PrivacySearchModel? privacyModel;

/*============================================ Update User Location API=================================*/
  ReelsController reelsController = Get.find<ReelsController>();


Future<void> onTapEditReelsPost() async {
  // 1. Find existing reel data
  final existingReel = reelsController.reelsModelList.value.firstWhere(
    (e) => e.id == reelId,
    orElse: () => ReelsModel(), // Fallback if not found
  );
    final existingReelsKey = reelsController.reelsModelList.value.firstWhere(
    (e) => e.key == key,
    orElse: () => ReelsModel(), // Fallback if not found
  );

  if (existingReel.id == null && existingReelsKey.key == '') {
    Get.snackbar('Error', 'Reel not found in local list');
    return;
  }

  // 2. Make API call
  final response = await _apiCommunication.doPostRequest(
    apiEndPoint: 'reels/update-reels/:$reelId',
    requestData: {
      'description': reelsDescriptionControlller.text,
      'reels_privacy': privacyModel?.privacy ?? 'public',
      'key' : key ,
    },
  );

  if (response.isSuccessful) {
    // 3. Create UPDATED copy with existing data + new values
    final updatedReel = existingReel.copyWith(
      description: reelsDescriptionControlller.text,
      reels_privacy: privacyModel?.privacy ?? 'public',
    );

    // 4. Update in list
    reelsController.updateReelInList(updatedReel);
    Get.back();
  }
}
//set Selected Dropdown

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
    reelId = Get.arguments['reel_id'];
    skipLength = Get.arguments['skipLength'];
    reelsDescriptionControlller =
        TextEditingController(text: Get.arguments['description']);
    privacyModel = getPrivacyModel(Get.arguments['privacy']);
    userModel = _loginCredential.getUserData();

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
