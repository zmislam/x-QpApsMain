import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../models/all_invite_group_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/invite_groups_controller.dart';

class InviteGroupsView extends GetView<InviteGroupsController> {
  const InviteGroupsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Groups'.tr,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.invitedGroupList.value.clear();
          await controller.getAllInvitedGroups();
        },
        child: CustomScrollView(
          controller: controller.groupScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text('All groups you have invited (${controller.pageCount.value})'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.invitedGroupList.value.isNotEmpty) {
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      InviteGroupsModel invitedGroupsModel =
                          controller.invitedGroupList.value[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                                  'id': invitedGroupsModel.groupId,
                                  'group_type': 'invitedGroup',
                                });
                              },
                              child: Image(
                                errorBuilder: (context, error, stackTrace) {
                                  return const Image(
                                    height: 80,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                                  );
                                },
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  (
                                    '${invitedGroupsModel.group?.groupCoverPic}'
                                        .formatedGroupProfileUrl
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              invitedGroupsModel
                                      .group?.groupName?.capitalizeFirst ??
                                  '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${invitedGroupsModel.group?.groupPrivacy.toString().capitalizeFirst} Group'.tr,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                                Text(' - '.tr),
                                Expanded(
                                  child: Text('${invitedGroupsModel.group?.groupMember?.first.count} Members'.tr,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text('${invitedGroupsModel.group?.groupDescription}'.tr,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        controller
                                            .groupInvitationAcceptDeclineRequestPost(
                                          invitationId: invitedGroupsModel.id,
                                          status: 'accept',
                                        );
                                      },
                                      child: Text('Accept'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        controller
                                            .groupInvitationAcceptDeclineRequestPost(
                                          invitationId: invitedGroupsModel.id,
                                          status: 'decline',
                                        );
                                      },
                                      child: Text('Cancel'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: controller.invitedGroupList.value.length,
                  ),
                );
              } else if (controller.isLoadingUserGroups.value &&
                  controller.invitedGroupList.value.isEmpty) {
                return const SliverToBoxAdapter(child: GroupShimmerLoader());
              } else {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset('assets/image/invitation.png',
                              width: 30, height: 30),
                          const SizedBox(height: 10),
                          Text('No Groups Invitation'.tr,
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
            Obx(() {
              if (controller.isLoadingUserGroups.value) {
                return const SliverToBoxAdapter(child: GroupShimmerLoader());
              } else {
                return const SliverToBoxAdapter(child: SizedBox());
              }
            })
          ],
        ),
      ),
    );
  }
}
