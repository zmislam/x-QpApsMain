import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../data/post_local_data.dart';
import '../../../../../../../../models/api_response.dart';
import '../../../../../../../../services/api_communication.dart';

import '../../../../../../../../utils/snackbar.dart';
import '../model/video_model.dart';

class VideosGalleryController extends GetxController {
  RxBool isLoadingUserVideo = true.obs;
  late final ApiCommunication _apiCommunication;
  RxString dropdownValue = privacyList.first.obs;
  Rx<List<VideoModel>> videoList = Rx([]);
  Rx<List<XFile>> xfiles = Rx([]);
  late LoginCredential loginCredential;
  var isSaveButtonEnabled = false.obs;
  final formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;

  Future getVideos() async {
    isLoadingUserVideo.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-latest-video-thumbnails',
      requestData: {
        'username': loginCredential.getUserData().username,
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
  //--------------------------------------- DELETE PHOTOS ----------------------------//

  Future<void> deletevideos(String mediaId, String key) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-post-media-by-id', requestData: {
      'media_id': mediaId,
      'media': 'posts',
      'key': key,
    });
    if (response.isSuccessful) {
      getVideos();

      Get.back();
      showSuccessSnackkbar(message: 'Video deleted successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();
    xfiles.value.addAll(mediaXFiles);
    xfiles.refresh();
  }

  Future<void> saveVideos(String albumId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': descriptionController.text,
        'album_id': albumId,
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
