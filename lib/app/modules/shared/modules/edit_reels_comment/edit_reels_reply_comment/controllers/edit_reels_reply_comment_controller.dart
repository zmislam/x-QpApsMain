import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../models/comment_model.dart';
import '../../../../../../models/profile_model.dart';
import '../../../../../../models/user.dart';
import '../../../../../../services/api_communication.dart';

class EditReelsReplyCommentController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  // late CommentModel commentModel;
  late CommentReplay commentReplayModel;

  bool isEditing = false;
  RxInt bioLength = 0.obs;
  String? replyComment;
  String? replyPostId;
  String? replyCommentId;
  String? commentType;
  String? imageOrVideo;
  String? key;
  late TextEditingController editCommentReplyController;

  Rx<ProfileModel?> profileModel = Rx(null);

/*=============== Edit Comment  API=====================*/
  Future<void> onTapEditReplyCommentPost() async {
    if (editCommentReplyController.text.length > 400) {
      // showValidationMessage();
      return;
    }

    final ApiResponse response = await _apiCommunication.doPostRequestNew(
     
      apiEndPoint: 'update-comments-by-reel-post/$replyPostId/$replyCommentId',
      enableLoading: true,
      requestData: {
        'comment_name': null,
        'replies_comment_name': editCommentReplyController.text,
        // 'comment_type': 'main_comment',
        'comment_type': commentType,
        'image_or_video': imageOrVideo,
        'key' : key,
      },
    );
    if (response.isSuccessful) {
       debugPrint('replyPostId :::::::::::: $replyPostId ::::::::::::::::::::::');
       debugPrint('replyCommentId:::::::::::::: : $replyCommentId ::::::::::::::::::::::');
      // await aboutController.getUserALLData();
      Get.back(result: true);
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  // void updateBioLength(int length) {
  //   bioLength.value = length;
  // }



  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    // commentModel = CommentModel();
    commentReplayModel = CommentReplay();

    userModel = _loginCredential.getUserData();
    Map<String, dynamic> data = Get.arguments;
    replyComment = data['reply_comment'];
    replyPostId = data['replay_post_id'];
    replyCommentId = data['comment_replay_id'];
    commentType = data['comment_type'];
    imageOrVideo =data['image_video'];
    key =data['key'];
    editCommentReplyController = TextEditingController(text: replyComment);

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
