import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/my_groups_controller.dart';

class MyGroupsView extends GetView<MyGroupsController> {
  const MyGroupsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Groups'.tr,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.myGroupList.value.clear();
            controller.pageNo = 1;
            await controller.getAllMyGroups();
          },
          child: SingleChildScrollView(
            controller: controller.groupScrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Text('All groups you have created (${controller.pageCount.value})'.tr,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (controller.myGroupList.value.isNotEmpty) {
                      return GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.myGroupList.value.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          AllGroupModel myGroupsModel =
                              controller.myGroupList.value[index];

                          return InkWell(
                            onTap: () {
                              Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                                'id': myGroupsModel.id,
                                'group_type': 'myGroup',
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            AppAssets.DEFAULT_IMAGE,
                                          ),
                                        );
                                      },
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        (
                                          controller.myGroupList.value[index]
                                                  .groupCoverPic ??
                                              ''
                                        ).formatedGroupProfileUrl,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    myGroupsModel.groupName?.capitalizeFirst ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('${myGroupsModel.groupPrivacy.toString().capitalizeFirst} Group - ${myGroupsModel.joinedGroupsCount} Members'.tr,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    myGroupsModel.groupDescription ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
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
                                                    'id': myGroupsModel.id,
                                                    'group_type': 'myGroup',
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
                        controller.myGroupList.value.isEmpty) {
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
                              const SizedBox(height: 10),
                              Text('You Have Created No Groups'.tr,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
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
