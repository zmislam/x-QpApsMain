import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/api_response.dart';
import '../../../../../models/reaction_model.dart';
import '../../../../../repository/page_repository.dart';
import '../../../../../services/api_communication.dart';

class ReactionsController extends GetxController {
  late final ApiCommunication _apiCommunication;
  Rx<List<ReactionModel>> reactionList = Rx([]);
  Rx<List<ReactionModel>> likeList = Rx([]);
  Rx<List<ReactionModel>> loveList = Rx([]);
  Rx<List<ReactionModel>> hahaList = Rx([]);
  Rx<List<ReactionModel>> wowList = Rx([]);
  Rx<List<ReactionModel>> sadList = Rx([]);
  Rx<List<ReactionModel>> angryList = Rx([]);
  Rx<List<ReactionModel>> unlikeList = Rx([]);
  PageRepository pageRepository = PageRepository();

  RxBool isReactionLoding = false.obs;

  Future<void> getReactions(String postId) async {
    isReactionLoding.value = true;

    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reaction-user-lists-of-direct-post/$postId',
      responseDataKey: 'reactions',
    );
    if (response.isSuccessful) {
      reactionList.value = (response.data as List)
          .map((element) => ReactionModel.fromMap(element))
          .toList();
      calculateReaction();
      debugPrint('ok');
      isReactionLoding.value = false;
    }
  }

  void clearReactions() {
    reactionList.value.clear();
    likeList.value.clear();
    loveList.value.clear();
    hahaList.value.clear();
    wowList.value.clear();
    sadList.value.clear();
    angryList.value.clear();
    unlikeList.value.clear();
  }



  void calculateReaction() {
    for (ReactionModel reactionModel in reactionList.value) {
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
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
