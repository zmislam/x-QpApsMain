import 'package:get/get.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/comment_model.dart';
import '../../../../../models/comment_reply_reaction.dart';
import '../../../../../models/user.dart';
import '../../../../../services/api_communication.dart';

class CommentReplayReactionsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;

  Rx<List<ReplyReactions>> replyReactionList = Rx([]);
  Rx<List<ReplyReactions>> replyLikeList = Rx([]);
  Rx<List<ReplyReactions>> replyLoveList = Rx([]);
  Rx<List<ReplyReactions>> replyHahaList = Rx([]);
  Rx<List<ReplyReactions>> replyWowList = Rx([]);
  Rx<List<ReplyReactions>> replySadList = Rx([]);
  Rx<List<ReplyReactions>> replyAngryList = Rx([]);
  Rx<List<ReplyReactions>> replyUnlikeList = Rx([]);
  RxBool isReplyReactionLoading = true.obs;

  void getCommentReplyReactions(
      String postId, String commentId, String commentRepliesId) async {
    replyReactionList.value.clear();
    replyLikeList.value.clear();
    replyLoveList.value.clear();
    replyHahaList.value.clear();
    replyWowList.value.clear();
    replySadList.value.clear();
    replyAngryList.value.clear();
    replyUnlikeList.value.clear();

    isReplyReactionLoading.value = true;

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'reaction-user-lists-comments-of-a-direct-post',
      requestData: {
        'postId': postId,
        'commentId': commentId,
        'commentRepliesId': commentRepliesId
      },
      responseDataKey: 'reactions',
    );

    if (response.isSuccessful) {
      replyReactionList.value = (response.data as List)
          .map((element) => ReplyReactions.fromJson(element))
          .toList();
      calculateReplyReaction();

      isReplyReactionLoading.value = false;
    }
  }

  void calculateReplyReaction() {
    for (ReplyReactions reactionModel in replyReactionList.value) {
      switch (reactionModel.reactionType) {
        case 'like':
          replyLikeList.value.add(reactionModel);
          break;
        case 'love':
          replyLoveList.value.add(reactionModel);
          break;
        case 'haha':
          replyHahaList.value.add(reactionModel);
          break;
        case 'wow':
          replyWowList.value.add(reactionModel);
          break;
        case 'sad':
          replySadList.value.add(reactionModel);
          break;
        case 'angry':
          replyAngryList.value.add(reactionModel);
          break;
        case 'dislike':
          replyUnlikeList.value.add(reactionModel);
          break;
      }
    }
    replyLikeList.refresh();
    replyLoveList.refresh();
    replyHahaList.refresh();
    replyWowList.refresh();
    replySadList.refresh();
    replyAngryList.refresh();
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    CommentReplay commentModel = Get.arguments;
    getCommentReplyReactions('${commentModel.post_id}',
        '${commentModel.comment_id}', '${commentModel.id}');
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
