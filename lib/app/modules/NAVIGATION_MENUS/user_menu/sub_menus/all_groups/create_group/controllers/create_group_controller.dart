import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/category.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/location_model.dart';
import '../models/friend_list_model.dart';
import '../../my_groups/models/my_group_model.dart';
import '../../../profile/sub_menus/my_profile_friends/controllers/my_profile_friends_controller.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/snackbar.dart';

class CreateGroupController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  final GlobalKey<FormState> formKey = GlobalKey();
  RxString coverPhotoError = ''.obs;
  RxInt view = 0.obs;
  late MyProfileFriendsController myProfileFriendsController;
  Rx<List<MyGroupsModel>> myGroupList = Rx([]);

  Rx<List<FriendResultModel>> friendList = Rx([]);
  Rx<List<String>> selectedUsernames = Rx([]);
  RxBool isLoadingUserGroups = false.obs;
  RxBool isLocationLoading = false.obs;
  RxBool switchValue = true.obs;
  RxBool isSaveButtonEnabled = false.obs;

  Rx<List<XFile>> profilefiles = Rx([]);
  Rx<List<XFile>> coverfiles = Rx([]);

  RxString categoryValue = categoryList.first.obs;

  RxString privacyDropdownValue = groupPrivacyList.first.obs;
  String? selectedCategory;
  Rx<List<AllLocation>> locationList = Rx([]);

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  late TextEditingController zipCodeController;

  //-------------------------------------- All Location ----------------------------//

  // Future<List<AllLocation>> getLocation(String locationName) async {
  //   isLocationLoading.value = true;
  //   final ApiResponse response = await _apiCommunication.doGetRequest(
  //     apiEndPoint: 'global-search-location?search=$locationName',
  //     responseDataKey: ApiConstant.FULL_RESPONSE,
  //   );
  //   isLocationLoading.value = false;
  //   if (response.isSuccessful) {
  //     locationList.value =
  //         (((response.data as Map<String, dynamic>)['results']) as List)
  //             .map((element) => AllLocation.fromJson(element))
  //             .toList();
  //   } else {
  //     debugPrint('');
  //   }
  //   return locationList.value;
  // }
  //-------------------------------------- PICK FILES ----------------------------//

  Future<void> pickCoverFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();
    coverfiles.value.addAll(mediaXFiles);
    coverfiles.refresh();
  }

//-------------------------------------- Create Group ----------------------------//
  Future<void> createGroup() async {
    // selectedUsernames.value = friendList.value.map((item) => item.userId?.username ?? '').toList();

    final ApiResponse response = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'create-group',
      isFormData: true,
      enableLoading: true,
      fileKeys: ['group_cover_pic'],
      requestData: {
        'group_name': nameController.text,
        'group_description': descriptionController.text,
        'group_privacy': privacyDropdownValue.value.toLowerCase(),
        'location': locationController.text,
        'address': addressController.text,
        'zip_code': zipCodeController.text,
        'invited_users[]': selectedUsernames.value,
      },
      mediaXFiles: [coverfiles.value.first],
    );

    if (response.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Group created successfully');
    } else {
      debugPrint('Failed to create group: ${response.message}');
      debugPrint('Selected Username: ${selectedUsernames.value}');
    }
  }

//-------------------------------------- Get Friend List----------------------------//
  // Future<void> fetchFriendList() async {
  //   final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
  //     apiEndPoint: 'search-friend',
  //     enableLoading: true,
  //     responseDataKey: 'results',
  //     requestData: {'username': loginCredential.getUserData().username},
  //   );

  //   if (apiResponse.isSuccessful) {
  //     debugPrint(
  //         '::::::::::::::::::::::::My Friend List::::::${apiResponse.data}:::::::::::::::::::::::::');

  //     if (apiResponse.data != null && apiResponse.data is List) {
  //       friendList.value = (apiResponse.data as List)
  //           .map((e) => FriendResultModel.fromMap(e))
  //           .toList();
  //     } else {
  //       debugPrint('Friend list data is null or not a list.');
  //       friendList.value = [];
  //     }
  //   } else {
  //     debugPrint(
  //         '"""""""""""""Friend List Error:::::::::${apiResponse.message}');
  //   }
  // }
  Future<void> getFriends() async {
    // isLoadingFriendList.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-friend',
    );

    if (apiResponse.isSuccessful) {
      friendList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => FriendResultModel.fromMap(element))
              .where((friend) =>
                  friend.id !=
                  loginCredential
                      .getUserData()
                      .id) 
              .toList();
      debugPrint(friendList.value.length.toString());
      debugPrint(loginCredential.getUserData().id.toString());
    } else {
      debugPrint('Error');
    }

    // isLoadingFriendList.value = false;

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    addressController = TextEditingController();
    zipCodeController = TextEditingController();
    locationController = TextEditingController();
    getFriends();
    super.onInit();
  }
}
