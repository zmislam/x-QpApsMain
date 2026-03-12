import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/group_profile_controller.dart';
import '../../models/group_album_model.dart';
import '../../../models/group_album_model.dart';
import '../../../models/group_photo_model.dart';
import '../../../../discover_groups/models/all_group_model.dart';

import '../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../data/post_local_data.dart';
import '../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../models/user.dart';
import '../../../../../../../../../services/api_communication.dart';
import '../../../../../../../../../utils/post_utlis.dart';
import '../../../../../../../../../utils/snackbar.dart';

class GroupPhotosGalleryController extends GetxController {
  // Global Usecases
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  late UserModel userModel;
  Rx<AllGroupModel?> allGroupModel = Rx<AllGroupModel?>(null);
  GroupProfileController groupProfileController =Get.find();

  RxBool isLoadingUserPhoto = false.obs;
  Rx<List<GroupAlbumModel>> albumsList = Rx([]);
  Rx<List<GroupPhotoModel>> photoList = Rx([]);
  RxString buttonview = 'Photos of you'.obs;
  RxInt viewNumber = 0.obs;

  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  RxBool isLoadingAlbums = false.obs;
  Rx<List<GroupProfileAlbumModel>> profilePicturesList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> coverPhotosList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> albumPhotosList = Rx([]);
  Rx<List<XFile>> xfiles = Rx([]);
  RxString dropdownValue = privacyList.first.obs;
  late TextEditingController albumNameController;
  late TextEditingController editalbumNameController;
  late TextEditingController descriptionController;
  final formKey = GlobalKey<FormState>();

  var isSaveButtonEnabled = false.obs;

  //======================================================== Photos Related Functions ===============================================//

   Future getGroupAlbums() async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-groups-albums-images',
      requestData: {
        'group_id': allGroupModel.value?.id,
        'albums_id': 'cover_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      albumsList.value = (apiResponse.data as List)
          .map(
            (e) => GroupAlbumModel.fromMap(e),
          )
          .toList();
    }
  }

 ///==============================================Get Group All Photos and Vides=======================================================////
    Future getGroupPhotos() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-group-latest-image-video',
      requestData: {
       'group_id': allGroupModel.value?.id,
        },
      responseDataKey: 'images',
    );

    if (apiResponse.isSuccessful) {
      photoList.value = (apiResponse.data as List)
          .map(
            (e) => GroupPhotoModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPhoto.value = false;
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
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-groups-albums-images',
      requestData: {
        'group_id': allGroupModel.value?.id,
        'albums_id': 'cover_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

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
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      getGroupAlbums();
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

      GroupProfileAlbumModel;

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
    getGroupPhotos();
    getGroupAlbums();
    albumNameController = TextEditingController();
    editalbumNameController = TextEditingController();
    descriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();

    // albumNameController.dispose();
    editalbumNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
