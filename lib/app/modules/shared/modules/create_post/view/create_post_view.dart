import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string.dart';
import '../../../../../extension/string/string_image_path.dart';
import 'package:video_player/video_player.dart';
import '../../../../../components/image.dart';
import '../../../../../components/post_type.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../data/post_color_list.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../extension/num.dart';
import '../../../../../models/feeling_model.dart';
import '../../../../../models/location_model.dart';
import '../../../../../routes/app_pages.dart';
import '../components/media/media_component.dart';
import '../components/media_layout_component.dart';
import '../controller/create_post_controller.dart';
import '../models/link_preview_model.dart';

class CreatePostView extends GetView<CreatePostController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Create Post'.tr,
              ),
              InkWell(
                onTap: () async {
                  // controller.isCreatePostCalled.value = true ? null :   controller.onTapCreatePost();
                  if (controller.isCreatePostCalled.value == true) {
                    return;
                  } else {
                    await controller.onTapCreatePost();
                  }
                },
                child: Text('Post'.tr,
                  style: controller.isCreatePostCalled.value == true
                      ? TextStyle(
                          color: Colors.grey.withValues(alpha: 0.3),
                        )
                      : Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //=============================Create Post Header==============================//
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  NetworkCircleAvatar(
                      imageUrl:
                          (LoginCredential().getUserData().profile_pic ?? '')
                              .formatedProfileUrl),
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(() => Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: '${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if(LoginCredential().getUserInfoData().isProfileVerified == true)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Icon(
                                      Icons.verified,
                                      color: PRIMARY_COLOR,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              //=================Feeling=================//
                              controller.feelingName.value != null
                                  ? TextSpan(children: [
                                      TextSpan(
                                          children: [
                                            TextSpan(
                                                text: ' is feeling'.tr,
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 16)),
                                            TextSpan(
                                                text: ' ${controller.feelingName.value?.feelingName}'.tr,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 16)),
                                      WidgetSpan(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: ReactionIcon(controller
                                            .feelingName.value!.logo
                                            .toString()),
                                      )),
                                    ])
                                  : TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16)),
                              //=================Location=================//
                              controller.locationName.value != null
                                  ? TextSpan(
                                      children: [
                                          TextSpan(
                                              text: ' at'.tr,
                                              style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 16)),
                                          TextSpan(
                                              text: ' ${controller.locationName.value?.locationName}'.tr,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16))
                                  : TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16)),
                              //=================With whom(Tag Friend)=================//
                              controller.checkFriendList.value.length == 1
                                  ? TextSpan(
                                      children: [
                                          TextSpan(
                                              text: ' with'.tr,
                                              style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 16)),
                                          TextSpan(
                                              text: ' ${controller.checkFriendList.value[0].friend?.firstName ?? '.tr'} ${controller.checkFriendList.value[0].friend?.lastName ?? ''}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16))
                                  : controller.checkFriendList.value.length > 1
                                      ? TextSpan(
                                          children: [
                                              TextSpan(
                                                  text: ' with'.tr,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 16)),
                                              TextSpan(
                                                  text: ' ${controller.checkFriendList.value[0].friend?.firstName ?? '.tr'} ${controller.checkFriendList.value[0].friend?.lastName ?? ''}  and ${controller.checkFriendList.value.length - 1} others',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 16))
                                      : TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 16)),
                            ])),
                            const SizedBox(
                              height: 5,
                            ),
                            //=================Post Privacy=================//
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF3A3B3C)
                                      : const Color(0xFFF0F2F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => DropdownButton<String>(
                                          value:
                                              controller.dropdownValue.value,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            size: 18,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? const Color(0xFFB0B3B8)
                                                    : const Color(0xFF65676B),
                                          ),
                                          elevation: 4,
                                          isDense: true,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? const Color(0xFFE4E6EB)
                                                    : const Color(0xFF050505),
                                          ),
                                          underline: const SizedBox.shrink(),
                                          dropdownColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? const Color(0xFF242526)
                                                  : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onChanged: (String? value) {
                                            controller.dropdownValue.value =
                                                value!;
                                          },
                                          items: privacyList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            IconData icon;
                                            if (value == 'Public') {
                                              icon = Icons.public;
                                            } else if (value == 'Friends') {
                                              icon = Icons.group;
                                            } else {
                                              icon = Icons.lock;
                                            }
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    icon,
                                                    size: 14,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? const Color(
                                                            0xFFB0B3B8)
                                                        : const Color(
                                                            0xFF65676B),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    value.tr,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? const Color(
                                                              0xFFE4E6EB)
                                                          : const Color(
                                                              0xFF050505),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Obx(
              () => controller.isBackgroundColorPost.value
                  ?
                  //* ================================================================ Background Color Post Text Layout ================================================================
                  Container(
                      width: double.maxFinite,
                      height: 240,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.postBackgroundColor.value,
                      ),
                      child: TextFormField(
                        validator: (text) {
                          if (text!.length >= 101) {
                            return 'You have crossed word limit';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(101),
                        ],
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 25,
                            color: (controller.postBackgroundColor.value ==
                                        const Color(0xFFFFFB00) ||
                                    controller.postBackgroundColor.value ==
                                        const Color(0xFF00FF00))
                                ? Colors.black
                                : Colors.white),
                        controller: controller.descriptionController,
                        onChanged: (val) {
                          controller.wordLimit.value = val.toString();
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            errorText: controller.wordLimit.value.length >= 101
                                ? 'You have crossed word limit'
                                : null,
                            hintText: 'What’s on your mind ${controller.userModel.first_name}?'.tr,
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle
                                ?.copyWith(color: Colors.white),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                      ),
                    )
                  :
                  //* ================================================================  Post Text Layout ================================================================
                  Obx(() => TextFormField(
                        onChanged: (value) {
                          final linkRegex = RegExp(
                              r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
                          final match = linkRegex.firstMatch(value);
                          if (match != null) {
                            final url = match.group(0)!;
                            controller.getLinkPreview(url);
                          } else {
                            controller.clearPreview();
                          }
                        },
                        controller: controller.descriptionController,
                        maxLines: controller.xfiles.value.isNotEmpty ? 10 : 14,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          filled: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintText: 'What’s on your mind ${controller.userModel.first_name}?'.tr,
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
            ),
            //  ===========================Link Preview ===================================//
            Obx(() {
              if (controller.linkPreview.value != null &&
                  controller.xfiles.value.isEmpty) {
                LinkPreview preview =
                    controller.linkPreview.value ?? LinkPreview();
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (preview.thumbnail != null)
                        Stack(
                          children: [
                            Image.network(
                              preview.thumbnail ?? '',
                              height: 120,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppAssets.DEFAULT_IMAGE,
                                  height: 120,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            Positioned(
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    controller.clearPreview();
                                  },
                                ))
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          preview.title ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          preview.description ?? '',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            // ========================================= Color ListView for Post =================================================//
            Obx(
              () => Visibility(
                // ========================================= Not visible for post with media files =================================
                visible: !controller.xfiles.value.isNotEmpty,
                child: Container(
                  width: Get.width,
                  height: 35,
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: postListColor.length,
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            controller.isBackgroundColorPost.value = false;
                          } else {
                            controller.isBackgroundColorPost.value = true;
                            controller.postBackgroundColor.value =
                                postListColor[index];
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 20,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: postListColor[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            //* ========================================= Image Component for Post =================================================//

            Obx(
                  () => Visibility(
                visible: controller.xfiles.value.isNotEmpty || controller.fileCheckingStates.isNotEmpty,
                child: (controller.selectedMediaLayout.value?.title == 'none' ||
                    controller.selectedMediaLayout.value?.title == null ||
                    controller.xfiles.value.any((file) => file.path
                        .toLowerCase()
                        .endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])))
                    ? SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.fileCheckingStates.isNotEmpty
                        ? controller.fileCheckingStates.length
                        : controller.xfiles.value.length,
                    itemBuilder: (context, index) {
                      // Show checking files if checking is in progress
                      if (controller.fileCheckingStates.isNotEmpty) {
                        final checkingState = controller.fileCheckingStates[index];
                        bool isVideo = checkingState.filePath.toLowerCase().endsWithAny(
                            ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv']);

                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(checkingState.filePath)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (checkingState.isChecking)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black54,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              ),
                            if (checkingState.isPassed)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black38,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            if (checkingState.isFailed)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black54,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }

                      // Show approved files after checking is done
                      String filePath = controller.xfiles.value[index].path;
                      bool isVideo = filePath.toLowerCase().endsWithAny(
                          ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv']);

                      return FutureBuilder<String?>(
                        future: isVideo
                            ? controller.generateThumbnail(filePath)
                            : Future.value(null),
                        builder: (context, snapshot) {
                          return Stack(
                            children: [
                              isVideo
                                  ? Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: VideoPlayer(controller.videoPlayerController!))
                                  : Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(File(filePath)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.xfiles.value.removeAt(index);
                                    controller.processedFileData.value.removeAt(index);
                                    controller.xfiles.refresh();
                                    controller.processedFileData.refresh();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
                    : controller.xfiles.value.isNotEmpty
                    ? PrimaryFileMediaComponent(
                  mediaUrlList: controller.xfiles.value.map((e) => e.path).toList(),
                  mediaLayout: controller.selectedMediaLayout.value?.title ?? '',
                  onTapRemoveMediaFile: () {},
                )
                    : const SizedBox.shrink(),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.xfiles.value.length > 1,
                child: MediaLayoutComponent(createPostController: controller),
              ),
            ),
            //* ========================================= Other option adding button =================================================//

            Obx(() => SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // =============================== Add Photo
                        Visibility(
                          visible: !controller.isBackgroundColorPost.value,
                          // =============================== Not visible on color post
                          child: InkWell(
                            onTap: () {
                              controller.pickFiles();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PostType(
                                  icon: Image.asset(
                                    AppAssets.ADD_PHOTO_ICON,
                                    height: 30,
                                    width: 30,
                                  ),
                                  title: 'Photo/Video'.tr,
                                ),
                                Obx(() => Text('${controller.xfiles.value.length} ${'Added'.tr} ',
                                      style: TextStyle(fontSize: 16),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //=============================== Tag People
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.TAG_PEOPLE);
                          },
                          child: PostType(
                            icon: Image.asset(
                              AppAssets.TAG_PEOPLE_ICON,
                              height: 30,
                              width: 30,
                            ),
                            title: 'Tag People'.tr,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //=============================== Add Feelings
                        InkWell(
                          onTap: () async {
                            controller.feelingName.value =
                                await Get.toNamed(Routes.FEELINGS)
                                    as PostFeeling;

                            debugPrint(controller.feelingName.value.toString());
                          },
                          child: PostType(
                            icon: Image.asset(
                              AppAssets.ADD_FEELINGS_ICON,
                              height: 30,
                              width: 30,
                            ),
                            title: 'Feelings'.tr,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //=============================== Add Location
                        InkWell(
                          onTap: () async {
                            controller.locationName.value =
                                await Get.toNamed(Routes.CHECKIN)
                                    as AllLocation;

                            debugPrint(
                                controller.locationName.value.toString());
                          },
                          child: PostType(
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.pink,
                              size: 35,
                            ),
                            title: 'Check in'.tr,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //=============================== Add Life Event
                        Visibility(
                          visible: !controller.isBackgroundColorPost.value,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.EVENT);
                            },
                            child: PostType(
                              icon: Image.asset(
                                AppAssets.LIFE_EVENT_ICON,
                                height: 30,
                                width: 30,
                              ),
                              title: 'Life Event'.tr,
                            ),
                          ),
                        ),
                        20.h,
                        //=============================== Go LIVE=================================//
                        Visibility(
                          visible: !controller.isBackgroundColorPost.value,
                          child: InkWell(
                            onTap: () {
                              Get.offNamed(Routes.GO_LIVE);
                            },
                            child: PostType(
                              icon: Image.asset(
                                AppAssets.GO_LIVE_ICON,
                                height: 30,
                                width: 30,
                              ),
                              title: 'Go Live'.tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }
}
