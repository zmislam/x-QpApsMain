import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/group_profile_controller.dart';
import '../../models/group_album_model.dart';
import '../../../models/group_album_model.dart';
import '../../../../discover_groups/models/all_group_model.dart';
import '../../../../../profile/models/profile_cover_albums_model.dart';
import '../../../../../../../../../utils/post_utlis.dart';
import '../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../data/post_local_data.dart';
import '../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../models/user.dart';
import '../../../../../../../../../services/api_communication.dart';
import '../../../../../../../../../utils/snackbar.dart';

class GroupAlbumsGalleryController extends GetxController {
  // Global Usecases
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  late UserModel userModel;

  GroupProfileController groupProfileController = Get.find();
   Rx<AllGroupModel?> allGroupModel = Rx<AllGroupModel?>(null);


  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  RxBool isLoadingAlbums = false.obs;
  Rx<List<GroupAlbumModel>> albumsList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> profilePicturesList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> coverPhotosList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> albumPhotosList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> groupProfileAlbumList = Rx([]);

  Rx<List<XFile>> xfiles = Rx([]);
  RxString dropdownValue = privacyList.first.obs;
  late TextEditingController albumNameController;
  late TextEditingController editalbumNameController;
  late TextEditingController descriptionController;
  final formKey = GlobalKey<FormState>();

  var isSaveButtonEnabled = false.obs;

  //------------------------------------- ALBUMS ----------------------------//

  Future getGroupAlbums() async {
    isLoadingAlbums.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-group-album/${allGroupModel.value?.id}',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      albumsList.value = (apiResponse.data as List)
          .map(
            (e) => GroupAlbumModel.fromMap(e),
          )
          .toList();
    }
    isLoadingAlbums.value = false;
  }

  //------------------------------- PROFILE PICTURES ----------------------------//

  Future getProfilePictures() async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-albums-images',
      requestData: {
        'username': userModel.username,
        'albums_id': 'profile_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      profilePicturesList.value = (apiResponse.data as List)
          .map(
            (e) => GroupProfileAlbumModel.fromMap(e),
          )
          .toList();
    }
  }

  //----------------------------------- COVER PHOTOS ----------------------------//
  Future getGroupCoverPhotos() async {
    isLoadingCoverPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-groups-albums-images',
      requestData: {
        'group_id': allGroupModel.value?.id,
              
        'albums_id': 'cover_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingCoverPhoto.value = false;

    if (apiResponse.isSuccessful) {
      coverPhotosList.value = (apiResponse.data as List)
          .map(
            (e) => GroupProfileAlbumModel.fromMap(e),
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
      getGroupAlbums();

      albumPhotosList.value = (apiResponse.data as List)
          .map(
            (e) => GroupProfileAlbumModel.fromMap(e),
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
        'group_id':groupProfileController.allGroupModel.value?.id
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      getGroupAlbums().whenComplete(()=>  showSuccessSnackkbar(message: 'Album created successfully'));
      Get.back();
    
    } else {
      debugPrint('');
    }
  }

  // // ===========================Get Group Albums==========================//
  // Future getGroupAlbums() async {
  //   isLoadingProfilePhoto.value = true;
  //   ApiResponse apiResponse = await _apiCommunication.doPostRequest(
  //     apiEndPoint: 'get-groups-albums-images',
  //     requestData: {
  //       'group_id': allGroupModel.value?.id,
  //       'albums_id': 'cover_picture',
  //     },
  //     responseDataKey: 'data',
  //   );
  //   isLoadingProfilePhoto.value = false;

  //   if (apiResponse.isSuccessful) {
  //     groupProfileAlbumList.value = (apiResponse.data as List)
  //         .map(
  //           (e) => GroupProfileAlbumModel.fromMap(e),
  //         )
  //         .toList();
  //   }
  // }
  //-------------------------------------- DELETE ALBUM ----------------------------//

  Future<void> deleteAlbum(String albumId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-album',
      requestData: {
        'album_id': albumId,
      },
    );
    if (response.isSuccessful) {
      getGroupAlbums();
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
      getGroupAlbums();
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
      'key': key,
    });
    if (response.isSuccessful) {
      getGroupAlbums();
      getGroupCoverPhotos();
      getProfilePictures();
      getMediaPhotos(mediaId);

      ProfilPicturesemodel;

      // Get.back();
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
      getGroupAlbums();
      Get.back();
      showSuccessSnackkbar(message: 'Album updated successfully');
    } else {
      debugPrint('');
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    allGroupModel = Get.arguments;
    getGroupAlbums();

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
