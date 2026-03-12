import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/post_media_layout_model.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../utils/custom_controllers/file_picker_controller.dart';
import '../../../../../utils/snackbar.dart';

import '../../../../../config/constants/api_constant.dart';
import '../../../../../data/post_color_list.dart';
import '../../../../../models/feeling_model.dart';
import '../../../../../models/location_model.dart';
import '../../../../../utils/post_utlis.dart';
import '../../../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/model/page_profile_model.dart';
import '../../create_post/models/imageCheckerModel.dart';
import '../../create_post/models/link_preview_model.dart';
import '../../create_post/service/imageCheckerService.dart';

class CreatePagePostController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;

  //==============Image file

  Rx<List<XFile>> xfiles = Rx([]);
  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;

  //============== Privacy

  RxString dropdownValue = privacyList.first.obs;

  List<PostMediaLayoutModel> mediaLayoutlist =
      PostLocalData.getMediaLayoutTypeList;
  Rx<PostMediaLayoutModel?> selectedMediaLayout =
      Rx(PostLocalData.getMediaLayoutTypeList[0]);

  Rx<bool> showLayoutOptions = Rx(true);

  //============== create post
  Rx<PostFeeling?> feelingName = Rx(null);
  Rx<AllLocation?> locationName = Rx(null);
  Rx<List<AllLocation>> locationList = Rx([]);
  Rx<List<PostFeeling>> feelingList = Rx([]);
  Rx<List<PostFeeling>> feelingSearchList = Rx([]);

  RxString locationSearch = ''.obs;
  RxString feelingId = ''.obs;
  RxString locationId = ''.obs;

  RxBool isLocationLoading = false.obs;
  RxBool isFeelingLoading = false.obs;
  Rx<bool> isBackgroundColorPost = false.obs;

  Rx<Color> postBackgroundColor = postListColor.first.obs;

  RxString wordLimit = ''.obs;

  late PageProfileModel pageProfileModel;

  late TextEditingController descriptionController;

  var feelingController = ''.obs;
  VideoPlayerController? videoPlayerController;

//==========================================Generate video thumbnail===============================================//
  Future<String?> generateThumbnail(String videoPath) async {
    videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {});
    return videoPath;
  }

  //============================================ CreatePost =========================================//
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

  Future<void> onTapCreatePagePost(
    String pageId,
  ) async {
    isCreatePostCalled.value = true;

    if (!isValidPost()) {
      // Do nothing — snackbars already shown inside isValidPost()
      isCreatePostCalled.value = false;
      return;
    } else {
      final ApiResponse response = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'save-page-post',
        enableLoading: true,
        requestData: {
          'page_id': pageId,
          'description': descriptionController.text,
          'feeling_id': getFeelingId(),
          'sub_activity_id': '',
          'post_type': 'page_post',
          'layout_type': selectedMediaLayout.value?.title == 'none'
              ? null
              : selectedMediaLayout.value?.title,
          'location_name': locationName,
          'post_privacy': (getPostPrivacyValue(dropdownValue.value)),
          'post_background_color': getBackgroundColor(),
        },
        fileKey: 'files',
        processedFileNames: processedFileData,
      );
      if (response.isSuccessful) {
        isCreatePostCalled.value = false;
        Get.back();
        showSuccessSnackkbar(message: 'Post submitted successfully');
      } else {
        debugPrint('');
      }
    }
  }

//============================ Get Link Preview ==========================================//
  RxBool isLinkPreviewLoading = true.obs;
  Rx<LinkPreview?> linkPreview = Rx(null);

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

  String? getBackgroundColor() {
    if (isBackgroundColorPost.value) {
      return postBackgroundColor.value.value.toRadixString(16).substring(2, 8);
    } else {
      return null;
    }
  }

//======================================== get Location ===============================//

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

  //======================================== get Background Color ===============================//

  // String? getBackgroundColor() {
  //   if (isBackgroundColorPost.value) {
  //     return postBackgroundColor.value.value.toRadixString(16).substring(2, 8);
  //   } else {
  //     return null;
  //   }
  // }

  //======================================== get Feeling ===============================//

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

  String? getFeelingId() {
    if (feelingName.value != null) {
      return feelingName.value?.id;
    } else {
      return null;
    }
  }

  //======================================== pickFiles ===============================//

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
    descriptionController = TextEditingController();
    pageProfileModel = Get.arguments as PageProfileModel;
    getFeeling();
    getLocation('Dhaka');
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    descriptionController.dispose();
    super.onClose();
  }
}
