import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../extension/string/string.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:video_player/video_player.dart';

import '../../../../../../data/login_creadential.dart';
import '../../../../../../data/privacy_local_data.dart';
import '../../../../../../models/privacy_local_model.dart';
import '../../../../../../models/sticker_emoji_model.dart';
import '../../../../../../models/user.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../services/audio_player_service.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../../home/create_story/sub_menus/add_audio/models/audio_model.dart';
import '../../../../home/create_story/sub_menus/components/overlay_widget.dart';
import '../../../../home/create_story/sub_menus/models/overlay_model.dart';
import '../../../controllers/reels_controller.dart';
import '../model/create_reels_model.dart';
import '../model/reels_emoji_model.dart';
import '../model/reels_request_data_model.dart';
import '../model/reels_text_model.dart';

class CreateReelsController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {
  final ReelsRepository _reelsRepository = ReelsRepository();
  late UserModel userModel;
  final ReelsController _videoController = Get.find();
  Rx<bool> isEmoji = false.obs;
  Rx<bool> isText = false.obs;

  // ================================================================= Video

  Rx<XFile?> selectedFile = Rx<XFile?>(null);
  Rx<double?> videoLength = Rx<double?>(null);
  Rx<double?> selectedVideoFileSpeed = Rx<double?>(null);
  VideoPlayerController? videoPlayerController;
  RxBool isVideoInitialized = false.obs;
  RxBool isVideoPlaying = false.obs;
  Duration? position;
  Duration? duration;
  var currentRangeValues = const RangeValues(0, 0).obs;

  // Horizontal List Style

  final BoxDecoration horizontalListDecoration = BoxDecoration(
    color: Colors.grey.withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(10),
  );
  final EdgeInsetsGeometry horizontalListPadding = const EdgeInsets.all(10);

  // Story Text And Position
  Rx<String> storyText = ''.obs;
  Rx<Offset> initialTextPosition =
      Offset((Get.width / 2) - 45, (Get.height / 2 - 25)).obs;
  Rx<Offset> textPosition =
      Offset((Get.width / 2) - 45, (Get.height / 2 - 25)).obs;

  Rx<String> seletedPrivacy = 'public'.obs;

  // ================================================= Text Modification =================================================
  late final TextEditingController storyTextController;
  late final FocusNode storyTextFocusNode;
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
  Rx<Offset> emojiPosition =
      Offset((Get.width / 2) - 45, (Get.height / 2 - 160)).obs;

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

  // Video =================================================================

  late TextEditingController reelDescriptionController;
  Rx<bool> enabledComment = Rx(true);
  Rx<PrivacyLocalModel?> selectedPrivacy =
      Rx(PrivacyLocalData.privacyList.first);

  final GlobalKey<FormState> realsUploadKey = GlobalKey();

  ReelsDataModel reelsDataModel = ReelsDataModel();

/*=============== Edit About  API=====================*/
  void goToDescriptionPage() {
    reelsDataModel = ReelsDataModel(
      reelsTextModel: ReelsTextModel(
        textScale: textScale.value.toDouble(),
        reelsText: storyTextController.text,
        textColor: storyTextStyle.value.color?.value,
        textBgColor: storyTextBackgroundColor.value.value,
        textPositionX: textPosition.value.dx.toDouble(),
        textPositionY: textPosition.value.dy.toDouble(),
        reelsTextFont: storyTextStyle.value.fontFamily,
      ),
      reelsEmojiModel: ReelsEmojiModel(
        emojiScale: emojiScale.value.toDouble(),
        emojiSrc: selectedEmoji.value?.file_name,
        emojiType: selectedEmoji.value?.type,
        positionX: emojiPosition.value.dx.toDouble(),
        positionY: emojiPosition.value.dy.toDouble(),
      ),
      audioModel: storyAudioModel.value,
    );

    if (selectedFile.value!.path
        .toLowerCase()
        .endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
      Get.toNamed(Routes.REELS_DESCRIPTION,
          arguments: ReelsRequestDataModel(
              reelsDataModel,
              selectedFile.value!,
              selectedPrivacy.value?.value ?? 'public',
              currentRangeValues.value.start,
              videoLength.value ?? 0,
              userModel.id));
    } else {
      Get.toNamed(Routes.REELS_DESCRIPTION,
          arguments: ReelsRequestDataModel(
              reelsDataModel,
              selectedFile.value!,
              selectedPrivacy.value?.value ?? 'public',
              currentRangeValues.value.start,
              10,
              userModel.id));
    }
  }

  Future<void> onTapPublihReelsPost() async {
    // if (!isCreateReelsValid()) {
    //   return;
    // }

    reelsDataModel = ReelsDataModel(
      reelsTextModel: ReelsTextModel(
        textScale: textScale.value.toDouble(),
        reelsText: storyTextController.text,
        textColor: storyTextStyle.value.color?.value,
        textBgColor: storyTextBackgroundColor.value.value,
        textPositionX: textPosition.value.dx.toDouble(),
        textPositionY: textPosition.value.dy.toDouble(),
        reelsTextFont: storyTextStyle.value.fontFamily,
      ),
      reelsEmojiModel: ReelsEmojiModel(
        emojiScale: emojiScale.value.toDouble(),
        emojiSrc: selectedEmoji.value?.file_name,
        emojiType: selectedEmoji.value?.type,
        positionX: emojiPosition.value.dx.toDouble(),
        positionY: emojiPosition.value.dy.toDouble(),
      ),
      audioModel: storyAudioModel.value,
    );

    bool isSuccessful = selectedFile.value!.path
            .toLowerCase()
            .endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])
        ? await _reelsRepository.createReels(
            requestData: {
              'description': reelDescriptionController.text,
              'reels_privacy': selectedPrivacy.value?.value ?? 'public',
              'startTime': currentRangeValues.value.start,
              'endTime': 10,
              'user_id': userModel.id,
              'enabled_comment': enabledComment.value,
              'reels_data': reelsDataModel.toJson(),
            },
            video: selectedFile.value!,
          )
        : await _reelsRepository.createImageReels(requestData: {
            'description': reelDescriptionController.text,
            'reels_privacy': selectedPrivacy.value?.value ?? 'public',
            'startTime': currentRangeValues.value.start,
            'endTime': 10,
            'user_id': userModel.id,
            'enabled_comment': enabledComment.value,
            'reels_data': reelsDataModel.toJson(),
          }, image: selectedFile.value!);

    if (isSuccessful) {
      // await _videoController.getReels();
      Get.back();
      audioPlayerService.stop();
    } else {
      // showErrorSnackkbar(message: 'Something went wrong');
    }
  }

  bool isCreateReelsValid() {
    if (realsUploadKey.currentState!.validate()) {
      if (selectedFile.value != null) {
        return true;
      } else {
        showWarningSnackkbar(message: 'Video is required to add reels.');
        return false;
      }
    }
    return false;
  }

  Future<void> pickVideo() async {
    XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      selectedFile.value = video;
      videoPlayerController =
          VideoPlayerController.file(File(selectedFile.value!.path))
            ..initialize().then((_) {
              isVideoInitialized.value = true;

              duration = videoPlayerController!.value.duration;
              currentRangeValues.value =
                  RangeValues(0.0, duration!.inSeconds.toDouble());

              videoPlayerController!.play();
              isVideoPlaying.value = true;

              videoPlayerController!.addListener(() {
                position = videoPlayerController?.value.position;
                duration = videoPlayerController?.value.duration;

                if (position != null && duration != null) {
                  currentRangeValues.value = RangeValues(
                    position!.inSeconds.toDouble(),
                    currentRangeValues.value.end,
                  );
                }
              });
            });
    }
  }

  // ================================================ emoji scaling =============================================
  Rx<double> emojiScale = 1.0.obs; // Current scale
  Rx<double> emojiBaseScale = 1.0.obs; // Scale at the start of the gesture
  late AnimationController emojiAnimcontroller;
  late Animation<double> emojiAnimation;

  Rx<double> textScale = 1.0.obs; // Current scale
  Rx<double> textBaseScale = 1.0.obs; // Scale at the start of the gesture
  late AnimationController textAnimcontroller;
  late Animation<double> textAnimation;

  // ======================== initialize animation =============================
  void initializeAnimationForText() {
    textAnimcontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    textAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(CurvedAnimation(
      parent: textAnimcontroller,
      curve: Curves.easeOut,
    ));
  }

  void initializeAnimationForEmoji() {
    emojiAnimcontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    emojiAnimation =
        Tween<double>(begin: 1.0, end: 1.0).animate(CurvedAnimation(
      parent: emojiAnimcontroller,
      curve: Curves.easeOut,
    ));
  }

  void emojiAnimateScaleTo(double targetScale) {
    emojiAnimation =
        Tween<double>(begin: emojiScale.value, end: targetScale).animate(
      CurvedAnimation(parent: emojiAnimcontroller, curve: Curves.easeOut),
    );
    emojiAnimcontroller.reset();
    emojiAnimcontroller.forward();

    emojiAnimcontroller.addListener(() {
      emojiScale.value = emojiAnimation.value;
    });
  }

  void textAnimateScaleTo(double targetScale) {
    textAnimation =
        Tween<double>(begin: textScale.value, end: targetScale).animate(
      CurvedAnimation(parent: textAnimcontroller, curve: Curves.easeOut),
    );
    textAnimcontroller.reset();
    textAnimcontroller.forward();

    textAnimcontroller.addListener(() {
      textScale.value = textAnimation.value;
    });
  }

  //* ============================================================ New Variables  ============================================================
  Rx<List<OverlayModel>> overlayWidgetList = Rx([]);
  Rx<bool> showDeleteButton = false.obs;
  Rx<bool> isDeleteButtonActive = false.obs;
  Rx<Matrix4> matrix = Rx(Matrix4.identity());

  void addWidget({required OverlayModel overLayModel, int? index}) {
    OverlayWidget overlayWidget = OverlayWidget(
        key: ValueKey(overLayModel.type),
        onDragStart: onDragStart,
        onMatrixUpdate: (matrix4) {
          matrix.value = matrix4;
          vector.Vector3 scale = vector.Vector3.zero();
          vector.Quaternion rotation = vector.Quaternion.identity();
          vector.Vector3 translation = vector.Vector3.zero();

          matrix4.decompose(translation, rotation, scale);

          if (overLayModel.type == 'text') {
            textScale.value = (scale.x * scale.y);
          } else if (overLayModel.type == 'emoji') {
            emojiScale.value = (scale.x * scale.y);
            debugPrint('Emoji Scale: ${emojiScale.value}');
          }
          debugPrint(
              '================ value of matrix: ${matrix.value} ================');
        },
        onDragEnd: (offset, key) {
          if (overLayModel.type == 'text') {
            textPosition.value = offset;
          } else if (overLayModel.type == 'emoji') {
            emojiPosition.value = offset;
          }
          debugPrint('drag end ${overLayModel.type}');
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

  @override
  void onInit() {
    // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // @┃  THIS [showPopUp] HANDLES THE RETURN POPUP SHOW LOGIN WE SET IT TO    ┃
    // @┃  [true] ON INIT AND MAKE IT [false] ON RETURN AFTER COMPLETION THE    ┃
    // @┃  PAGE GETS RESET                                                      ┃
    // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    showPopUp = true;

    selectedFile.value = Get.arguments[0];
    selectedVideoFileSpeed.value = Get.arguments[1];
    videoLength.value = Get.arguments[2];
    WidgetsBinding.instance.addObserver(this);

    userModel = LoginCredential().getUserData();
    reelDescriptionController = TextEditingController();
    audioPlayerService = AudioPlayerService();
    storyTextController = TextEditingController();
    storyTextFocusNode = FocusNode();
    initializeAnimationForEmoji();
    initializeAnimationForText();
    addWidget(
      overLayModel: OverlayModel(
        widget: const SizedBox(key: ValueKey('default'), height: 1, width: 1),
        type: 'default',
      ),
    );
    overlayWidgetList.refresh();
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
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void onReady() {
    videoPlayerController?.addListener(() {
      position = videoPlayerController?.value.position;
      duration = videoPlayerController?.value.duration;

      if (position != null && duration != null) {
        currentRangeValues.value = RangeValues(
          position!.inSeconds.toDouble(),
          duration!.inSeconds.toDouble(),
        );
      }
    });

    super.onReady();
  }

  bool onBackIconPressed = false;
  bool showPopUp = true;

  @override
  void dispose() {
    textAnimcontroller.dispose();
    emojiAnimcontroller.dispose();
    videoPlayerController!.dispose();
    reelDescriptionController.dispose();
    storyTextController.dispose();
    audioPlayerService.stop();
    super.dispose();
  }

  // ========================== Observe the app state =========================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayerService.stop();
      debugPrint(
          'APP STATE ++++++++++++++++++++++++++++++++++++++ App minimized!'); // Call function when minimized
    } else if (state == AppLifecycleState.resumed) {
      debugPrint(
          'APP STATE ++++++++++++++++++++++++++++++++++++++  App resumed!'); // Call function when reopened
    } else if (state == AppLifecycleState.detached) {
      audioPlayerService.stop();
      debugPrint(
          'APP STATE ++++++++++++++++++++++++++++++++++++++ App closed!'); // Call function when closed
    }
  }
}
