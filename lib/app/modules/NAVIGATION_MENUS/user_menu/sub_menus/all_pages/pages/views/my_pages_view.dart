import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../extension/num.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/pages_controller.dart';
import '../model/invitation_model.dart';
import '../model/mypage_model.dart';

class MyPagesView extends GetView<PagesController> {
  const MyPagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ============================ appbar section =========================
        appBar: AppBar(
          title: Text('My Pages'.tr,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: const BackButton(),
        ),
        // ============================ body section ===========================
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getMyPages();
          },
          child: SingleChildScrollView(
            controller: controller.myPageScrollController,
            child: Column(
              children: [
                const Divider(),
                Obx(() {
                  if (controller.myPagesList.value.isNotEmpty &&
                      !controller.isLoadingUserPages.value) {
                    return GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.myPagesList.value.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.80,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        MyPagesModel myPagesModel =
                            controller.myPagesList.value[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.ADMIN_PAGE,
                                  arguments: myPagesModel.pageUserName);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image(
                                  errorBuilder: (context, error, stackTrace) {
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
                                      ('${controller.myPagesList.value[index].coverPic}')
                                          .formatedProfileUrl),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('${myPagesModel.pageName}'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text((myPagesModel.category)?.join('') ?? ''),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('${myPagesModel.followerCount ?? 0} - followers'.tr),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.ADMIN_PAGE,
                                              arguments:
                                                  myPagesModel.pageUserName);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            // width: screenWidth * 0.32,
                                            decoration: BoxDecoration(
                                                color: PRIMARY_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Text('View Page'.tr,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ),
                                    ),
                                    10.w,
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: PopupMenuButton(
                                            offset: const Offset(10, 50),
                                            icon: const Center(
                                                child: Image(
                                                    width: 20,
                                                    image: AssetImage(AppAssets
                                                        .MORE_VERT_ICON))),
                                            iconSize: 25,
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    onTap: () {
                                                      controller
                                                          .getPagesInvites(
                                                              myPagesModel.id ??
                                                                  '');

                                                      showCustomBottomSheet(
                                                          context,
                                                          myPagesModel);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text('Invite Connections'.tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (controller.myPagesList.value.isEmpty &&
                      !controller.isLoadingUserPages.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 250),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/image/invitation.png',
                                width: 30, height: 30),
                            const SizedBox(height: 10),
                            Text('You Have Create No Pages Yet'.tr,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const GroupShimmerLoader();
                  }
                }),
                // Obx(() {
                //   if (controller.isLoadingUserPages.value) {
                //     return const GroupShimmerLoader();
                //   } else {
                //     return const SizedBox();
                //   }
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCustomBottomSheet(BuildContext context, MyPagesModel myPagesModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Obx(
            () => Container(
              color: Theme.of(context).cardTheme.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Invite Your friends to this Page'.tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select All'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Obx(() => Checkbox(
                              activeColor: PRIMARY_COLOR,
                              value: controller.selectedPageInvitationList.value
                                      .length ==
                                  controller.pageInvitationList.value.length,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  if (value) {
                                    controller
                                            .selectedPageInvitationList.value =
                                        controller.pageInvitationList.value
                                            .toList();
                                  } else {
                                    controller.selectedPageInvitationList.value
                                        .clear();
                                  }
                                  controller.selectedPageInvitationList
                                      .refresh();
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: controller.pageInvitationList.value.length,
                        itemBuilder: (context, index) {
                          PageInvitationModel pageInvitationModel =
                              controller.pageInvitationList.value[index];
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          child: ClipOval(
                                            child: Image(
                                              image: NetworkImage(
                                                  (pageInvitationModel
                                                              .profilePic ??
                                                          '')
                                                      .formatedProfileUrl),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          pageInvitationModel.fullName ?? '',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () => Checkbox(
                                      activeColor: PRIMARY_COLOR,
                                      value: controller
                                          .selectedPageInvitationList.value
                                          .contains(pageInvitationModel),
                                      onChanged: (bool? changed) {
                                        if (changed != null) {
                                          if (changed) {
                                            controller
                                                .selectedPageInvitationList
                                                .value
                                                .add(pageInvitationModel);
                                            // controller.selectedPageInvitationList.refresh();
                                          } else {
                                            controller
                                                .selectedPageInvitationList
                                                .value
                                                .clear();
                                          }
                                          controller.selectedPageInvitationList
                                              .refresh();
                                        }
                                      },
                                    ),
                                  ),
                                ]),
                          );
                        }),
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12, vertical: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        controller.sendFriendInvitation(myPagesModel.id ?? '');
                        Navigator.of(context).pop();
                      },
                      child: Text('Send'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
