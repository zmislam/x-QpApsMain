import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../models/comment_model.dart';
import '../../../../../../models/profile_model.dart';
import '../../../../../../models/user.dart';
import '../../../../../../services/api_communication.dart';

class EditPostCommentController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late CommentModel commentModel;

  bool isEditing = false;
  RxInt bioLength = 0.obs;
  String? postComment;
  String? postCommentId;
  String? commentId;
  String? commentType;
  String? imageOrVideo;
  String? key;

  late TextEditingController editCommentController;

  Rx<ProfileModel?> profileModel = Rx(null);

/*=============== Edit Comment  API=====================*/
  Future<void> onTapEditCommentPost() async {
    if (editCommentController.text.length > 400) {
      // showValidationMessage();
      return;
    }

    final ApiResponse response = await _apiCommunication.doPostRequestNew(
      apiEndPoint: 'update-comments-by-direct-post/$postCommentId/$commentId',
      enableLoading: true,
      requestData: {
        'comment_name': editCommentController.text,
        'replies_comment_name': null,
        // 'comment_type': 'main_comment',
        'comment_type': commentType,
        'image_or_video': imageOrVideo,
        // 'key' : key,
      },
    );
    if (response.isSuccessful) {
      // await aboutController.getUserALLData();
      Get.back(result: true);
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  // void updateBioLength(int length) {
  //   bioLength.value = length;
  // }

  
  void showValidationMessage() {
    Get.snackbar(
      'Validation Error',
      'Please enter a toDate value before unchecking the box.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    commentModel = CommentModel();

    userModel = _loginCredential.getUserData();
    Map<String, dynamic> data = Get.arguments;
    postComment = data['post_comment'];
    postCommentId = data['post_id'];
    commentId = data['comment_id'];
    commentType = data['comment_type'];
    imageOrVideo =data['image_video'];
    key =data['key'];
    editCommentController = TextEditingController(text: postComment);

    // String privacy = data['privacy'];
    // setSelectedDropdownValue(bio);
    // getPrivacyDescription(privacy);
    // privacyModel.value = getPrivacyModel(privacy);

    super.onInit();
  }

  @override
  void onReady() {
    // aboutController;
    super.onReady();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
