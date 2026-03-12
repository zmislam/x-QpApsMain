import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../NAVIGATION_MENUS/reels/model/reels_model.dart';
import '../../../../../models/api_response.dart';
import '../../../../../services/api_communication.dart';

class ReelsReactionsController extends GetxController {
  late final ApiCommunication _apiCommunication;
  Rx<List<ReelsReactionModel>> reactionList = Rx([]);
  Rx<List<ReelsReactionModel>> likeList = Rx([]);
  Rx<List<ReelsReactionModel>> loveList = Rx([]);
  Rx<List<ReelsReactionModel>> hahaList = Rx([]);
  Rx<List<ReelsReactionModel>> wowList = Rx([]);
  Rx<List<ReelsReactionModel>> sadList = Rx([]);
  Rx<List<ReelsReactionModel>> angryList = Rx([]);
  Rx<List<ReelsReactionModel>> unlikeList = Rx([]);

  RxBool isReactionLoding = false.obs;

  void getReactions(String postId) async {

     isReactionLoding.value = true;

    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reaction-user-lists-reel-post/$postId',
      responseDataKey: 'reactions',
    );
    if (response.isSuccessful) {
      reactionList.value = (response.data as List)
          .map((element) => ReelsReactionModel.fromMap(element))
          .toList();
      calculateReaction();
      debugPrint('ok');
      isReactionLoding.value = false;
    }
  }

  void calculateReaction() {
    for (ReelsReactionModel ReelsreactionModel in reactionList.value) {
      switch (ReelsreactionModel.reaction_type) {
        case 'like':
          likeList.value.add(ReelsreactionModel);
          break;
        case 'love':
          loveList.value.add(ReelsreactionModel);
          break;
        case 'haha':
          hahaList.value.add(ReelsreactionModel);
          break;
        case 'wow':
          wowList.value.add(ReelsreactionModel);
          break;
        case 'sad':
          sadList.value.add(ReelsreactionModel);
          break;
        case 'angry':
          angryList.value.add(ReelsreactionModel);
          break;
        case 'dislike':
          unlikeList.value.add(ReelsreactionModel);
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
    String postId = Get.arguments;
    getReactions(postId);
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
