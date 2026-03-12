import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../extension/num.dart';
import '../../../../../extension/string/string.dart';
import '../../../../../extension/string/string_image_path.dart';
import 'package:video_player/video_player.dart';
import '../../../../../components/image.dart';
import '../../create_post/models/link_preview_model.dart';
import '../controller/create_page_post_controller.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../data/post_color_list.dart';
import '../../../../../models/feeling_model.dart';
import '../../../../../models/location_model.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../components/post_type.dart';
import '../media/page_media_component.dart';
import '../media/page_media_layout_component.dart';

class CreatePagePostView extends GetView<CreatePagePostController> {
  const CreatePagePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Create Page Post'.tr,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              InkWell(
                onTap: () async {
                  if (controller.isCreatePostCalled.value == true) {
                    return;
                  } else {
                    await controller.onTapCreatePagePost(
                        '${controller.pageProfileModel.pageDetails!.id}');
                  }
                },
                child: Text('Post'.tr,
                  style: TextStyle(
                    color: controller.isCreatePostCalled.value == true
                        ? Colors.grey.withValues(
                            alpha: 0.3) //Colors.grey.withValues(alpha:0.3)
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  NetworkCircleAvatar(
                      imageUrl: (controller
                                  .pageProfileModel.pageDetails?.profilePic ??
                              '')
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
                                text: '${controller.pageProfileModel.pageDetails?.pageName}'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
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
                                                    color: Colors.black,
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
                                                  color: Colors.black,
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
                              // controller.checkFriendList.value.length == 1
                              // ? TextSpan(
                              //     children: [
                              //         TextSpan(
                              //             text: ' with'.tr,
                              //             style: TextStyle(
                              //                 color: Colors.grey.shade700,
                              //                 fontSize: 16)),
                              //         TextSpan(
                              //             text:
                              //                 ' ${controller.checkFriendList.value[0].friend?.firstName ?? ''} ${controller.checkFriendList.value[0].friend?.lastName ?? ''}',
                              //             style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.bold)),
                              //       ],
                              //     style: TextStyle(
                              //         color: Colors.grey.shade700,
                              //         fontSize: 16))
                              //  controller.checkFriendList.value.length > 1
                              // ? TextSpan(
                              //     children: [
                              //         TextSpan(
                              //             text: ' with'.tr,
                              //             style: TextStyle(
                              //                 color: Colors.grey.shade700,
                              //                 fontSize: 16)),
                              //         TextSpan(
                              //             text:
                              //                 ' ${controller.checkFriendList.value[0].friend?.firstName ?? ''} ${controller.checkFriendList.value[0].friend?.lastName ?? ''}  and ${controller.checkFriendList.value.length - 1} others',
                              //             style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 16,
                              //                 fontWeight:
                              //                     FontWeight.bold)),
                              //       ],
                              //     style: TextStyle(
                              //         color: Colors.grey.shade700,
                              //         fontSize: 16))
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16)),
                            ])),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 25,
                              width: Get.width / 4,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: PRIMARY_COLOR, width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(
                                    () => controller.dropdownValue.value ==
                                            'Public'
                                        ? const Icon(
                                            Icons.public,
                                            color: PRIMARY_COLOR,
                                            size: 15,
                                          )
                                        : controller.dropdownValue.value ==
                                                'Friends'
                                            ? const Icon(
                                                Icons.group,
                                                color: PRIMARY_COLOR,
                                                size: 15,
                                              )
                                            : const Icon(
                                                Icons.lock,
                                                color: PRIMARY_COLOR,
                                                size: 15,
                                              ),
                                  ),
                                  Obx(() => DropdownButton<String>(
                                        value: controller.dropdownValue.value,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: PRIMARY_COLOR,
                                        ),
                                        elevation: 16,
                                        style: TextStyle(
                                            color: PRIMARY_COLOR),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.transparent,
                                        ),
                                        onChanged: (String? value) {
                                          controller.dropdownValue.value =
                                              value!;
                                        },
                                        items: privacyList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          );
                                        }).toList(),
                                      )),
                                ],
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
                  ? Container(
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
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          errorText: controller.wordLimit.value.length >= 101
                              ? 'You have crossed word limit'
                              : null,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'What’s on your mind ${controller.pageProfileModel.pageDetails?.pageName ?? '.tr'}?',
                          hintStyle: Theme.of(context)
                              .inputDecorationTheme
                              .hintStyle
                              ?.copyWith(color: Colors.white),
                        ),
                        onChanged: (val) {
                          controller.wordLimit.value = val.toString();
                        },
                      ),
                    )
                  : TextFormField(
                      onChanged: (value) {
                        final linkRegex = RegExp(
                            r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
                        final match = linkRegex.firstMatch(value);
                        if (match != null) {
                          final url = match.group(0)!;
                          controller.getLinkPreview(url);
                        } else {
                          controller.clearPreview();
                        }
                      },
                      controller: controller.descriptionController,
                      maxLines: controller.xfiles.value.isNotEmpty ? 5 : 14,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintText: 'What’s on your mind ${controller.pageProfileModel.pageDetails?.pageName ?? '.tr'}?',
                        hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
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
            //========================================= Color ListView for Post =================================================//
            Obx(() => Visibility(
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
                )),
            //========================================= Image ListView for Post =================================================//
            //* ========================================= Image Component for Post =================================================//

            Obx(
              () => Visibility(
                visible: controller.xfiles.value.isNotEmpty,
                child: (controller.selectedMediaLayout.value?.title == 'none' ||
                        controller.selectedMediaLayout.value?.title == null ||
                        controller.xfiles.value.any((file) => file.path
                            .toLowerCase()
                            .endsWithAny(
                                ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])))
                    ? SizedBox(
                        height: 120, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.xfiles.value.length,
                          itemBuilder: (context, index) {
                            String filePath =
                                controller.xfiles.value[index].path;
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: VideoPlayer(controller
                                                  .videoPlayerController!))
                                          : Container(
                                              margin: const EdgeInsets.all(8.0),
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image:
                                                      FileImage(File(filePath)),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.xfiles.value
                                                .removeAt(index);
                                            controller.xfiles.refresh();
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
                                });
                          },
                        ),
                      )
                    : PagePrimaryFileMediaComponent(
                        // index:0,
                        mediaUrlList:
                            controller.xfiles.value.map((e) => e.path).toList(),
                        mediaLayout:
                            controller.selectedMediaLayout.value?.title ?? '',
                        onTapRemoveMediaFile: () {
                          // controller.xfiles.value.removeAt( index);
                        },
                      ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.xfiles.value.length > 1,
                child:
                    PageMediaLayoutComponent(createPostController: controller),
              ),
            ),
            // Obx(
            //   () => Visibility(
            //     visible: controller.xfiles.value.isNotEmpty,
            //     child: Container(
            //       margin: const EdgeInsets.only(top: 10, left: 10),
            //       decoration: const BoxDecoration(),
            //       height: 100,
            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: controller.xfiles.value.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           XFile xFile = controller.xfiles.value[index];
            //           return Stack(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 10),
            //                 child: Image(
            //                   fit: BoxFit.cover,
            //                   height: 100,
            //                   width: 100,
            //                   image: FileImage(
            //                     File(xFile.path),
            //                   ),
            //                 ),
            //               ),
            //               Positioned(
            //                 top: 5,
            //                 right: 10,
            //                 child: InkWell(
            //                   onTap: () {
            //                     controller.xfiles.value.removeAt(index);
            //                     controller.xfiles.refresh();
            //                   },
            //                   child: const Icon(
            //                     Icons.close,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            //========================================= Photo/video =================================================//
            Obx(() => SizedBox(
                  // shadowColor: Colors.black,
                  // elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        //=============================== Add Photo
                        Visibility(
                          visible: !controller.isBackgroundColorPost.value,
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
                                Obx(() => Text('${controller.xfiles.value.length} Added '.tr,
                                      style: TextStyle(fontSize: 16),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //=============================== Add Feelings =============================//

                        InkWell(
                          onTap: () async {
                            var value = await Get.toNamed(Routes.FEELINGS);
                            if (value != null) {
                              controller.feelingName.value =
                                  value as PostFeeling;
                            }

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
