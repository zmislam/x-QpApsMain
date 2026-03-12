import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../components/image.dart';
import '../../../components/post_type.dart';
import '../../../config/constants/app_assets.dart';
import '../../../config/constants/color.dart';
import '../../../data/login_creadential.dart';
import '../../../data/post_color_list.dart';
import '../../../data/post_local_data.dart';
import '../../../models/media_type_model.dart';
import '../../../models/feeling_model.dart';
import '../../../models/location_model.dart';
import '../../../models/post.dart';
import '../controllers/edit_post_controller.dart';
import 'edit_check_in.dart';
import 'edit_feeling.dart';
import 'edit_tag_people.dart';

class EditGeneralPostView extends GetView<EditPostController> {
    const EditGeneralPostView({super.key, required this.postModel});

  final PostModel? postModel;

  // final EditPostController controller =  Get.put(EditPostController());

  @override
  Widget build(BuildContext context) {
    updateLocalData();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text('Edit Post'.tr,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                await controller.updateUserPost();
              },
              child: Text('Post'.tr,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    NetworkCircleAvatar(imageUrl: (LoginCredential().getUserData().profile_pic ?? '').formatedProfileUrl),
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                controller.feelingName.value != null
                                    ? TextSpan(children: [
                                        TextSpan(children: [
                                          TextSpan(text: ' is feeling'.tr, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                          WidgetSpan(
                                              child: Padding(
                                            padding: const EdgeInsets.only(left: 3.0),
                                            child: ReactionIcon(controller.feelingName.value!.logo.toString()),
                                          )),
                                          TextSpan(text: ' ${controller.feelingName.value?.feelingName}'.tr, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                        ], style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                      ])
                                    : TextSpan(text: '', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                // (controller.locationName.value?.locationName != null && controller.locationName.value?.locationName != '')
                                //     ? TextSpan(children: [
                                //         TextSpan(text: ' at'.tr, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                //         TextSpan(text: ' ${controller.locationName.value?.locationName}'.tr, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                //       ], style: TextStyle(color: Colors.grey.shade700, fontSize: 16))
                                //     : TextSpan(text: '', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                controller.checkFriendList.value.length == 1
                                    ? TextSpan(children: [
                                        TextSpan(text: ' with'.tr, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                        TextSpan(text: ' ${controller.checkFriendList.value[0].firstName.toString()} ${controller.checkFriendList.value[0].lastName.toString()}'.tr, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                      ], style: TextStyle(color: Colors.grey.shade700, fontSize: 16))
                                    : controller.checkFriendList.value.length > 1
                                        ? TextSpan(children: [
                                            TextSpan(text: ' with'.tr, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                                            TextSpan(
                                                text: ' ${controller.checkFriendList.value[0].firstName.toString()} ${controller.checkFriendList.value[0].lastName.toString()} and ${controller.checkFriendList.value.length - 1} others'.tr,
                                                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                          ], style: TextStyle(color: Colors.grey.shade700, fontSize: 16))
                                        : TextSpan(text: '', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                              ])),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 25,
                                width: Get.width / 4,
                                decoration: BoxDecoration(border: Border.all(color: PRIMARY_COLOR, width: 1), borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Obx(
                                      () => controller.dropdownValue.value == 'Public'
                                          ? const Icon(
                                              Icons.public,
                                              color: PRIMARY_COLOR,
                                              size: 15,
                                            )
                                          : controller.dropdownValue.value == 'Friends'
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
                                          style: const TextStyle(color: PRIMARY_COLOR),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.transparent,
                                          ),
                                          onChanged: (String? value) {
                                            controller.dropdownValue.value = value!;
                                            controller.postPrivacy.value = value;
                                          },
                                          items: privacyList.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          style: TextStyle(fontSize: 25, color: (controller.postBackgroundColor.value == const Color(0xFFFFFB00) || controller.postBackgroundColor.value == const Color(0xFF00FF00)) ? Colors.black : Colors.white),
                          controller: controller.descriptionController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      )
                    : TextField(
                        controller: controller.descriptionController,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          //alignLabelWithHint: false,
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ),
              ),
              Obx(() => Visibility(
                    visible: !controller.imageFromNetwork.value.isNotEmpty,
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
                                controller.imageFromNetwork.value.clear();
                              } else {
                                controller.isBackgroundColorPost.value = true;
                                controller.postBackgroundColor.value = postListColor[index];
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 20,
                              width: 35,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: postListColor[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
              Obx(
                () => Visibility(
                  visible: controller.imageFromNetwork.value.isNotEmpty,
                  child: Container(
                      // width: Get.width,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      child: controller.isLoading.value == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.imageFromNetwork.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                debugPrint('length from view .....${controller.imageFromNetwork.value.length}');

                                return controller.imageFromNetwork.value[index].isFile == true
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                        child: Stack(
                                          children: [
                                            Image(height: 100, width: 100, fit: BoxFit.cover, image: FileImage(File(controller.imageFromNetwork.value[index].imagePath.toString()))),
                                            Positioned(
                                              top: 5,
                                              right: 2,
                                              child: InkWell(
                                                onTap: () {
                                                  controller.imageFromNetwork.value.removeAt(index);
                                                  controller.xfiles.value.removeAt(index);
                                                  controller.imageFromNetwork.refresh();
                                                  debugPrint('length from delete .....${controller.imageFromNetwork.value.length}');
                                                },
                                                child: const Icon(
                                                  Icons.cancel_rounded,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              controller.imageFromNetwork.value[index].imagePath.toString(),
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Image(
                                                  fit: BoxFit.cover,
                                                  height: 100,
                                                  width: 100,
                                                  image: AssetImage(AppAssets.DEFAULT_IMAGE),
                                                );
                                              },
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 2,
                                              child: InkWell(
                                                onTap: () {
                                                  controller.removeMediaId.value.add(controller.imageFromNetwork.value[index].mediaId.toString());
                                                  controller.imageFromNetwork.value.removeAt(index);
                                                  controller.imageFromNetwork.refresh();
                                                  debugPrint('length from delete .....${controller.removeMediaId.value[0]}');
                                                },
                                                child: const Icon(
                                                  Icons.cancel_rounded,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                              },
                            )),
                ),
              ),
              Expanded(
                  child: Obx(
                () => Card(
                  shadowColor: Colors.black,
                  elevation: 4,
                  child: Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
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
                                      'assets/icon/create_post/picture icon.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    title: 'Photo/Video'.tr,
                                  ),
                                  Obx(() => Text('${controller.imageFromNetwork.value.length} Added '.tr,
                                        style: const TextStyle(fontSize: 16),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              controller.checkFriendList.value = await Get.to(() => const EditTagPeople());

                              debugPrint(controller.checkFriendList.value.toString());
                            },
                            child: PostType(
                              icon: Image.asset(
                                'assets/icon/create_post/tagpeople.png',
                                height: 30,
                                width: 30,
                              ),
                              title: 'Tag People'.tr,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              controller.feelingName.value = await Get.to(() => const EditFeeling()) as PostFeeling;

                              debugPrint(controller.feelingName.value.toString());
                            },
                            child: PostType(
                              icon: Image.asset(
                                'assets/icon/create_post/feelings.png',
                                height: 30,
                                width: 30,
                              ),
                              title: 'Feelings'.tr,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              controller.locationName.value = await Get.to(() => EditCheckIn()) as AllLocation;

                              debugPrint(controller.locationName.value.toString());
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
                        ],
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void updateLocalData() {
    controller.descriptionController.clear();
    controller.imageFromNetwork.value.clear();
    controller.removeMediaId.value.clear();

    controller.descriptionController.text = postModel?.description.toString() ?? '';
    controller.userId.value = postModel?.user_id?.id.toString() ?? '';
    controller.postId.value = postModel?.id.toString() ?? '';

    debugPrint('back ground color ...................${postModel?.post_background_color}');

    if (postModel?.post_privacy == 'only_me') {
      controller.dropdownValue.value = 'Only Me';
      controller.postPrivacy.value = 'Only Me';
    } else if (postModel?.post_privacy == 'public') {
      controller.dropdownValue.value = 'Public';
      controller.postPrivacy.value = 'Public';
    } else {
      controller.dropdownValue.value = 'Friends';
      controller.postPrivacy.value = 'Friends';
    }
    if (postModel?.post_background_color != '' && postModel?.post_background_color != null) {
      controller.postBackgroundColor.value = Color(int.parse('0xff${postModel!.post_background_color}'));
      controller.isBackgroundColorPost.value = true;
    }

    if (postModel?.media != null && postModel!.media!.isNotEmpty) {
      for (int index = 0; index < postModel!.media!.length; index++) {
        controller.imageFromNetwork.value.add(MediaTypeModel(imagePath: (postModel!.media![index].media.toString()).formatedPostUrl, isFile: false, mediaId: postModel!.media![index].id.toString()));
      }
    }

    if (postModel?.locationName != null) {
      controller.locationName.value = AllLocation(locationName: postModel!.locationName);

      controller.locationId.value = postModel?.location_id?.id.toString() ?? '';

      debugPrint('edit location id ...............${controller.locationId.value}');
      debugPrint('edit location name ...............${controller.locationName.value!.locationName}');
    }

    if (postModel?.feeling_id != null) {
      controller.feelingName.value = PostFeeling(id: postModel?.feeling_id?.id.toString() ?? '', feelingName: postModel?.feeling_id?.feelingName.toString() ?? '', logo: postModel?.feeling_id?.logo.toString() ?? '');

      controller.feelingId.value = postModel?.feeling_id?.id.toString() ?? '';

      debugPrint('edit feeling id ...............${controller.feelingId.value}');
    }

    if (postModel?.taggedUserList != null && postModel!.taggedUserList!.isNotEmpty) {
      for (int index = 0; index < postModel!.taggedUserList!.length; index++) {
        controller.checkFriendList.value.add(postModel!.taggedUserList![index].user as User);
      }
    }
  }

  Widget ReactionIcon(String reactionPath) {
    return Image(height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }
}
