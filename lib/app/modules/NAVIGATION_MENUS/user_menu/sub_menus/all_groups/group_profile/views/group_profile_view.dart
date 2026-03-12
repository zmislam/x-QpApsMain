import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../components/image.dart';
import '../components/discussion_component.dart';
import '../components/files_component.dart';
import '../components/group_media_photo_component.dart';
import '../components/group_profile_widget_list_component.dart';
import '../components/about_component.dart';
import '../components/profile_joined_invite_row_section.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/group_profile_controller.dart';

class GroupProfileView extends GetView<GroupProfileController> {
  const GroupProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              controller.allGroupModel.value?.groupName?.capitalizeFirst ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: RefreshIndicator(
            backgroundColor: Theme.of(context).cardTheme.color,
            color: PRIMARY_COLOR,
            onRefresh: () async {
              controller.postList.value.clear();
              controller.fetchGroupDetails();
              controller.getGroupPosts();
              controller.getGroupPhotos();
              controller.getGroupAlbums();
              controller.fetchGroupFiles();
              controller.getGroupMemberJoinRequest();
            },
            child: CustomScrollView(
              slivers: [
                // ======================== image section ======================
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => SingleImage(
                              imgURL: (controller
                                      .allGroupModel.value?.groupCoverPic ??
                                  '').formatedGroupProfileUrl));
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: PrimaryNetworkImage(
                            imageUrl: (
                                controller.allGroupModel.value?.groupCoverPic ??
                                    '').formatedGroupProfileUrl,
                          ),
                        ),
                      ),
                      if (controller.groupRole.value == 'admin' &&
                          controller.isGroupMember.value == true)
                        Positioned(
                          right: 20,
                          top: 20,
                          child: IconButton(
                            onPressed: () {
                              debugPrint('pick cover pic button pressed');
                              controller.changeCoverPicture();
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                // ======================= group name section ==================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        textAlign: TextAlign.start,
                        controller.allGroupModel.value?.groupName
                                ?.capitalizeFirst ??
                            '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // ======================= group status and member section =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.GROUP_MEMBERS_ADMINS_MODERATORS,
                            arguments: controller.allGroupModel);
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(controller.allGroupModel.value?.groupPrivacy ==
                                  'public'
                              ? Icons.public
                              : Icons.lock),
                          const SizedBox(width: 5),
                          Text(
                            '${controller.allGroupModel.value?.groupPrivacy.toString().capitalizeFirst ?? 'Public'} Group',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(' - '.tr),
                          Text('${controller.allGroupModel.value?.joinedGroupsCount ?? 0} Members'.tr,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // =================== group action button section =============
                SliverToBoxAdapter(
                  child: GroupProfileJoinedInviteRowButtons(
                    controller: controller,
                  ),
                ),
                // ==================== divider section ========================
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                if (controller.allGroupModel.value?.groupPrivacy != 'private' ||
                    controller.isGroupMember.value)
                  SliverToBoxAdapter(
                    child: GroupProfileWidgetList(controller: controller),
                  ),
                // ==================== divider section ========================
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                // ==================== content section ========================
                if (controller.allGroupModel.value?.groupPrivacy != 'private' ||
                    controller.isGroupMember.value)
                  Obx(
                    () {
                      switch (controller.groupProfileWidgetViewNumber.value) {
                        case 0:
                          // =================== discussion component ============
                          return GroupProfileDiscussionComponent(
                              controller: controller);
                        case 1:
                          return controller.photoList.value.isNotEmpty
                              ? GroupProfileMediaComponent(
                                  controller: controller)
                              : SliverToBoxAdapter(
                                  child:  Center(
                                  child: SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 70),
                                      child: Text('No Media'.tr,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: PRIMARY_COLOR),
                                      ),
                                    ),
                                  ),
                                )
                                );
                        case 2:
                          return GroupProfileFilesComponent(
                              controller: controller);
                        case 3:
                          return SliverToBoxAdapter(
                            child: GroupProfileAboutComponent(
                                controller: controller),
                          );
                        default:
                          return const SliverToBoxAdapter(child: SizedBox(),);
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
