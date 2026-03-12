import 'package:get/get.dart';

import '../../../../data/login_creadential.dart';
import '../../../../models/api_response.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/user.dart';
import '../../../../services/api_communication.dart';
import '../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/profile_cover_albums_model.dart';

class ProfileImageSilderController extends GetxController {
  final count = 0.obs;
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  RxBool isLoadingProfilePhoto = true.obs;
  RxBool isLoadingCoverPhoto = true.obs;
  late UserModel userModel;
  Rx<List<ProfilPicturesemodel>> profilePicturesList = Rx([]);
  Rx<List<ProfilPicturesemodel>> coverPhotosList = Rx([]);
  Rx<ProfileModel?> profileModel = Rx(null);

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

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }

  void increment() => count.value++;
}
