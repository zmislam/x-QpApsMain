import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../../repository/story_repository.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/sticker_emoji_model.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../services/audio_player_service.dart';
import '../../../../controllers/home_controller.dart';
import '../../add_audio/models/audio_model.dart';
import '../../components/overlay_widget.dart';
import '../../models/overlay_model.dart';
import 'dart:typed_data';
import 'dart:math' as math;

class CreateImageStoryController extends GetxController {
  HomeController homeController = Get.find();

  late final ApiCommunication _apiCommunication;
  late final ScreenshotController screenshotController;
  late final TextEditingController storyTextController;
  late final FocusNode storyTextFocusNode;
  final StoryRepository storyRepository = StoryRepository();

  Rx<bool> isFromMultiImageStory = false.obs;

  // Horizontal List Style
  final BoxDecoration horizontalListDecoration = BoxDecoration(
    color: Colors.grey.withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(10),
  );
  final EdgeInsetsGeometry horizontalListPadding = const EdgeInsets.all(10);

  // Story Text And Position
  Rx<String> storyText = ''.obs;
  Rx<Offset> textPosition =
      Offset((Get.width / 2) - 45, (Get.height / 2 - 25)).obs;

  // Overlay Widgets
  Rx<List<OverlayModel>> overlayWidgetList = Rx([]);
  Rx<bool> showDeleteButton = false.obs;
  Rx<bool> isDeleteButtonActive = false.obs;

  Rx<String> seletedPrivacy = 'public'.obs;


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
  Rx<TextAlign> storyTextAlignment = Rx(TextAlign.left);
  // Text Background Color
  Rx<Color> storyTextBackgroundColor = Rx(Colors.transparent);

  // ================================================= Story Background & Text Input =================================================
  Rx<bool> isBottomSheetVisiable = false.obs; // Story Text Input Bottom Sheet
  Rx<bool> isStoryImageListExpanded =
  Rx(false); // Story Background Bottom Sheet
  // ================================================= Story Audio =================================================
  late final AudioPlayerService audioPlayerService;
  Rx<AudioModel?> storyAudioModel = Rx(null); //
  //* ==================================================================================== Emoji ==========================================
  Rx<bool> showHintText = false.obs;

  Rx<StickerEmojiModel?> selectedEmoji = Rx(null);

  // Separate scale factors
  RxBool isColumnVisible = true.obs;

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

  Future<void> shareStory() async {
    Uint8List? screenshotData = await screenshotController.capture();
    if (screenshotData != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(screenshotData);
      shareImage(imagePath);
    }
  }

  Future<File> getScreenShotFile() async {
    Uint8List? screenshotData = await screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final file = await File(
        '${directory.path}/image${DateTime.now().millisecondsSinceEpoch}.png')
        .create();
    await file.writeAsBytes(screenshotData!);
    return file;
  }

  Future<void> shareImage(File file) async {
    final data = {
      'title': 'Text Story',
      'privacy': seletedPrivacy.value,
    };
    if (storyAudioModel.value?.id != null) {
      data['music_id'] = storyAudioModel.value?.id ?? '';
    }

    final ApiResponse response =
    await storyRepository.createStory(data: data, files: [file]);

    if (response.isSuccessful) {
      HomeController controller = Get.find();
      controller.getAllStory(forceRecallAPI: true);
      Get.back();
      Get.back();
    }
  }

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

  // ====================================================================
  // ------------------ New pinch/zoom + pan state & methods ------------
  // ====================================================================

  final RxDouble imageScale = 1.0.obs;
  final Rx<Offset> imageOffset = Offset.zero.obs;

  double _startingScale = 1.0;
  Offset _startingOffset = Offset.zero;
  Offset _normalizedOffset = Offset.zero;

  final double minScale = 0.5;
  final double maxScale = 4.0;


  // Pointer count to distinguish single-finger drags (for overlays) vs multi-finger
  int _pointerCount = 0;

  /// Call from Listener.onPointerDown in the view
  void onPointerDown() {
    _pointerCount++;
  }

  /// Call from Listener.onPointerUp/onPointerCancel in the view
  void onPointerUp() {
    _pointerCount = math.max(0, _pointerCount - 1);
  }

  /// Called from GestureDetector.onScaleStart
  void onImageScaleStart(ScaleStartDetails details) {
    _startingScale = imageScale.value;
    _startingOffset = imageOffset.value;
    _normalizedOffset = (details.focalPoint - _startingOffset) / _startingScale;
  }

  /// Called from GestureDetector.onScaleUpdate
  ///
  /// [viewportSize] should be the size of the area being transformed (pass LayoutBuilder constraints).
  void onImageScaleUpdate(ScaleUpdateDetails details) {
    double newScale = (_startingScale * details.scale).clamp(minScale, maxScale);
    final Offset focal = details.focalPoint;
    final Offset newOffset = focal - _normalizedOffset * newScale;
    imageScale.value = newScale;
    imageOffset.value = newOffset;
  }
  /// Called from GestureDetector.onScaleEnd
  void onImageScaleEnd(ScaleEndDetails details) {
    // Optionally you can use details.velocity to animate fling. Left empty for simplicity.
    // e.g. create an AnimationController to continue movement
  }

  /// Clamp offset so the image doesn't drift too far out of view.
  /// This is a simple implementation: it prevents very large translation.
  /// For perfect clamping you can compute image pixel size after scale and clamp to ensure edges stay covering viewport.
  Offset _clampOffset(Offset offset, Size viewportSize, double scale) {
    // Approximate allowed drift as a factor of viewport; tune these as needed.
    final double horizontalLimit = viewportSize.width * (scale - 1).abs() + viewportSize.width * 0.5;
    final double verticalLimit = viewportSize.height * (scale - 1).abs() + viewportSize.height * 0.5;

    final double dx = offset.dx.clamp(-horizontalLimit, horizontalLimit);
    final double dy = offset.dy.clamp(-verticalLimit, verticalLimit);

    return Offset(dx, dy);
  }

  // ====================================================================
  // ------------------ End pinch/zoom + pan state & methods ------------
  // ====================================================================

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    audioPlayerService = AudioPlayerService();

    storyTextController = TextEditingController();
    storyTextFocusNode = FocusNode();

    screenshotController = ScreenshotController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storyTextFocusNode.addListener(() {
        if (storyTextFocusNode.hasFocus) {
          debugPrint('Input field has focus!');
        } else {
          debugPrint('Input field lost focus.');
          isBottomSheetVisiable.value = false;
          storyText.value = storyTextController.text;
        }
      });
    });

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
