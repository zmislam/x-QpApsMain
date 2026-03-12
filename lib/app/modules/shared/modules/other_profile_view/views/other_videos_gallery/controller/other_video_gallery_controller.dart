import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../services/api_communication.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/videos_gallery/model/video_model.dart';

class OtherVideoGalleryController extends GetxController {
  RxBool isLoadingUserVideo = true.obs;
  late final ApiCommunication _apiCommunication;
  RxString dropdownValue = privacyList.first.obs;
  Rx<List<VideoModel>> videoList = Rx([]);
  Rx<List<XFile>> xfiles = Rx([]);
  late LoginCredential loginCredential;
  var isSaveButtonEnabled = false.obs;
  final formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;
  String username = '${Get.arguments}';

  // Future getVideos() async {
  //   isLoadingUserVideo.value = true;
  //   ApiResponse apiResponse = await _apiCommunication.doPostRequest(
  //     apiEndPoint: 'get-users-latest-image-video/$username',
  //     requestData: {
  //       'username': username,
  //     },
  //     responseDataKey: 'videos',
  //   );

  //   if (apiResponse.isSuccessful) {
  //     videoList.value = (apiResponse.data as List)
  //         .map(
  //           (e) => VideoModel.fromMap(e),
  //         )
  //         .toList();
  //   }
  //   isLoadingUserVideo.value = false;
  // }

  Future getOtherVideos() async {
    isLoadingUserVideo.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-latest-video-thumbnails',
      requestData: {
        'username': username,
      },
      responseDataKey: 'videos',
    );

    if (apiResponse.isSuccessful) {
      videoList.value = (apiResponse.data as List)
          .map(
            (e) => VideoModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserVideo.value = false;
  }

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();
    xfiles.value.addAll(mediaXFiles);
    xfiles.refresh();
  }

  Future<void> pickVideos() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> videoFiles = await picker.pickMultipleMedia();

    xfiles.value.addAll(videoFiles);
    xfiles.refresh();
  }

  Future<void> reportAPost({
    required String post_id,
    required String report_type,
    required String description,
  }) async {
    debugPrint('=================Report Start==========================');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'save-post-report',
      enableLoading: true,
      requestData: {
        'post_id': post_id,
        'report_type': report_type,
        'description': description,
      },
    );

    debugPrint(
        '=================Report Api call end==========================');
    debugPrint(
        '=================Report Api status Code ${apiResponse.message}==========================');
    debugPrint(
        '=================Report Api success ${apiResponse.isSuccessful}==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '=================Report Successful==========================');
      getOtherVideos();
      Get.back();
      Get.back();
      Get.back();

      showSuccessSnackkbar(message: 'Post reported successfully');
    } else {}
  }

  Future<void> saveVideos(String VideoId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': descriptionController.text,
        'album_id': VideoId,
        'Files': ''
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    descriptionController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    descriptionController.dispose();
    super.onClose();
  }
}
