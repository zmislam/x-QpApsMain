import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../models/story_reaction_model.dart';

import '../../../config/constants/api_constant.dart';
import '../../../services/api_communication.dart';

class StoryReactionController extends GetxController {
  RxBool isLoadingStory = true.obs;
  late ApiCommunication _apiCommunication;
  Rx<List<StoryReactionModel>> storytList = Rx([]);

  String storyID = Get.arguments;

  Future<void> getStoriesView() async {
    debugPrint(
        '=================getStoriesView Start===============================================');

    isLoadingStory.value = true;
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'single-story',
        requestData: {
          'story_id': storyID,
        });
    isLoadingStory.value = false;

    if (apiResponse.isSuccessful) {
      storytList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => StoryReactionModel.fromJson(element))
              .toList();

      debugPrint('.stroy list................${storytList.value}');
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }
  }

  @override
  void onClose() {}

  @override
  void onReady() {}

  @override
  void onInit() {
    super.onInit();
    _apiCommunication = ApiCommunication();
    getStoriesView();
  }
}
