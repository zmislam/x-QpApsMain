import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../components/button.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/num.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/emoji_sticker_picker_service.dart';
import '../../../../../../../utils/dialog.dart';
import '../../components/text_style_button.dart';
import '../../create_multi_image_story/model/create_story_data_model.dart';
import '../../data/story_text_data.dart';
import '../../models/overlay_model.dart';
import '../../models/text_style_model.dart';
import '../controllers/create_image_story_controller.dart';

class CreateImageStoryView extends GetView<CreateImageStoryController> {
  const CreateImageStoryView({super.key});

  @override
  Widget build(BuildContext context) {
    File? storyImageFile;
    if (Get.arguments != null) {
      storyImageFile = Get.arguments[0];
      controller.isFromMultiImageStory.value = Get.arguments[1] ?? false;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (controller.onBackIconPressed) {
        } else {
          if (controller.isFromMultiImageStory.value) {
          } else {
            //showShareClosingDialog(title: 'Story'.tr);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Obx(() => Stack(
              children: [
                //* ==================================================== Screenshot Taking Area ============================================

                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Screenshot(
                    controller: controller.screenshotController,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Use Gesture/Listener around the transformable area
                        return Listener(
                          // track pointer counts so we only react to multi-touch for image zoom/pan
                          onPointerDown: (_) => controller.onPointerDown(),
                          onPointerUp: (_) => controller.onPointerUp(),
                          onPointerCancel: (_) => controller.onPointerUp(),
                          child: GestureDetector(
                            onScaleStart: controller.onImageScaleStart,
                            onScaleUpdate: controller.onImageScaleUpdate,
                            onScaleEnd: controller.onImageScaleEnd,
                            child: Obx(() {
                              return Transform(
                                transform: Matrix4.identity()
                                  ..translate(controller.imageOffset.value.dx, controller.imageOffset.value.dy)
                                  ..scale(controller.imageScale.value),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.grey.shade400, Colors.white], // Adjust colors as needed
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    image: storyImageFile != null
                                        ? DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: FileImage(File(storyImageFile.path)),
                                    )
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      for (OverlayModel overlayModel in controller.overlayWidgetList.value)
                                        overlayModel.widget,
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ==================================================== Screenshot Taking Area

                // ==================================================== Back Button ============================================
                if (controller.isTextModificationFocused.value == false)
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      onPressed: () async {
                        showShareClosingDialog(title: 'Story'.tr);
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
                  top: Get.height / 2 - 128,
                  right: 10,
                  child: Obx(
                    () => Visibility(
                      visible: controller.isColumnVisible.value,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // ================================================================= Text Modify Button
                            PrimaryImageButton(
                              imagePath: AppAssets.MODIFY_TEXT_ICON,
                              onTap: () {
                                controller.showHintText.value = true;
                                controller.isTextModificationFocused.value =
                                    true;
                                controller.isColumnVisible.value =
                                    false; // Hide column
                                showInputStoryTextBottomSheet(
                                    context, storyImageFile!.path);
                              },
                            ),
                            // ================================================================= Add Sticker Button
                            const SizedBox(height: 32),
                            PrimaryImageButton(
                              imagePath: AppAssets.ADD_STICKER_ICON,
                              onTap: () async {
                                controller.isColumnVisible.value =
                                    false; // Hide column
                                controller.selectedEmoji.value =
                                    await EmojiStickerPickerService()
                                        .showEmojiStrickerBottomSheet();
                                controller.isColumnVisible.value =
                                    true; // Hide column

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
                            // ================================================================= Add Music Button
                            controller.storyAudioModel.value == null
                                ? PrimaryImageButton(
                                    imagePath: AppAssets.ADD_MUSIC_ICON,
                                    onTap: () async {
                                      controller.isColumnVisible.value = true;
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
                                      controller.isColumnVisible.value = true;
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
                                      foregroundImage: NetworkImage((controller
                                                  .storyAudioModel
                                                  .value
                                                  ?.thumbnail ??
                                              '')
                                          .formatedAudioThumbnailUrl),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ==================================================== Text Modification Options ============================================

                // ==================================================== Text Style List
                Obx(
                  () => Positioned(
                    height: 64,
                    bottom: 40,
                    left: 10,
                    right: 10,
                    child: Visibility(
                      visible: controller.isTextStyleFocused.value,
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
                if (controller.isTextBackgroundFocused.value)
                  Positioned(
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
                // ==================================================== Text Color List
                if (controller.isTextColorFocused.value)
                  Positioned(
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
                // ==================================================== Text Alignment List
                if (controller.isTextAlignmentFocused.value)
                  Positioned(
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
                      )),

                Positioned(
                  bottom: 20,
                  right: 20,
                  left: 10,
                  child: Visibility(
                    visible: (!controller.isBottomSheetVisiable.value),
                    child: Row(
                      children: [
                        //  if (controller.isTextModificationFocused.value == false)
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
                                child: controller.isFromMultiImageStory.value
                                    ? PrimaryButton(
                                        onPressed: () async {
                                          File file = await controller
                                              .getScreenShotFile();
                                          CreateStoryDataModel reelsData =
                                              CreateStoryDataModel(
                                            title: 'Text Story'.tr,
                                            file: file,
                                            privacy:
                                                controller.seletedPrivacy.value,
                                            music_id: controller
                                                .storyAudioModel.value?.id,
                                          );
                                          controller.isTextStyleFocused.value =
                                              false; // Hide text style list
                                          Get.back(result: reelsData);
                                        },
                                        text: 'Done'.tr,
                                        fontSize: 14,
                                        verticalPadding: 15,
                                        // horizontalPadding :120,
                                      )
                                    : PrimaryButton(
                                        onPressed: () {
                                          controller.shareStory();
                                        },
                                        text: 'Create Your Story'.tr,
                                        fontSize: 14,
                                        verticalPadding: 15,
                                        // horizontalPadding :120,
                                      ),
                              )
                            : 0.h,
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //* ===================================================================== Bottom Sheet for Getting Story Text =====================================================================

  void showInputStoryTextBottomSheet(
      BuildContext context, String imagePath) async {
    controller.onPressDoneTextModification();
    controller.isBottomSheetVisiable.value = true;
    controller.isTextModificationFocused.value = true;
    await Get.bottomSheet(
      // backgroundColor: Colors.green,
      // shape: const RoundedRectangleBorder(

      //   borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      // ),
      // backgroundColor: Colors.red,

      isScrollControlled: true,
      GestureDetector(
        onTap: () {
          // On tap outside story text
          FocusScope.of(context).unfocus(); // Dismiss keyboard
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fitWidth,
            opacity: 0.3,
            image: FileImage(File(imagePath)),
          )),
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
                          controller.isTextModificationFocused.value = false;
                          controller.isBottomSheetVisiable.value = false;
                          controller.isTextAlignmentFocused.value = false;
                          controller.isTextBackgroundFocused.value = false;
                          controller.isTextColorFocused.value = false;
                          controller.isTextStyleFocused.value = false;
                          controller.isTextModificationFocused.value = false;
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
                        focusNode: controller.storyTextFocusNode,
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
