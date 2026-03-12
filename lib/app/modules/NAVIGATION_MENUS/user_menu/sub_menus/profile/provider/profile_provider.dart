import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../data/login_creadential.dart';

class ProfileProvider extends GetConnect {
  final LoginCredential _loginCredential = LoginCredential();

  Future<String> profileImageUpload(String file_path, File? image_file) async {
    FormData userData = FormData({
      'profile_pic': image_file == null
          ? null
          : MultipartFile(image_file,
              filename: DateTime.now().toString() + file_path),
    });
    debugPrint('File Pathe from proider---------------------------$file_path');

    debugPrint('File Pathe ---------------------------$file_path');

    String url = '${ApiConstant.BASE_URL}change-only-profile-pic';
    String? token = _loginCredential.getAccessToken();

    Map<String, String> header = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await post(url, userData, headers: header);

    // debugPrint("ressssssssssssssssssssssssssss${response.statusCode}");
    // debugPrint("ressssssssssssssssssssssssssss${response.body}");

    if (response.statusCode == 200) {
      // getUserDataRefresh();

      // showSnackBar('Image Upload', '${response.body['message']}', Colors.blueAccent, SnackPosition.BOTTOM);
      //
      // debugPrint('get storage start ----------------------------------------');
      //
      // await getStorage.write("profile_picture", "$IMAGE_BASE_URL${response.body['data']['path']}");

      // debugPrint('get storage end ----------------------------------------${getStorage.read("profile_picture")}');

      return '';
    } else {
      // showSnackBar("Failed","Could not changed Profile picture ",Colors.red,SnackPosition.BOTTOM);
      // await getStorage.write('loginStatus',false);
      // debugPrint("status from login ......"+getStorage.read('loginStatus').toString());
      return '';
    }
  }

  Future<String> coverImageUpload(String file_path, File? image_file) async {
    FormData userData = FormData({
      'cover_pic': image_file == null
          ? null
          : MultipartFile(image_file,
              filename: DateTime.now().toString() + file_path),
    });
    debugPrint('File Pathe from proider---------------------------$file_path');

    debugPrint('File Pathe ---------------------------$file_path');

    String url = '${ApiConstant.BASE_URL}change-only-cover-pic';
    String? token = _loginCredential.getAccessToken();

    Map<String, String> header = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await post(url, userData, headers: header);

    // debugPrint("ressssssssssssssssssssssssssss${response.statusCode}");
    // debugPrint("ressssssssssssssssssssssssssss${response.body}");

    if (response.statusCode == 200) {
      // showSnackBar('Image Upload', '${response.body['message']}', Colors.blueAccent, SnackPosition.BOTTOM);
      //
      // debugPrint('get storage start ----------------------------------------');
      //
      // await getStorage.write("profile_picture", "$IMAGE_BASE_URL${response.body['data']['path']}");

      // debugPrint('get storage end ----------------------------------------${getStorage.read("profile_picture")}');

      return '${response.body['data']["path"]}';
    } else {
      // showSnackBar("Failed","Could not changed Profile picture ",Colors.red,SnackPosition.BOTTOM);
      // await getStorage.write('loginStatus',false);
      // debugPrint("status from login ......"+getStorage.read('loginStatus').toString());
      return '';
    }
  }

  // void getUserDataRefresh() async {
  //   ProfileController().isLoadingRefresh.value = true;
  //   ApiCommunication apiUserDataCommunication = ApiCommunication();
  //
  //   ApiResponse response = await apiUserDataCommunication.doPostRequest(
  //     apiEndPoint: 'get-user-info',
  //     requestData: {
  //       'username': '${LoginCredential().getUserData().username}', //'anik.ba',
  //     },
  //     responseDataKey: ApiConstant.FULL_RESPONSE,
  //   );
  //
  //   if (response.isSuccessful) {
  //     ProfileController().userModel =
  //         UserModel.fromMap((response.data as Map)['userInfo']);
  //
  //     LoginCredential().saveUserData(ProfileController().userModel);
  //     ProfileController().isLoadingRefresh.value = false;
  //   } else {
  //     ProfileController().isLoadingRefresh.value = true;
  //   }
  //
  //   debugPrint('=============getOtherUserData==============$response');
  // }
}
