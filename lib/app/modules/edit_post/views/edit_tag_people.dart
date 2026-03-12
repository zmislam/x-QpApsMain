import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../models/post.dart';
import '../../../components/image.dart';
import '../../../models/friend.dart';
import '../controllers/edit_post_controller.dart';

class EditTagPeople extends GetView<EditPostController> {
  const EditTagPeople({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Tag Friends'.tr,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back(result: controller.checkFriendList.value);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search friends'.tr,
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  controller.tagPeopleController.value = value;
                  controller.searchFriendList.value.clear();

                  controller.searchFriendList.value = controller
                      .friendController.friendList.value
                      .where((friendModel) =>
                          friendModel.friend!.username
                              .toString()
                              .toUpperCase()
                              .contains(value.toString().toUpperCase()) ||
                          friendModel.friend!.firstName
                              .toString()
                              .toUpperCase()
                              .contains(value.toString().toUpperCase()) ||
                          friendModel.friend!.lastName
                              .toString()
                              .toUpperCase()
                              .contains(value.toString().toUpperCase()))
                      .toList();

                  debugPrint(
                      'friend controller .....${controller.searchFriendList.value}');
                } else {
                  controller.tagPeopleController.value = '';
                }
              },
            ),
          ),
          Obx(
            () => Wrap(
              spacing: 4.0,
              children: controller.checkFriendList.value
                  .map((friendModel) => Chip(
                      backgroundColor: Colors.grey.withValues(alpha: 0.4),
                      onDeleted: () {
                        controller.checkFriendList.value.remove(friendModel);
                        controller.checkFriendList.refresh();
                      },
                      label: Text('${friendModel.firstName}${friendModel.lastName}'.tr)))
                  .toList(),
            ),
          ),
          Expanded(
              child: Obx(() => controller.tagPeopleController.value == ''
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount:
                          controller.friendController.friendList.value.length,
                      itemBuilder: (context, index) {
                        FriendModel friendModel =
                            controller.friendController.friendList.value[index];

                        return Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10.0),
                              child: NetworkCircleAvatar(
                                imageUrl: (friendModel.friend?.profilePic ?? '')
                                    .formatedProfileUrl,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                '${friendModel.friend?.firstName ?? ''} ${friendModel.friend?.lastName ?? ''}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Obx(() => Checkbox(
                                  onChanged: (onChanged) {
                                    if (onChanged == true) {
                                      controller.checkFriendList.value.add(User(
                                          id: friendModel.friend?.id,
                                          firstName:
                                              friendModel.friend?.firstName,
                                          lastName:
                                              friendModel.friend?.lastName,
                                          username:
                                              friendModel.friend?.username));
                                      controller.checkFriendList.refresh();
                                    } else {
                                      controller.checkFriendList.value.remove(
                                          User(
                                              id: friendModel.friend?.id,
                                              firstName:
                                                  friendModel.friend?.firstName,
                                              lastName:
                                                  friendModel.friend?.lastName,
                                              username: friendModel
                                                  .friend?.username));
                                      controller.checkFriendList.refresh();
                                    }
                                  },
                                  value: controller.checkFriendList.value.any(
                                      (checkedFriendModel) =>
                                          checkedFriendModel.id ==
                                          friendModel.friend!.id),
                                ))
                          ],
                        );
                      })
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: controller.searchFriendList.value.length,
                      itemBuilder: (context, index) {
                        FriendModel friendModel =
                            controller.searchFriendList.value[index];
                        return Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10.0),
                              child: NetworkCircleAvatar(
                                imageUrl: (friendModel.friend?.profilePic ?? '')
                                    .formatedProfileUrl,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                '${friendModel.friend?.firstName ?? ''} ${friendModel.friend?.lastName ?? ''}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Obx(() => Checkbox(
                                value: controller.checkFriendList.value
                                    .contains(friendModel),
                                onChanged: (onChanged) {
                                  if (onChanged == true) {
                                    controller.checkFriendList.value.add(User(
                                        id: friendModel.friend?.id,
                                        firstName:
                                            friendModel.friend?.firstName,
                                        lastName: friendModel.friend?.lastName,
                                        username:
                                            friendModel.friend?.username));
                                    controller.checkFriendList.refresh();
                                  } else {
                                    controller.checkFriendList.value.remove(
                                        User(
                                            id: friendModel.friend?.id,
                                            firstName:
                                                friendModel.friend?.firstName,
                                            lastName:
                                                friendModel.friend?.lastName,
                                            username:
                                                friendModel.friend?.username));
                                    controller.checkFriendList.refresh();
                                  }
                                }))
                          ],
                        );
                      }))),
        ],
      ),
    );
  }
}
