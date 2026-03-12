import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../components/button.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../data/story.dart';
import '../../../../../../../extension/num.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/emoji_sticker_picker_service.dart';
import '../../../../../../../utils/dialog.dart';
import '../../components/text_style_button.dart';
import '../../data/story_text_data.dart';
import '../../models/overlay_model.dart';
import '../../models/text_style_model.dart';
import '../controllers/create_text_story_controller.dart';

class CreateTextStoryView extends GetView<CreateTextStoryController> {
  const CreateTextStoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (controller.onBackIconPressed) {
        } else {
          if (!didPop) {
            showShareClosingDialog(title: 'Story'.tr);
          }
        }
      },
      child: Obx(
        () => Scaffold(
          body: Stack(
            children: [
              //* ==================================================== Screenshot Taking Area Start ============================================

              Screenshot(
                controller: controller.screenshotController,
                child: Container(
                  key: controller.textKey,
                  decoration: BoxDecoration(
                    // ============================================== Seleted Background Image

                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        controller.seletedBackgroundImage.value,
                      ),
                    ),
                  ),
                  child: Obx(
                    () => Stack(
                      children: [
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

                        // //* ============================================== Text Area ==============================================
                      ],
                    ),
                  ),
                ),
              ),
              //* ==================================================== Screenshot Taking Area End ============================================

              // ==================================================== Back Button ============================================
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  onPressed: () async {
                    controller.onBackIconPressed = true;
                    await showShareClosingDialog(title: 'Story'.tr);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              //* ==================================================== Story Modification Buttons ============================================

              Positioned(
                top: Get.height / 2 - 100,
                right: 10,
                child: Obx(
                  () => Visibility(
                    visible: controller.isColumnVisible.value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          // ================================================================= Text Modify Button
                          PrimaryImageButton(
                            imagePath: AppAssets.MODIFY_TEXT_ICON,
                            onTap: () async {
                              controller.isTextModificationFocused.value = true;
                              controller.isColumnVisible.value =
                                  false; // Hide column
                              controller.storyText.value =
                                  await showInputStoryTextBottomSheet(context);
                              controller.isInputTextBottomSheetVisiable.value =
                                  false; // Hide
                            },
                          ),
                          const SizedBox(height: 32),
                          // ================================================================= Add Sticker Button
                          PrimaryImageButton(
                            imagePath: AppAssets.ADD_STICKER_ICON,
                            onTap: () async {
                              controller.isColumnVisible.value =
                                  false; // Hide column
                              // controller.selectedEmoji.value =
                              controller.selectedEmoji.value =
                                  await EmojiStickerPickerService()
                                      .showEmojiStrickerBottomSheet();
                              controller.isColumnVisible.value =
                                  true; // Hide column

                              int emojiIndex = -1;

                              for (int i = 0;
                                  i < controller.overlayWidgetList.value.length;
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

                              if (selected.split('/')[4].compareTo('null') ==
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
                          const SizedBox(height: 32),
                          // ================================================================= Change Background Button
                          PrimaryImageButton(
                            imagePath: AppAssets.CHANGE_BAKGROUND_ICON,
                            onTap: () {
                              controller.isColumnVisible.value =
                                  false; // Hide column
                              showChangeBackgroundBottomSheet();
                            },
                          ),
                          const SizedBox(height: 32),
                          // ================================================================= Add Music Button
                          controller.storyAudioModel.value == null
                              ? PrimaryImageButton(
                                  imagePath: AppAssets.ADD_MUSIC_ICON,
                                  onTap: () async {
                                    controller.isColumnVisible.value =
                                        true; // Hide column
                                    controller.audioPlayerService.stop();
                                    final data =
                                        await Get.toNamed(Routes.ADD_AUDIO);
                                    if (data != null) {
                                      controller.storyAudioModel.value = data;
                                      String audioUrl =
                                          '${ApiConstant.SERVER_IP_PORT}/uploads/audio/${controller.storyAudioModel.value?.audio_file ?? ''}';
                                      controller.audioPlayerService
                                          .playUrlSource(audioUrl);
                                    }
                                  },
                                )
                              : InkWell(
                                  onTap: () async {
                                    controller.isColumnVisible.value =
                                        true; // Hide column
                                    controller.audioPlayerService.stop();
                                    final data =
                                        await Get.toNamed(Routes.ADD_AUDIO);
                                    if (data != null) {
                                      controller.storyAudioModel.value = data;
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
                                          .formatedAudioThumbnailUrl,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================== Create Your Story Button ============================================

              Positioned(
                bottom: 50,
                right: 20,
                left: 10,
                child: Visibility(
                  visible: (!controller.isInputTextBottomSheetVisiable.value),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final Map<String, dynamic> data = await Get.toNamed(
                              Routes.STORY_SETTINGS,
                              arguments: {
                                'selected_privacy':
                                    controller.seletedPrivacy.value
                              });
                          controller.seletedPrivacy.value =
                              data['selected_privacy'];
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      10.w,
                      (!controller.showDeleteButton.value)
                          ? Expanded(
                              child: PrimaryButton(
                                onPressed: () {
                                  if (controller.storyTextController.text
                                      .trim()
                                      .isNotEmpty) {
                                    controller.shareStory();
                                  }
                                },
                                text: 'Create Your Story'.tr,
                                fontSize: 14,
                                verticalPadding: 15,
                              ),
                            )
                          : 0.h,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* ===================================================================== Bottom Sheet for Getting Story Text =====================================================================

  Future<String> showInputStoryTextBottomSheet(BuildContext context) async {
    controller.onPressDoneTextModification();
    controller.isInputTextBottomSheetVisiable.value = true;
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
                          controller.isColumnVisible.value = true;
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
                      // Adjust width
                      height: MediaQuery.of(context).size.height * 0.3,
                      // Adjust height for 10 lines
                      padding: const EdgeInsets.all(16.0),
                      // Add padding for better UI
                      decoration: BoxDecoration(
                        color: Colors
                            .transparent, // Background color for visibility
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          backgroundColor:
                              controller.storyTextBackgroundColor.value,
                          // Mini box behind text
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
                        controller: controller.storyTextController,
                        maxLines: null,
                        // Allow for unlimited lines
                        expands: true,
                        // Expand to fill available space
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
                      padding: const EdgeInsets.all(10),
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
                      padding: const EdgeInsets.all(10),
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
                      padding: const EdgeInsets.all(10),
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
                      padding: const EdgeInsets.all(10),
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

    return text;
  }

  //* ===================================================================== Bottom Sheet for Changing Background Image =====================================================================

  void showChangeBackgroundBottomSheet() {
    controller.isStoryImageListExpanded.value = true;
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: controller.horizontalListDecoration,
                height: 64,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storyListImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    String itemBg = storyListImages[index];
                    return InkWell(
                      onTap: () {
                        controller.seletedBackgroundImage.value = itemBg;
                        controller.isColumnVisible.value = true;
                        Get.back();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              scale: .5,
                              image: AssetImage(itemBg),
                            ),
                            shape: BoxShape.circle),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
