import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../models/api_response.dart';
import '../../../../../../../repository/story_repository.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../controllers/home_controller.dart';
import '../model/create_story_data_model.dart';

class CreateMultiImageStoryController extends GetxController {
  Rx<List<XFile>> storyMultiImageXFile = Rx([]);
  Rx<List<CreateStoryDataModel>> sotrydDataModelList = Rx([]);
  final StoryRepository storyRepository = StoryRepository();

  late final ApiCommunication _apiCommunication;
  Future<void> shareImage(CreateStoryDataModel model) async {
    // final ApiResponse response = await _apiCommunication.doPostRequest(
    //   apiEndPoint: 'save-story',
    //   isFormData: true,
    //   requestData: model.toMap(),
    //   mediaFiles: [model.file],
    //   enableLoading: true,
    // );
    final ApiResponse response = await storyRepository.createStory(data: model.toMap(), files: [model.file]);

    if (response.isSuccessful) {}
  }

  void onPressShare() async {
    for (CreateStoryDataModel createStoryDataModel in sotrydDataModelList.value) {
      await shareImage(createStoryDataModel);
    }
    HomeController controller = Get.find();
    controller.getAllStory(forceRecallAPI: true);
    Get.back();
    Get.back();
  }

  @override
  void onInit() {
    storyMultiImageXFile.value = Get.arguments;
    sotrydDataModelList.value = storyMultiImageXFile.value.map((e) => CreateStoryDataModel(file: File(e.path), privacy: 'Public')).toList();
    storyMultiImageXFile.refresh();
    _apiCommunication = ApiCommunication();
    super.onInit();
  }

  void pickMoreImage() async {
    final pickedImageFile = await ImagePicker().pickMultiImage();
    pickedImageFile.map((e) => sotrydDataModelList.value.add(CreateStoryDataModel(file: File(e.path)))).toList();
    sotrydDataModelList.refresh();
  }
}
