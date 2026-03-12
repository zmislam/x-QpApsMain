import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../data/story.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/sticker_emoji_model.dart';
import '../../../../../../../repository/story_repository.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../services/audio_player_service.dart';
import '../../../../controllers/home_controller.dart';
import '../../add_audio/models/audio_model.dart';
import '../../components/overlay_widget.dart';
import '../../models/overlay_model.dart';

class CreateTextStoryController extends GetxController {
  HomeController homeController = Get.find();

  late final ApiCommunication _apiCommunication;
  late final ScreenshotController screenshotController;
  late final TextEditingController storyTextController;
  final StoryRepository storyRepository = StoryRepository();

  // Horizontal List Style

  final BoxDecoration horizontalListDecoration = BoxDecoration(
    color: Colors.grey.withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(10),
  );

  // Story Text And Position
  Rx<String> storyText = ''.obs;
  Rx<String> seletedPrivacy = 'public'.obs;

// Story Background Image
  Rx<String> seletedBackgroundImage = storyListImages[0].obs;
  Rx<bool> isStoryImageListExpanded =
      Rx(false); // Story Background Bottom Sheet

  // ================================================= Text Modification =================================================
  Rx<bool> isTextModificationFocused = Rx(false);
  // Options
  Rx<bool> isTextStyleFocused = Rx(false);
  Rx<bool> isTextBackgroundFocused = Rx(false);
  Rx<bool> isTextColorFocused = Rx(false);
  Rx<bool> isTextAlignmentFocused = Rx(false);
  // Style
  Rx<TextStyle> storyTextStyle = Rx(const TextStyle(
    color: Colors.white,
    fontSize: 24,
  ));
  // Alignment
  Rx<TextAlign> storyTextAlignment = Rx(TextAlign.center);
  // Text Background Color
  Rx<Color> storyTextBackgroundColor = Rx(Colors.transparent);

  //* ==================================================================================== Emoji ==========================================
  Rx<StickerEmojiModel?> selectedEmoji = Rx(null);

  // ================================================= Story Background & Text Input =================================================
  Rx<bool> isInputTextBottomSheetVisiable =
      false.obs; // Story Text Input Bottom Sheet

  RxBool isColumnVisible = true.obs;
  // ================================================= Story Audio =================================================
  late final AudioPlayerService audioPlayerService;
  Rx<AudioModel?> storyAudioModel = Rx(null); //

  void changeTextModificationOptionsFoucs(Rx<bool> newlyFocused) {
    // Disable Other Options Foucs
    disableAllTextModificationOptions();
    // Enable newly focused Option Focus
    newlyFocused.value = true;
  }

  void disableAllTextModificationOptions() {
    isTextStyleFocused.value = false;
    isTextBackgroundFocused.value = false;
    isTextColorFocused.value = false;
    isTextAlignmentFocused.value = false;
  }

  void onPressDoneTextModification() {
    disableAllTextModificationOptions();
    isTextModificationFocused.value = false;
  }

// text zooming func
  GlobalKey textKey = GlobalKey();

//=================================Text Gestures Func End================================//

//* ============================================================ New Variables  ============================================================
  Rx<List<OverlayModel>> overlayWidgetList = Rx([]);
  Rx<bool> showDeleteButton = false.obs;
  Rx<bool> isDeleteButtonActive = false.obs;

  void addWidget({required OverlayModel overLayModel, int? index}) {
    OverlayWidget overlayWidget = OverlayWidget(
        key: ValueKey(overLayModel.type),
        onDragStart: onDragStart,
        onMatrixUpdate: (p0) {},
        onDragEnd: (offset, key) {
          showDeleteButton.value = false;
          if (offset.dy > (Get.height - 200)) {
            for (OverlayModel model in overlayWidgetList.value) {
              if (model.widget.key == key) {
                overlayWidgetList.value.remove(model);
              }
            }
            overlayWidgetList.refresh();
          }
        },
        onDragUpdate: (offset, key) {
          if (offset.dy > (Get.height - 100)) {
            if (!isDeleteButtonActive.value) {
              isDeleteButtonActive.value = true;
            }
          } else {
            if (isDeleteButtonActive.value) {
              isDeleteButtonActive.value = false;
            }
          }
        },
        child: overLayModel.widget);

    if (index != null) {
      overlayWidgetList.value[index].widget = overlayWidget;
    } else {
      overlayWidgetList.value.add(
        OverlayModel(
          type: overLayModel.type,
          widget: overlayWidget,
        ),
      );
    }

    overlayWidgetList.refresh();
  }

  void onDragStart() {
    showDeleteButton.value = true;
  }
//* ============================================================= Sharing Story =============================================================

  Future<void> shareStory() async {
    Uint8List? screenshotData = await screenshotController.capture();
    if (screenshotData != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(screenshotData);
      shareImage(imagePath);
    }
  }

  Future<void> shareImage(File file) async {
    final data = {
      'title': 'Text Story',
      'privacy': seletedPrivacy.value,
    };
    if (storyAudioModel.value?.id != null) {
      data['music_id'] = storyAudioModel.value?.id ?? '';
    }
    // final ApiResponse response = await _apiCommunication.doPostRequest(
    //   apiEndPoint: 'save-story',
    //   isFormData: true,
    //   enableLoading: true,
    //   requestData: data,
    //   mediaFiles: [file],
    // );

    final ApiResponse response =
        await storyRepository.createStory(data: data, files: [file]);

    if (response.isSuccessful) {
      HomeController controller = Get.find();
      controller.getAllStory(forceRecallAPI: true);
      Get.back();
      Get.back();
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();

    storyTextController = TextEditingController();

    screenshotController = ScreenshotController();

    seletedBackgroundImage.value = storyListImages.first;
    audioPlayerService = AudioPlayerService();

    addWidget(
      overLayModel: OverlayModel(
        widget: const SizedBox(key: ValueKey('default'), height: 1, width: 1),
        type: 'default',
      ),
    );
    overlayWidgetList.refresh();

    super.onInit();
  }

  bool onBackIconPressed = false;

  @override
  void onClose() {
    _apiCommunication.endConnection();
    storyTextController.dispose();
    audioPlayerService.stop();
    super.onClose();
  }
}
