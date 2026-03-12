import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../models/profile_model.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/album_model.dart';
import '../../../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/photos_model.dart';
import '../../../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/profile_cover_albums_model.dart';

class OtherPhotosGalleryController extends GetxController {
  // Global Usecases
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;

  Rx<List<ProfilPicturesemodel>> profilePicturesList = Rx([]);
  Rx<List<ProfilPicturesemodel>> coverPhotosList = Rx([]);
  Rx<List<ProfilPicturesemodel>> albumPhotosList = Rx([]);
  Rx<List<AlbumModel>> albumsList = Rx([]);
  Rx<List<PhotoModel>> photoList = Rx([]);
  Rx<ProfileModel?> profileModel = Rx(null);
  Rx<List<PostModel>> postList = Rx([]);
  TextEditingController reportDescription = TextEditingController();

  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  RxBool isLoadingAlbums = false.obs;
  String username = '${Get.arguments}';
  RxString buttonview = 'Photos'.obs;
  RxInt view = 0.obs;

  var isSaveButtonEnabled = false.obs;

  //--------------------------------Albums----------------------------//

  Future getAlbums() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-users-album/$username',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      albumsList.value = (apiResponse.data as List)
          .map(
            (e) => AlbumModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPhoto.value = false;
  }

  Future getOtherPhotos() async {
    debugPrint('==========================get Photo Start');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'get-users-latest-image',
        requestData: {'username': username},
        responseDataKey: 'images');

    debugPrint('==========================get Photo After api call');
    if (apiResponse.isSuccessful) {
      debugPrint('==========================get Photo Before Model');
      debugPrint('Response success');
      photoList.value = (apiResponse.data as List)
          .map(
            (e) => PhotoModel.fromMap(e),
          )
          .toList();
      debugPrint('Response success');
      debugPrint('==========================get Photo After model');
    }
  }

  //------------------------------- PROFILE PICTURES ----------------------------//

  Future getProfilePictures() async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-albums-images',
      requestData: {
        'username': username,
        'albums_id': 'profile_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      profilePicturesList.value = (apiResponse.data as List)
          .map(
            (e) => ProfilPicturesemodel.fromMap(e),
          )
          .toList();
    }
  }

  //----------------------------------- COVER PHOTOS ----------------------------//
  Future getCoverPhotos() async {
    isLoadingCoverPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-albums-images',
      requestData: {
        'username': username,
        'albums_id': 'cover_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingCoverPhoto.value = false;

    if (apiResponse.isSuccessful) {
      coverPhotosList.value = (apiResponse.data as List)
          .map(
            (e) => ProfilPicturesemodel.fromMap(e),
          )
          .toList();
    }
  }
  //-------------------------------------- MEDIA PHOTOS ----------------------------//

  Future getMediaPhotos(String albumId) async {
    isLoadingMediaPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-albums-images',
      requestData: {
        'albums_id': albumId,
        'username': username,
      },
      responseDataKey: 'data',
    );
    isLoadingMediaPhoto.value = false;

    if (apiResponse.isSuccessful) {
      getAlbums();

      albumPhotosList.value = (apiResponse.data as List)
          .map(
            (e) => ProfilPicturesemodel.fromMap(e),
          )
          .toList();
    }
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

      Get.back();
      Get.back();
      Get.back();

      showSuccessSnackkbar(message: 'Post reported successfully');
    } else {}
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();

    getAlbums();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _apiCommunication.endConnection();
  }
}
