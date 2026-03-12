import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/search_bar.dart';
import '../../../../../models/friend.dart';
import '../../../../../components/image.dart';
import '../../../../../config/constants/color.dart';
import '../controller/create_post_controller.dart';

class TagPeople extends GetView<CreatePostController> {
  const TagPeople({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'friend list ..............${controller.friendController.friendList.value}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Friends'.tr,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: PrimarySearchBar(
                hintText: 'Search friends'.tr,
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
              )),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Wrap(
                spacing: 4.0,
                children: controller.checkFriendList.value
                    .map((friendModel) => Chip(
                        backgroundColor: const Color(0xffEEF6FB),
                        //  Colors.grey.withValues(alpha:0.4),
                        onDeleted: () {
                          controller.checkFriendList.value.remove(friendModel);
                          controller.checkFriendList.refresh();
                        },
                        label: Text(
                            '${friendModel.friend?.firstName ?? ''} ${friendModel.friend?.lastName ?? ''}')))
                    .toList(),
              ),
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
                                activeColor: PRIMARY_COLOR,
                                value: controller.checkFriendList.value
                                    .contains(friendModel),
                                onChanged: (onChanged) {
                                  if (onChanged == true) {
                                    controller.checkFriendList.value
                                        .add(friendModel);
                                    controller.checkFriendList.refresh();
                                  } else {
                                    controller.checkFriendList.value
                                        .remove(friendModel);
                                    controller.checkFriendList.refresh();
                                  }
                                }))
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
                                    controller.checkFriendList.value
                                        .add(friendModel);
                                    controller.checkFriendList.refresh();
                                  } else {
                                    controller.checkFriendList.value
                                        .remove(friendModel);
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
