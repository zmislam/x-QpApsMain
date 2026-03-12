import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../models/all_group_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';

import '../controllers/discover_groups_controller.dart';

class DiscoverGroupsView extends GetView<DiscoverGroupsController> {
  const DiscoverGroupsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Discover Groups'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.CREATE_GROUP);
                },
                icon: Image.asset(AppAssets.CREATE_ICON),
              ),
            ),
          ],
        ),
        leading: const BackButton(),
      ),
      body: RefreshIndicator(
        color: PRIMARY_COLOR,
        backgroundColor: Theme.of(context).cardTheme.color,
        onRefresh: () async {
          controller.allGroupList.value.clear();
          await controller.getAllGroups();
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => Row(
                          children: [
                            ActionChip(
                              side: BorderSide.none,
                              backgroundColor: controller.view.value == 0
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                              label: Text('Discover'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                controller.view.value = 0;
                              },
                            ),
                            const SizedBox(width: 4),
                            ActionChip(
                              side: BorderSide.none,
                              backgroundColor: controller.view.value == 1
                                  ? Colors.grey.shade300
                                  : Theme.of(context).cardTheme.color,
                              label: Text('Group Feed'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.GROUP_FEED);
                              },
                            ),
                            const SizedBox(width: 4),
                            ActionChip(
                              side: BorderSide.none,
                              backgroundColor: controller.view.value == 2
                                  ? Colors.grey.shade300
                                  : Theme.of(context).cardTheme.color,
                              label: Text('Invites'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.INVITE_GROUPS);
                              },
                            ),
                            const SizedBox(width: 4),
                            ActionChip(
                              backgroundColor: controller.view.value == 3
                                  ? Colors.grey.shade300
                                  : Theme.of(context).cardTheme.color,
                              side: BorderSide.none,
                              label: Text('Joined Groups'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.JOINED_GROUPS);
                              },
                            ),
                            const SizedBox(width: 4),
                            ActionChip(
                              backgroundColor: controller.view.value == 4
                                  ? Colors.grey.shade300
                                  : Theme.of(context).cardTheme.color,
                              side: BorderSide.none,
                              label: Text('My Groups'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.MY_GROUPS);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('Suggested for you'.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.allGroupList.value.isNotEmpty) {
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      AllGroupModel allGroupsModel =
                          controller.allGroupList.value[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                            'id': allGroupsModel.id,
                            'group_type': 'discoverGroup',
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image(
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Image(
                                      height: 70,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage(AppAssets.DEFAULT_IMAGE),
                                    );
                                  },
                                  height: 70,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    (
                                      allGroupsModel.groupCoverPic ?? ''
                                    ).formatedGroupProfileUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                allGroupsModel.groupName?.capitalizeFirst ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text('${allGroupsModel.groupPrivacy.toString().capitalizeFirst} Group - ${allGroupsModel.joinedGroupsCount} Members'.tr,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                allGroupsModel.groupDescription ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 35,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    controller.joinGroupRequestPost(
                                      groupId: allGroupsModel.id,
                                      type: 'join',
                                      userIdArray: controller.loginCredential
                                          .getUserData()
                                          .id,
                                    );
                                  },
                                  child: Text('Join'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: controller.allGroupList.value.length,
                  ),
                );
              } else if (controller.isLoadingUserGroups.value &&
                  controller.allGroupList.value.isEmpty) {
                return const SliverToBoxAdapter(
                  child: GroupShimmerLoader(),
                );
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
                          Text('No Groups to Discover'.tr,
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
                return const SliverToBoxAdapter(
                  child: GroupShimmerLoader(),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: SizedBox(),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
