import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../NAVIGATION_MENUS/reels/model/reels_comment_reply_model.dart';
import '../../../../NAVIGATION_MENUS/reels/model/reels_relpy_comment_reaction_model.dart';

import '../../../../../data/login_creadential.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/user.dart';
import '../../../../../services/api_communication.dart';

class ReelsCommentReplyReactionsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  RxBool isCommentReactionLoading = true.obs;

  Rx<List<ReelsRepliesCommentReaction>> reactionList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> likeList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> loveList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> hahaList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> wowList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> sadList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> angryList = Rx([]);
  Rx<List<ReelsRepliesCommentReaction>> unlikeList = Rx([]);

  void getCommentReplyReactions(
      String postId, String commentId, String commentRepliesId) async {
    isCommentReactionLoading.value = true;

    reactionList.value.clear();
    likeList.value.clear();
    loveList.value.clear();
    hahaList.value.clear();
    wowList.value.clear();
    sadList.value.clear();
    angryList.value.clear();
    unlikeList.value.clear();

    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'reaction-user-lists-comments-of-a-reel-post/$postId/$commentId/$commentRepliesId',
      responseDataKey: 'reactions',
    );

    if (response.isSuccessful) {
      // reactionList.value = (response.data as List)
      //     .map((element) => ReelsCommentReactionModel.fromJson(element))
      //     .toList();
      debugPrint('::::::::::::::MY Response: ${response.data}::::::::::::::');
      debugPrint('::::::::::::::MY Response: $postId::::::::::::::');
      debugPrint('::::::::::::::MY Response: $commentId::::::::::::::');
      debugPrint('::::::::::::::MY Response: $commentRepliesId::::::::::::::');
      reactionList.value = (response.data as List)
          .map((element) => ReelsRepliesCommentReaction.fromMap(element))
          .toList();

      calculateReaction();
      debugPrint('ok');

      isCommentReactionLoading.value = false;
    }
  }

  void calculateReaction() {
    for (ReelsRepliesCommentReaction reactionModel in reactionList.value) {
      switch (reactionModel.reaction_type) {
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

  // @override
  // void onInit() {
  //   _apiCommunication = ApiCommunication();
  //   loginCredential = LoginCredential();
  //   userModel = loginCredential.getUserData();
  //   ReelsCommentReplyModel commentReplyModel = Get.arguments;
  //   getCommentReplyReactions('${commentReplyModel.post_id}', '${commentReplyModel.id}', '${commentReplyModel.replies_comment_reactions.first.comment_replies_id}}');
  //   super.onInit();
  // }
  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    ReelsCommentReplyModel commentReplyModel = Get.arguments;

    // Find the comment that was replied to
    String repliedCommentId = '';
    for (var reaction in commentReplyModel.replies_comment_reactions ?? []) {
      if (reaction.comment_replies_id == commentReplyModel.id) {
        repliedCommentId = reaction.comment_replies_id ?? '';
        break;
      }
    }

    // Fallback to the first comment_replies_id if no match was found
    if (repliedCommentId.isEmpty) {
      repliedCommentId = commentReplyModel
              .replies_comment_reactions?.first.comment_replies_id ??
          '';
    }

    getCommentReplyReactions('${commentReplyModel.post_id}',
        '${commentReplyModel.comment_id}', repliedCommentId);
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
