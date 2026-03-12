import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../config/constants/api_constant.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../models/post.dart';
import '../../../../../models/user.dart';
import '../../../../../services/api_communication.dart';

class PostHistoryController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  RxString postId = ''.obs;
  Rx<List<PostModel>> postList = Rx([]);

  Future<void> getPostHistory() async {
    final apiResponse = await _apiCommunication.doGetRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'get-post-edit-history/$postId',
        enableLoading: true);

    if (apiResponse.isSuccessful) {
      postList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => PostModel.fromMap(element))
              .toList();

      debugPrint('list length ...........$postList');
    } else {}
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();

    userModel = _loginCredential.getUserData();
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
