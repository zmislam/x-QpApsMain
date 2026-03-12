import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../NAVIGATION_MENUS/reels/model/reels_comment_model.dart';

import '../../../../../data/login_creadential.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/user.dart';
import '../../../../../services/api_communication.dart';

class ReelsCommentReactionsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  RxBool isCommentReactionLoading = true.obs;

  Rx<List<ReelsCommentReactionModel>> reactionList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> likeList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> loveList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> hahaList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> wowList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> sadList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> angryList = Rx([]);
  Rx<List<ReelsCommentReactionModel>> unlikeList = Rx([]);

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

    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reaction-user-lists-comments-of-a-reel-post/$postId/$commentId/null',
      
      responseDataKey: 'reactions',
    );

    if (response.isSuccessful) {
      // reactionList.value = (response.data as List)
      //     .map((element) => ReelsCommentReactionModel.fromJson(element))
      //     .toList();
      debugPrint('::::::::::::::MY Response: ${response.data}::::::::::::::');
    reactionList.value = (response.data as List)
    .map((element) => ReelsCommentReactionModel.fromMap(element )).toList();
    


      calculateReaction();
      debugPrint('ok');

      isCommentReactionLoading.value = false;
    }
  }

  void calculateReaction() {
    for (ReelsCommentReactionModel reactionModel in reactionList.value) {
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

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    ReelsCommentModel commentModel = Get.arguments;
    getCommentReactions('${commentModel.post_id}', '${commentModel.id}');
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
