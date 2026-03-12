import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';

import '../controllers/joined_groups_controller.dart';

class JoinedGroupsView extends GetView<JoinedGroupsController> {
  const JoinedGroupsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joined Groups'.tr,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      // backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.joinedGroupList.value.clear();
          await controller.getAllJoinedGroups();
        },
        child: SingleChildScrollView(
          controller: controller.groupScrollController,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => Text('All groups you have joined (${controller.pageCount.value})'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (controller.joinedGroupList.value.isNotEmpty) {
                      return GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.joinedGroupList.value.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          AllGroupModel joinedGroupsModel =
                              controller.joinedGroupList.value[index];

                          return InkWell(
                            onTap: () {
                              Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                                'id': joinedGroupsModel.id,
                                'group_type': 'joinedGroup'
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Image(
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Image(
                                          height: 80,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              AppAssets.DEFAULT_IMAGE),
                                        );
                                      },
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        (
                                          joinedGroupsModel.groupCoverPic ?? ''
                                        ).formatedGroupProfileUrl,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    joinedGroupsModel
                                            .groupName?.capitalizeFirst ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('${joinedGroupsModel.groupPrivacy.toString().capitalizeFirst} Group - ${joinedGroupsModel.joinedGroupsCount} Members'.tr,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    joinedGroupsModel.groupDescription ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: PRIMARY_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              Get.toNamed(Routes.GROUP_PROFILE,
                                                  arguments: {
                                                    'id': joinedGroupsModel.id,
                                                    'group_type': 'joinedGroup'
                                                  });
                                            },
                                            child: Text('Visit Group'.tr,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (controller.isLoadingUserGroups.value &&
                        controller.joinedGroupList.value.isEmpty) {
                      return const GroupShimmerLoader();
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 250),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset('assets/image/invitation.png',
                                  width: 30, height: 30),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('No Joined Groups'.tr,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                  Obx(() {
                    if (controller.isLoadingUserGroups.value) {
                      return const GroupShimmerLoader();
                    } else {
                      return const SizedBox();
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
