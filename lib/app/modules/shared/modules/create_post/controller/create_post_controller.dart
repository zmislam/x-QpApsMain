import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import 'package:video_player/video_player.dart';

import '../../../../../config/constants/api_constant.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../data/post_color_list.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../models/event_icon_type_model.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/feeling_model.dart';
import '../../../../../models/friend.dart';
import '../../../../../models/location_model.dart';
import '../../../../../models/post_media_layout_model.dart';
import '../../../../../models/user.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../utils/post_utlis.dart';
import '../../../../../utils/snackbar.dart';
import '../../../../NAVIGATION_MENUS/friend/controllers/friend_controller.dart';
import '../models/fileCheckState.dart';
import '../models/imageCheckerModel.dart';
import '../models/link_preview_model.dart';
import '../service/imageCheckerService.dart';

class CreatePostController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController descriptionController;
  var feelingController = ''.obs;
  var tagPeopleController = ''.obs;

  // For Background color post view
  Rx<Color> postBackgroundColor = postListColor.first.obs;
  Rx<bool> isBackgroundColorPost = false.obs;

  RxString eventType = 'work'.obs;
  RxString eventSubType = ''.obs;
  // RxString orgName = ''.obs;
  late TextEditingController orgController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController positionController;
  late TextEditingController workController;

  RxString designation = ''.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  // Rx<String?> endDate = Rx(null);
  RxBool is_current_working = false.obs;

  RxString dropdownValue = privacyList.first.obs;

  Rx<List<XFile>> xfiles = Rx([]);
  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;

  Rx<List<PostFeeling>> feelingList = Rx([]);
  Rx<List<PostFeeling>> feelingSearchList = Rx([]);

  RxBool isFeelingLoading = false.obs;
  RxBool isLinkPreviewLoading = false.obs;
  Rx<PostFeeling?> feelingName = Rx(null);
  Rx<LinkPreview?> linkPreview = Rx(null);
  RxInt iconIndex = 0.obs;

  Rx<List<EventIconTypeModel>> eventIconList = Rx([
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Bike.png', iconName: 'Bike'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Birds.png', iconName: 'Birds'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Engagement.png',
        iconName: 'Engagement'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Key.png', iconName: 'Key'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Location.png', iconName: 'Location'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Music.png', iconName: 'Music'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/People.png', iconName: 'People'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Pet.png', iconName: 'Pet'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Running.png', iconName: 'Running'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Smoke.png', iconName: 'Smoke'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Stop.png', iconName: 'Stop'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Transport.png',
        iconName: 'Transport'),
  ]);
  RxString customEventIconName = ''.obs;
  Rx<AllLocation?> locationName = Rx(null);
  RxBool isLocationLoading = false.obs;
  RxString locationSearch = ''.obs;
  Rx<List<AllLocation>> locationList = Rx([]);

  late FriendController friendController;
  RxString feelingId = ''.obs;
  RxString locationId = ''.obs;

  Rx<List<FriendModel>> checkFriendList = Rx([]);

  Rx<List<FriendModel>> searchFriendList = Rx([]);
  RxString wordLimit = ''.obs;
  //Relationship
  Rx<String> postPrivacy = 'Public'.obs;
  late TextEditingController partnerNameController;
  RxString partnerName = ''.obs;
  late TextEditingController titleTEController;
  RxString travelLocation = ''.obs;
  VideoPlayerController? videoPlayerController;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;

//==========================================Generate video thumbnail===============================================//
  Future<String?> generateThumbnail(String videoPath) async {
    videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {});
    return videoPath;
  }

//* ================================================================= Media =================================================================

  List<PostMediaLayoutModel> mediaLayoutlist =
      PostLocalData.getMediaLayoutTypeList;
  Rx<PostMediaLayoutModel?> selectedMediaLayout =
      Rx(PostLocalData.getMediaLayoutTypeList[0]);

  Rx<bool> showLayoutOptions = Rx(true);

  Future<void> getFeeling() async {
    isFeelingLoading.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-feelings',
    );
    isFeelingLoading.value = false;

    if (apiResponse.isSuccessful) {
      feelingList.value =
          (((apiResponse.data as Map<String, dynamic>)['postFeelings']) as List)
              .map((element) => PostFeeling.fromJson(element))
              .toList();
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }
    debugPrint('-post-home controller---------------------------$apiResponse');
  }

//============================ Get Link Preview ==========================================//
  Future<void> getLinkPreview(String url) async {
    isLinkPreviewLoading.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-thamble-url',
      requestData: {
        'link': url,
      },
    );

    isLinkPreviewLoading.value = false;

    if (apiResponse.isSuccessful) {
      // Cast the response data to a map and parse it
      final data = apiResponse.data as Map<String, dynamic>;
      linkPreview.value = LinkPreview.fromMap(data);
    } else {
      // Handle error case
      linkPreview.value = null;
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

//================Clear Link Preview=======================================//
  void clearPreview() {
    linkPreview.value = null;
  }

  Future<List<AllLocation>> getLocation(String locationName) async {
    isLocationLoading.value = true;
    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'global-search-location?search=$locationName',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    isLocationLoading.value = false;
    if (response.isSuccessful) {
      locationList.value =
          (((response.data as Map<String, dynamic>)['results']) as List)
              .map((element) => AllLocation.fromJson(element))
              .toList();
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

  String? getBackgroundColor() {
    if (isBackgroundColorPost.value) {
      return postBackgroundColor.value.value.toRadixString(16).substring(2, 8);
    } else {
      return null;
    }
  }

// =================Post Validity Check==============================//
  bool isValidPost() {
    // 1. Check if description is not empty
    if (descriptionController.text.isNotEmpty) {
      return true;
    }

    // 2. Check if there are attached files
    if (xfiles.value.isNotEmpty) {
      // Check total file size
      double totalSizeInBytes = 0;
      for (var xfile in xfiles.value) {
        final file = File(xfile.path);
        totalSizeInBytes += file.lengthSync();
      }

      double totalSizeInMB = totalSizeInBytes / (1024 * 1024);
      debugPrint(
          'Total Files Size ====== ${totalSizeInMB.toStringAsFixed(2)} MB');

      if (totalSizeInMB > 300) {
        // Too large
        showWarningSnackkbar(message: 'File size exceeds 300MB limit!');
        return false;
      }

      // Files are valid
      return true;
    }

    // 3. Nothing provided
    showWarningSnackkbar(message: 'Empty post cannot be submitted');
    return false;
  }

  RxBool isCreatePostCalled = false.obs;

  Future<void> onTapCreatePost() async {
    isCreatePostCalled.value = true;
    if (!isValidPost()) {
      isCreatePostCalled.value = false;
      return;
    } else {
      List<String> tags = [];

      if (checkFriendList.value.isNotEmpty) {
        tags = checkFriendList.value
            .where((checkFriend) => checkFriend.friend != null)
            .map((checkFriend) => checkFriend.friend!.id.toString())
            .toList();

        debugPrint('Selected friends IDs: $tags');
      }
      final requestData = {
        'description': descriptionController.text,
        'feeling_id': feelingId.value,
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'layout_type': selectedMediaLayout.value?.title == 'none'
            ? null
            : selectedMediaLayout.value?.title,
        'location_id': locationId.value,
        'location_name': locationName.value,
        'post_privacy': getPostPrivacyValue(dropdownValue.value),
        'post_background_color': getBackgroundColor(),
        'event_type': '',
        'event_sub_type': '',
        'org_name': '',
        'start_date': '',
        'end_date': '',
        'tags': tags,
      };

// ✅ Print formatted requestData for debugging
      print('🔹 Request Data: $requestData');

      final ApiResponse response = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'save-post',
        enableLoading: true,
        requestData: requestData,
        processedFileNames: processedFileData.value,
        fileKey:
            'files',
      );

      if (response.isSuccessful) {
        isCreatePostCalled.value = false;
        processedFileData.clear();
        xfiles.value.clear();
        Get.back(result: response.data);
        showSuccessSnackkbar(message: 'Post submitted successfully');
      } else {
        showErrorSnackkbar(
            message: response.message ?? 'Post Submission failed');
      }
    }
  }

  Future<void> onTapCreateEventPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': titleTEController.text,
        'feeling_id': '',
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'location_id': '',
        'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
        'post_background_color': '',
        'event_type': eventType.value,
        'event_sub_type': eventSubType.value,
        'org_name': orgController.text,
        'designation': positionController.text,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'is_current_working': is_current_working
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      eventType = 'work'.obs;
      eventSubType = ''.obs;

      designation.value = '';
      is_current_working.value = false;

      Get.back();
      Get.back();
      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> onTapCreateWorkPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': titleTEController.text,
        'feeling_id': '',
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'location_id': '',
        'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
        'post_background_color': '',
        'event_type': eventType.value,
        'event_sub_type': eventSubType.value,
        'org_name': partnerNameController.text,
        'designation': designation.value,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'is_current_working': is_current_working
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      eventType = 'work'.obs;
      eventSubType = ''.obs;

      designation.value = '';
      is_current_working.value = false;

      Get.back();
      Get.back();
      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> onTapCreateRelationshipPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': titleTEController.text,
        'feeling_id': '',
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'location_id': '',
        'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
        'post_background_color': '',
        'event_type': eventType.value,
        'event_sub_type': eventSubType.value,
        'to_user_id': partnerName.value,
        'designation': designation.value,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'is_current_working': is_current_working
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      eventType = 'work'.obs;
      eventSubType = ''.obs;

      designation.value = '';
      is_current_working.value = false;

      Get.back();
      Get.back();
      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> onTapCreateTravelPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': titleTEController.text,
        'feeling_id': '',
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'title': orgController.text,
        'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
        'post_background_color': '',
        'location_name': travelLocation.value,
        'event_type': eventType.value,
        'event_sub_type': eventSubType.value,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'is_current_working': is_current_working
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      eventType = 'work'.obs;
      eventSubType = ''.obs;

      designation.value = '';
      is_current_working.value = false;

      Get.back();
      Get.back();
      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> onTapCreateAchievementPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': titleTEController.text,
        'feeling_id': '',
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'location_id': '',
        'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
        'post_background_color': '',
        'event_type': eventType.value,
        'title': orgController.text,
        'start_date': startDateController.text,
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      eventType = 'work'.obs;
      eventSubType = ''.obs;

      designation.value = '';
      is_current_working.value = false;

      Get.back();
      Get.back();
      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> onTapCreateCustomPost() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': titleTEController.text,
        'feeling_id': '',
        'activity_id': '',
        'sub_activity_id': '',
        'user_id': userModel.id,
        'post_type': 'timeline_post',
        'location_id': '',
        'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
        'post_background_color': '',
        'event_type': eventType.value,
        'event_sub_type': eventSubType.value,
        'icon_name': customEventIconName.value,
        'title': orgController.text,
        'designation': designation.value,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'is_current_working': is_current_working
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      eventType = 'work'.obs;
      eventSubType = ''.obs;

      designation.value = '';
      is_current_working.value = false;

      Get.back();
      Get.back();
      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();

    if (mediaXFiles.isNotEmpty) {
      await checkFilesForVulgarity(mediaXFiles);
    }
  }

  Future<void> checkFilesForVulgarity(List<XFile> newFiles) async {
    isCheckingFiles.value = true;
    checkingStatus.value = 'Checking files for inappropriate content...';

    fileCheckingStates.value = newFiles
        .map((file) => FileCheckingState(
      fileName: file.name,
      filePath: file.path,
      isChecking: true,
    ))
        .toList();

    List<String> removedFiles = [];

    for (int i = 0; i < newFiles.length; i++) {
      XFile file = newFiles[i];
      String filePath = file.path.toLowerCase();

      try {
        checkingStatus.value = 'Checking ${i + 1}/${newFiles.length}: ${file.name}';

        ImageCheckerModel? checkerResponse;

        if (filePath.endsWithAny(['.jpg', '.jpeg', '.png', '.gif', '.webp'])) {
          checkerResponse = await ImageCheckerService.checkImageForVulgarity(file);
        } else if (filePath.endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
          checkerResponse = await ImageCheckerService.checkVideoForVulgarity(file);
        }

        if (checkerResponse != null) {
          debugPrint('API Response for ${file.name}: sexual=${checkerResponse.sexual}, data=${checkerResponse.data}');

          // ✅ CHECK THE SEXUAL FLAG!
          if (checkerResponse.sexual == true) {
            // ❌ REJECT - Inappropriate content
            removedFiles.add(file.name);
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isFailed = true;
            fileCheckingStates.refresh();
            debugPrint('❌ File REJECTED (inappropriate content): ${file.name}');
          } else {
            // ✅ ACCEPT - Appropriate content
            xfiles.value.add(file);
            if (checkerResponse.data != null) {
              processedFileData.value.add(checkerResponse.data!);
            }
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isPassed = true;
            fileCheckingStates.refresh();
            xfiles.refresh();
            processedFileData.refresh();
            debugPrint('✅ File ACCEPTED (appropriate content): ${file.name}');
          }
        } else {
          // ❌ API failed - REJECT for safety
          removedFiles.add(file.name);
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isFailed = true;
          fileCheckingStates.refresh();
          debugPrint('❌ File REJECTED (API failed): ${file.name}');
        }
      } catch (e) {
        // ❌ Error - REJECT for safety
        removedFiles.add(file.name);
        fileCheckingStates[i].isChecking = false;
        fileCheckingStates[i].isFailed = true;
        fileCheckingStates.refresh();
        debugPrint('❌ File REJECTED (error): ${file.name} - $e');
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (removedFiles.isNotEmpty) {
      showRemovedFilesSnackbar(removedFiles);
    }

    debugPrint('✅ Final accepted files: ${xfiles.value.length}');
    debugPrint('📋 Processed file data: ${processedFileData.value}');

    await Future.delayed(const Duration(milliseconds: 800));
    fileCheckingStates.clear();

    isCheckingFiles.value = false;
    checkingStatus.value = '';
  }

  void showRemovedFilesSnackbar(List<String> removedFiles) {
    String message;
    if (removedFiles.length == 1) {
      message =
          '${removedFiles.first} was removed due to inappropriate content';
    } else {
      message =
          '${removedFiles.length} files were removed due to inappropriate content';
    }

    Get.snackbar(
      'Content Removed',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
    );
  }

  void clearProcessedData() {
    processedFileData.clear();
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    if (Get.arguments != null) {
      xfiles.value = Get.arguments['media_files'];
      processedFileData.value = Get.arguments['processed_file_data'] ?? [];
    } else {
      xfiles.value = [];
    }
    descriptionController = TextEditingController();
    orgController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    workController = TextEditingController();
    positionController = TextEditingController();
    partnerNameController = TextEditingController();
    titleTEController = TextEditingController();
    userModel = _loginCredential.getUserData();
    friendController = Get.find();
    friendController.getFriends();
    getFeeling();
    getLocation('Dhaka');
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    partnerNameController.dispose();
    titleTEController.dispose();
    positionController.dispose();
    workController.dispose();
    processedFileData.clear();
    xfiles.value.clear();
    super.onClose();
  }
}
