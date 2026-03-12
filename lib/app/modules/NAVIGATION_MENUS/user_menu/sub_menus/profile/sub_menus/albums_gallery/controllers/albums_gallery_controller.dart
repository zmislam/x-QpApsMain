import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../../utils/post_utlis.dart';
import '../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../data/post_local_data.dart';
import '../../../../../../../../models/api_response.dart';
import '../../../../../../../../models/user.dart';
import '../../../../../../../../services/api_communication.dart';
import '../../../../../../../../utils/snackbar.dart';
import '../../../models/album_model.dart';
import '../../../models/profile_cover_albums_model.dart';

class AlbumsGalleryController extends GetxController {
  // Global Usecases
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  late UserModel userModel;

  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  RxBool isLoadingAlbums = false.obs;
  Rx<List<AlbumModel>> albumsList = Rx([]);
  Rx<List<ProfilPicturesemodel>> profilePicturesList = Rx([]);
  Rx<List<ProfilPicturesemodel>> coverPhotosList = Rx([]);
  Rx<List<ProfilPicturesemodel>> albumPhotosList = Rx([]);
  Rx<List<XFile>> xfiles = Rx([]);
  RxString dropdownValue = privacyList.first.obs;
  late TextEditingController albumNameController;
  late TextEditingController editalbumNameController;
  late TextEditingController descriptionController;
  final formKey = GlobalKey<FormState>();

  var isSaveButtonEnabled = false.obs;

  //------------------------------------- ALBUMS ----------------------------//

  Future getAlbums() async {
    isLoadingAlbums.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-users-album/${userModel.username}',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      albumsList.value = (apiResponse.data as List)
          .map(
            (e) => AlbumModel.fromMap(e),
          )
          .toList();
    }
    isLoadingAlbums.value = false;
  }

  //------------------------------- PROFILE PICTURES ----------------------------//

  int profilePageNo = 1;
  int totalProfilePages = 1;
  int profilePageSize = 20;
  RxBool isFetchingProfilePhotos = false.obs;

  Future<void> getProfilePictures() async {
    if (isFetchingProfilePhotos.value || profilePageNo > totalProfilePages) {
      return;
    }

    isFetchingProfilePhotos.value = true;
    isLoadingProfilePhoto.value = true;

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint:
          'get-users-albums-images?page_no=$profilePageNo&page_size=$profilePageSize',
      requestData: {
        'username': userModel.username,
        'albums_id': 'profile_picture',
      },
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    isLoadingProfilePhoto.value = false;
    isFetchingProfilePhotos.value = false;

    if (apiResponse.isSuccessful) {
      final Map<String, dynamic> data =
          apiResponse.data as Map<String, dynamic>;

      totalProfilePages = data['profilePicCount'] ?? 1;

      List<ProfilPicturesemodel> fetchedPhotos = (data['data'] as List<dynamic>)
          .map((e) => ProfilPicturesemodel.fromMap(e))
          .toList();

      profilePicturesList.value.addAll(fetchedPhotos);
      // profilePicturesList.refresh(); // Uncomment if you notice UI not updating
    } else {
      // Handle API error case here
    }
  }

  //----------------------------------- COVER PHOTOS ----------------------------//
  Future getCoverPhotos() async {
    isLoadingCoverPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-albums-images',
      requestData: {
        'username': userModel.username,
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
        'username': userModel.username,
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

  //-------------------------------------- PICK FILES ----------------------------//

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();
    xfiles.value.addAll(mediaXFiles);
    xfiles.refresh();
  }

  //--------------------------------------- CREATE ALBUM ----------------------------//

  Future<void> createAlbum() async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-album',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'album_title': albumNameController.text,
        'privacy': (getPostPrivacyValue(dropdownValue.value)),
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      getAlbums();
      Get.back();
      showSuccessSnackkbar(message: 'Album created successfully');
    } else {
      debugPrint('');
    }
  }
  //-------------------------------------- DELETE ALBUM ----------------------------//

  Future<void> deleteAlbum(String albumId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-album',
      requestData: {
        'album_id': albumId,
      },
    );
    if (response.isSuccessful) {
      getAlbums();
      Get.back();
      showSuccessSnackkbar(message: 'Album Deleted successfully');
    } else {
      debugPrint('');
    }
  }
  //--------------------------------------- SAVE PHOTOS ----------------------------//

  Future<void> savePhotos(String albumId) async {
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
      getAlbums();
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  //--------------------------------------- DELETE PHOTOS ----------------------------//

  Future<void> deletePhotos(String mediaId, String key) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-post-media-by-id', requestData: {
      'media_id': mediaId,
      'media': 'posts',
      'key' : key,
    });
    if (response.isSuccessful) {
      getAlbums();
      getCoverPhotos();
      getProfilePictures();
      getMediaPhotos(mediaId);

      ProfilPicturesemodel;

      Get.back();
      showSuccessSnackkbar(message: 'Photo deleted successfully');
    } else {
      debugPrint('');
    }
  }

  //---------------------------------------- EDIT ALBUM ----------------------------//

  Future<void> editalbum(String albumId) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'edit-album', requestData: {
      'album_id': albumId,
      'album_title': albumNameController.text,
      'privacy': (getPostPrivacyValue(dropdownValue.value)),
    });
    if (response.isSuccessful) {
      getAlbums();
      Get.back();
      showSuccessSnackkbar(message: 'Album updated successfully');
    } else {
      debugPrint('');
    }
  }

  late ScrollController profilePicScrollController = ScrollController();
  void _scrollListener() async {
    if (profilePicScrollController.position.pixels >=
        profilePicScrollController.position.maxScrollExtent - 150) {
      // Determine which tab is active

      if (profilePageNo <= totalProfilePages) {
        profilePageNo += 1;
        await getProfilePictures();
      }
    }
  }

  @override
  void onReady() {
    profilePicScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    profilePicScrollController = ScrollController();
    getAlbums();

    // getProfilePictures();
    albumNameController = TextEditingController();
    editalbumNameController = TextEditingController();
    descriptionController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _apiCommunication.endConnection();
    // albumNameController.dispose();
    editalbumNameController.dispose();
    descriptionController.dispose();
  }
}
