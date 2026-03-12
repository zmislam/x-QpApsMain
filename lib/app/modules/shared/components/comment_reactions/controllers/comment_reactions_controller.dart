import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/comment_model.dart';
import '../../../../../models/comment_reaction_model.dart';
import '../../../../../models/user.dart';
import '../../../../../services/api_communication.dart';

class CommentReactionsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  RxBool isCommentReactionLoading = true.obs;

  Rx<List<CommentReactions>> reactionList = Rx([]);
  Rx<List<CommentReactions>> likeList = Rx([]);
  Rx<List<CommentReactions>> loveList = Rx([]);
  Rx<List<CommentReactions>> hahaList = Rx([]);
  Rx<List<CommentReactions>> wowList = Rx([]);
  Rx<List<CommentReactions>> sadList = Rx([]);
  Rx<List<CommentReactions>> angryList = Rx([]);
  Rx<List<CommentReactions>> unlikeList = Rx([]);

  void getCommentReactions(String postId, String commentId) async {
    isCommentReactionLoading.value = true;

    reactionList.value.clear();
    likeList.value.clear();
    loveList.value.clear();
    hahaList.value.clear();
    wowList.value.clear();
    sadList.value.clear();
    angryList.value.clear();
    unlikeList.value.clear();

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'reaction-user-lists-comments-of-a-direct-post',
      requestData: {
        'postId': postId,
        'commentId': commentId,
        'commentRepliesId': null
      },
      responseDataKey: 'reactions',
    );

    if (response.isSuccessful) {
      reactionList.value = (response.data as List)
          .map((element) => CommentReactions.fromJson(element))
          .toList();
      calculateReaction();
      debugPrint('ok');

      isCommentReactionLoading.value = false;
    }
  }

  void calculateReaction() {
    for (CommentReactions reactionModel in reactionList.value) {
      switch (reactionModel.reactionType) {
        case 'like':
          likeList.value.add(reactionModel);
          break;
        case 'love':
          loveList.value.add(reactionModel);
          break;
        case 'haha':
          hahaList.value.add(reactionModel);
          break;
        case 'wow':
          wowList.value.add(reactionModel);
          break;
        case 'sad':
          sadList.value.add(reactionModel);
          break;
        case 'angry':
          angryList.value.add(reactionModel);
          break;
        case 'dislike':
          unlikeList.value.add(reactionModel);
          break;
      }
    }
    likeList.refresh();
    loveList.refresh();
    hahaList.refresh();
    wowList.refresh();
    sadList.refresh();
    angryList.refresh();
    unlikeList.refresh();
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    CommentModel commentModel = Get.arguments;
    getCommentReactions('${commentModel.post_id}', '${commentModel.id}');
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
