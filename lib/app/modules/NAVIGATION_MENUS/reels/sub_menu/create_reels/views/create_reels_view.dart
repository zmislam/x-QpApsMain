import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/string/string.dart';
import '../../../../../../extension/string/string_image_path.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/image.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../extension/num.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../services/emoji_sticker_picker_service.dart';
import '../../../../../../utils/dialog.dart';
import '../../../../home/create_story/sub_menus/components/text_style_button.dart';
import '../../../../home/create_story/sub_menus/data/story_text_data.dart';
import '../../../../home/create_story/sub_menus/models/overlay_model.dart';
import '../../../../home/create_story/sub_menus/models/text_style_model.dart';
import '../components/reels_video_player.dart';
import '../controllers/create_reels_controller.dart';

class CreateReelsView extends GetView<CreateReelsController> {
  const CreateReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (controller.onBackIconPressed) {
        } else {
          if (controller.showPopUp) {
            showShareClosingDialog(title: 'Reels'.tr);
          }
        }
      },
      child: SafeArea(
        top: false,
        child: GestureDetector(
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            // ============================== app bar section =================================
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () async {
                    controller.onBackIconPressed = true;
                    if (controller.showPopUp) {
                      await showShareClosingDialog(title: 'Reels'.tr);
                    }
                  },
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24)),
              actions: [
                IconButton(
                    onPressed: () async {
                      final Map<String, dynamic> data =
                          await Get.toNamed(Routes.STORY_SETTINGS, arguments: {
                        'selected_privacy': controller.seletedPrivacy.value
                      });
                      controller.seletedPrivacy.value =
                          data['selected_privacy'];
                    },
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 24))
              ],
            ),
            body: Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    // ================================ main view ================================================
                    Obx(() {
                      if (controller.selectedFile.value != null) {
                        final filePath =
                            controller.selectedFile.value!.path.toLowerCase();
                        if (filePath.endsWithAny(
                            ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
                          return ReelsVideoPlayer(
                              videoSpeed:
                                  controller.selectedVideoFileSpeed.value ?? 1,
                              videoSrc: controller.selectedFile.value!.path);
                        } else if (filePath.endsWithAny([
                          'jpg',
                          'jpeg',
                          'png',
                          'gif',
                          'bmp',
                          'webp',
                          'heic',
                          'heif'
                        ])) {
                          return Container(
                            height: Get.height,
                            width: Get.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(
                                        controller.selectedFile.value!.path)),
                                    fit: BoxFit.cover)),
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const SizedBox();
                      }
                    }),
                    // ================================== reels modification buttons ==================================
                    Positioned(
                      right: 16,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ========================== Text Modify Button ===========================
                              PrimaryImageButton(
                                size: 24,
                                imagePath: AppAssets.MODIFY_TEXT_ICON,
                                onTap: () {
                                  controller.isText.value = true;
                                  if (controller.isText.value) {
                                    controller.isEmoji.value = false;
                                  } else {
                                    controller.isEmoji.value = true;
                                  }
                                  controller.showHintText.value = true;
                                  controller.isTextModificationFocused.value =
                                      true;
                                  showInputStoryTextBottomSheet(context);
                                },
                              ),
                              const SizedBox(height: 20),
                              // ============================= add sticker button
                              PrimaryImageButton(
                                size: 24,
                                imagePath: AppAssets.ADD_STICKER_ICON,
                                onTap: () async {
                                  controller.isEmoji.value = true;
                                  if (controller.isEmoji.value) {
                                    controller.isText.value = false;
                                  } else {
                                    controller.isText.value = true;
                                  }
                                  controller.selectedEmoji.value =
                                      await EmojiStickerPickerService()
                                          .showEmojiStrickerBottomSheet();

                                  int emojiIndex = -1;

                                  for (int i = 0;
                                      i <
                                          controller
                                              .overlayWidgetList.value.length;
                                      i++) {
                                    if (controller
                                            .overlayWidgetList.value[i].type ==
                                        'emoji') {
                                      emojiIndex = i;
                                    }
                                  }

                                  final String selected =
                                      '${ApiConstant.SERVER_IP_PORT}/assets/${controller.selectedEmoji.value?.type}/${controller.selectedEmoji.value?.file_name ?? ''}';
                                  OverlayModel overlayModel = OverlayModel(
                                    widget: PrimaryNetworkImage(
                                      key: const ValueKey('emoji'),
                                      height: 128,
                                      width: 128,
                                      imageUrl: selected,
                                    ),
                                    type: 'emoji',
                                  );

                                  if (selected
                                          .split('/')[4]
                                          .compareTo('null') ==
                                      0) {
                                    return;
                                  }
                                  if (emojiIndex == -1) {
                                    controller.addWidget(
                                      overLayModel: overlayModel,
                                    );
                                  } else {
                                    controller.addWidget(
                                      index: emojiIndex,
                                      overLayModel: overlayModel,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              // ============================== add music button ========================
                              Obx(() {
                                return controller.storyAudioModel.value == null
                                    ? PrimaryImageButton(
                                        size: 24,
                                        imagePath: AppAssets.ADD_MUSIC_ICON,
                                        onTap: () async {
                                          controller.audioPlayerService.stop();
                                          final data = await Get.toNamed(
                                              Routes.ADD_AUDIO);
                                          if (data != null) {
                                            controller.storyAudioModel.value =
                                                data;
                                            String audioUrl =
                                                '${ApiConstant.SERVER_IP_PORT}/uploads/audio/${controller.storyAudioModel.value?.audio_file ?? ''}';
                                            controller.audioPlayerService
                                                .playUrlSource(audioUrl);
                                          }
                                        },
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          controller.audioPlayerService.stop();
                                          final data = await Get.toNamed(
                                              Routes.ADD_AUDIO);
                                          if (data != null) {
                                            controller.storyAudioModel.value =
                                                data;
                                            String audioUrl =
                                                '${ApiConstant.SERVER_IP_PORT}/uploads/audio/${controller.storyAudioModel.value?.audio_file ?? ''}';
                                            controller.audioPlayerService
                                                .playUrlSource(audioUrl);
                                          }
                                        },
                                        child: CircleAvatar(
                                          foregroundImage: NetworkImage(
                                              (controller.storyAudioModel.value
                                                          ?.thumbnail ??
                                                      '')
                                                  .formatedAudioThumbnailUrl),
                                        ),
                                      );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    for (OverlayModel overlayModel
                        in controller.overlayWidgetList.value)
                      overlayModel.widget,
                    // ======================= Delete Button ===========================

                    Obx(
                      () => controller.showDeleteButton.value
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(60),
                                child: controller.isDeleteButtonActive.value
                                    ? const SizedBox(
                                        height: 128,
                                        width: 128,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 64,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 64,
                                        width: 64,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.red.shade400,
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                              ),
                            )
                          : const SizedBox(),
                    )
                  ],
                )),
            // ============================== bottom navigation section =======================
            bottomNavigationBar: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                width: Get.width,
                alignment: Alignment.center,
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 16, horizontal: 20),
                color: Colors.transparent,
                child: Obx(() => Column(
                      children: [
                        (!controller.showDeleteButton.value)
                            ? SizedBox(
                                width: Get.width,
                                child: PrimaryButton(
                                  borderRadius: BorderRadius.circular(5),
                                  onPressed: () async {
                                    controller.goToDescriptionPage();
                                  },
                                  text: 'Create Reels'.tr,
                                  fontSize: 16,
                                  verticalPadding: 16,
                                ),
                              )
                            : 0.h,
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showInputStoryTextBottomSheet(BuildContext context) async {
    controller.onPressDoneTextModification();
    controller.isBottomSheetVisiable.value = true;
    controller.isTextModificationFocused.value = true;
    await Get.bottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      // backgroundColor: Colors.red,
      isScrollControlled: true,
      GestureDetector(
        onTap: () {
          // On tap outside story text
          FocusScope.of(context).unfocus(); // Dismiss keyboard
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // color: Colors.indigo,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // =================================== Popup TextFormField for getting story text ===================================//
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ==================================================== Text Style
                      PrimaryImageButton(
                        imagePath: AppAssets.MODIFY_TEXT_ICON,
                        onTap: () {
                          controller.changeTextModificationOptionsFoucs(
                              controller.isTextStyleFocused);
                        },
                      ),
                      16.w,

                      // ==================================================== Text Background
                      TextStyleButton(
                        isSelected: controller.isTextBackgroundFocused.value,
                        onTap: () {
                          controller.changeTextModificationOptionsFoucs(
                              controller.isTextBackgroundFocused);
                        },
                      ),
                      16.w,

                      // ==================================================== Text Color
                      PrimaryImageButton(
                        size: 40,
                        imagePath: AppAssets.TEXT_COLOR_ICON,
                        onTap: () {
                          controller.changeTextModificationOptionsFoucs(
                              controller.isTextColorFocused);
                        },
                      ),
                      16.w,

                      // ==================================================== Text Alignment
                      PrimaryImageButton(
                        imagePath: AppAssets.ALIGN_LEFT_ICON,
                        onTap: () {
                          controller.changeTextModificationOptionsFoucs(
                              controller.isTextAlignmentFocused);
                        },
                      ),
                      16.w,
                      PrimaryButton(
                        verticalPadding: 0,
                        horizontalPadding: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          // controller.onPressDoneTextModification();
                          FocusScope.of(context).unfocus();
                          // controller.isColumnVisible.value = true;
                          Get.back();
                        },
                        text: 'Done'.tr,
                      ),
                      10.w,
                    ],
                  ),
                  160.h,
// ==================================  Bottom Sheet TextFormField
                  // controller.storyTextAlignment.value,
                ],
              ),
              Obx(() => Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          backgroundColor:
                              controller.storyTextBackgroundColor.value,
                          color: controller.storyTextStyle.value.color,
                          fontSize: controller.storyTextStyle.value.fontSize,
                          fontFamily:
                              controller.storyTextStyle.value.fontFamily,
                          fontWeight:
                              controller.storyTextStyle.value.fontWeight,
                        ),
                        cursorColor: controller.storyTextStyle.value.color,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          focusColor: Colors.transparent,
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          hintText: 'Write your story here...'.tr,
                          counterText: '',
                        ),
                        textAlign: controller.storyTextAlignment.value,
                        focusNode: controller.storyTextFocusNode,
                        controller: controller.storyTextController,
                        maxLines: null, // Allow for unlimited lines
                        expands: true, // Expand to fill available space
                        autofocus: true,
                        maxLength: 500,
                        onFieldSubmitted: (value) {
                          // Handle submission if needed
                        },
                      ),
                    ),
                  )),
              // TextStyle Focused
              Obx(
                () => Visibility(
                  visible: controller.isTextStyleFocused.value,
                  child: Positioned(
                    height: 64,
                    bottom: 40,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: controller.horizontalListPadding,
                      decoration: controller.horizontalListDecoration,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => 10.w,
                        scrollDirection: Axis.horizontal,
                        itemCount: StoryTextData.textTyleList.length,
                        itemBuilder: (BuildContext context, int index) {
                          TextStyleModel textStyleModel =
                              StoryTextData.textTyleList[index];
                          return InkWell(
                            onTap: () {
                              controller.storyTextStyle.value =
                                  controller.storyTextStyle.value.copyWith(
                                      fontFamily:
                                          textStyleModel.style.fontFamily);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                textStyleModel.title,
                                style: textStyleModel.style,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // ==================================================== Text Background Color List
              // if (controller.isTextBackgroundFocused.value)
              Obx(
                () => Visibility(
                  visible: controller.isTextBackgroundFocused.value,
                  child: Positioned(
                    height: 64,
                    bottom: 40,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: controller.horizontalListPadding,
                      decoration: controller.horizontalListDecoration,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => 10.w,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            StoryTextData.storyTextBackgroundColorList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Color color =
                              StoryTextData.storyTextBackgroundColorList[index];
                          return InkWell(
                            onTap: () {
                              controller.storyTextBackgroundColor.value = color;
                            },
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================== Text Color List
              // if (controller.isTextColorFocused.value)
              Obx(
                () => Visibility(
                  visible: controller.isTextColorFocused.value,
                  child: Positioned(
                    height: 64,
                    bottom: 40,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: controller.horizontalListPadding,
                      decoration: controller.horizontalListDecoration,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => 10.w,
                        scrollDirection: Axis.horizontal,
                        itemCount: StoryTextData.storyTextColorList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Color color = StoryTextData.storyTextColorList[index];
                          return InkWell(
                            onTap: () {
                              controller.storyTextStyle.value = controller
                                  .storyTextStyle.value
                                  .copyWith(color: color);
                              controller.storyTextStyle.refresh();
                            },
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // ==================================================== Text Alignment List
              // if (controller.isTextAlignmentFocused.value)
              Obx(
                () => Visibility(
                  visible: controller.isTextAlignmentFocused.value,
                  child: Positioned(
                    height: 64,
                    bottom: 40,
                    left: 64,
                    right: 64,
                    child: Container(
                      padding: controller.horizontalListPadding,
                      decoration: controller.horizontalListDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryImageButton(
                            imagePath:
                                StoryTextData.textAlignmentList[0].imagePath,
                            onTap: () {
                              controller.storyTextAlignment.value =
                                  StoryTextData
                                      .textAlignmentList[0].textAlignment;
                            },
                          ),
                          40.w,
                          PrimaryImageButton(
                            imagePath:
                                StoryTextData.textAlignmentList[1].imagePath,
                            onTap: () {
                              controller.storyTextAlignment.value =
                                  StoryTextData
                                      .textAlignmentList[1].textAlignment;
                            },
                          ),
                          40.w,
                          PrimaryImageButton(
                            imagePath:
                                StoryTextData.textAlignmentList[2].imagePath,
                            onTap: () {
                              controller.storyTextAlignment.value =
                                  StoryTextData
                                      .textAlignmentList[2].textAlignment;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================== Create Your Story Button ============================================
            ],
          ),
        ),
      ),
    );

    String text = controller.storyTextController.text;
    controller.storyText.value = text;

    int textIndex = -1;

    for (int i = 0; i < controller.overlayWidgetList.value.length; i++) {
      if (controller.overlayWidgetList.value[i].type == 'text') {
        textIndex = i;
      }
    }

    OverlayModel overlayModel = OverlayModel(
      type: 'text',
      widget: Container(
        key: const ValueKey('text'),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: controller.storyTextBackgroundColor.value,
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          controller.storyText.value,
          style: controller.storyTextStyle.value,
          textAlign: controller.storyTextAlignment.value,
        ),
      ),
    );

    if (textIndex == -1) {
      controller.addWidget(
        overLayModel: overlayModel,
      );
    } else {
      controller.addWidget(
        index: textIndex,
        overLayModel: overlayModel,
      );
    }
  }
}
