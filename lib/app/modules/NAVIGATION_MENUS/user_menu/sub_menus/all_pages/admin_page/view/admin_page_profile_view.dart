import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../components/admin_reels_component/admin_page_profile_reels_component.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../routes/app_pages.dart';
import '../admin_page_more_options_view/admin_page_videos.dart';
import '../admin_photos_albums_view/admin_page_photos_component.dart';
import '../components/about.dart';
import '../components/admin_feed_component.dart';
import '../components/more_component.dart';
import '../controller/admin_page_controller.dart';
import 'admin_page_view_banner.dart';

class AdminPageProfileView extends StatefulWidget {
  const AdminPageProfileView({Key? key}) : super(key: key);

  @override
  State<AdminPageProfileView> createState() => _AdminPageProfileViewState();
}

class _AdminPageProfileViewState extends State<AdminPageProfileView>
    with SingleTickerProviderStateMixin {
  late final AdminPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AdminPageController());

    controller.tabController = TabController(
      length: 5,
      vsync: this,
    );

    controller.tabController.addListener(() {
      if (controller.tabController.indexIsChanging) return;
      controller.viewNumber.value = controller.tabController.index;
    });
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> widgetList = [
    //   AdminFeedComponent(controller: controller),
    //   AboutComponent(controller: controller),
    //   AdminPagePhotosComponent(controller: controller),
    //   AdminPageVideosView(controller: controller),
    // ];

    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            controller.postList.value.clear();
            controller.pageNo = 1;
            controller.getPageDetails();

            controller.getVideoAds();
            controller.getVideos(controller.pageUserName ?? '');
            await controller.getPosts(
                controller.pageProfileModel.value?.pageDetails?.id ?? '');

            controller.pinnedPostList;
          },
          child: DefaultTabController(
              // @ ADDING +1 FOR MORE TAB
              length: 5,
              child: CustomScrollView(
                controller: controller.postScrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Obx(() => Column(
                          children: [
                            AdminPageViewBanner(
                              profileImageUpload: () async {
                                await controller.uploadPageProfilePicture(
                                    '${controller.pageProfileModel.value?.pageDetails?.id}');
                                controller.pageProfileModel.refresh();
                                controller.getPageDetails();
                              },
                              banner: (controller.pageProfileModel.value
                                          ?.pageDetails?.coverPic ??
                                      '')
                                  .formatedProfileUrl,
                              profilePic: (controller.pageProfileModel.value
                                          ?.pageDetails?.profilePic ??
                                      '')
                                  .formatedProfileUrl,
                              enableImageUpload: true,
                              coverImageUpload: () async {
                                await controller.uploadPageCoverPicture(
                                    controller.pageProfileModel.value
                                            ?.pageDetails?.id ??
                                        '');
                                controller.pageProfileModel.refresh();

                                controller.getPageDetails();
                              },
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.pageProfileModel.value
                                            ?.pageDetails?.pageName ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        controller.pageProfileModel.value
                                                ?.pageDetails?.category
                                                .join('') ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.circle, size: 8),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${controller.pageProfileModel.value?.pageDetails?.followerCount ?? 0} ${controller.pageProfileModel.value?.pageDetails?.followerCount == 1 ? "Follower" : "Followers"}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ExpandableText(
                                    controller.pageProfileModel.value
                                            ?.pageDetails?.bio ??
                                        '',
                                    expandText: 'See more',
                                    maxLines: 3,
                                    collapseText: 'See less',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Manage and Message buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (controller.isFollowing.value) {
                                      controller.unfollow(controller
                                              .pageProfileModel
                                              .value
                                              ?.pageDetails
                                              ?.id ??
                                          '');
                                      controller.isFollowing.value = false;
                                    } else {
                                      controller.followPage(controller
                                              .pageProfileModel
                                              .value
                                              ?.pageDetails
                                              ?.id ??
                                          '');
                                      controller.isFollowing.value = true;
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: Get.width * 0.38,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Obx(() => Text(
                                          controller.isFollowing.value
                                              ? 'Unfollow'
                                              : 'Follow',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () => Get.toNamed(Routes.PAGE_SETTINGS,
                                      arguments: controller
                                          .pageProfileModel.value?.role),
                                  child: Container(
                                    height: 40,
                                    width: Get.width * 0.38,
                                    decoration: BoxDecoration(
                                      color: PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                            height: 18,
                                            color: Colors.white,
                                            image: AssetImage(
                                                AppAssets.SETTING_ICON)),
                                        SizedBox(width: 5),
                                        Text('Manage'.tr,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 35,
                                  width: Get.width * 0.14,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: PopupMenuButton(
                                      offset: const Offset(10, 50),
                                      iconColor: Colors.white,
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.black,
                                      ),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () {
                                                Get.bottomSheet(
                                                    PageMoreComponent(
                                                  controller: controller,
                                                  onClose: () {
                                                    Get.back();
                                                  },
                                                ));
                                              },
                                              child: Text('More'.tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () async {},
                                              child: Text('Message'.tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                          ],
                        )),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    // backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        double fontSize = screenWidth < 360 ? 10 : 10;
                        double tabPadding = screenWidth < 360 ? 0 : 0;
                        return TabBar(
                          controller: controller.tabController,
                          tabAlignment: TabAlignment.fill,
                          dividerColor: Colors.grey.shade400,
                          indicatorColor: PRIMARY_COLOR,
                          onTap: (index) {
                            if (index < controller.widgetList.length) {
                              controller.viewNumber.value =
                                  index; // Normal tabs
                            }
                          },
                          tabs: [
                            Obx(
                              () => Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: tabPadding),
                                  child: Text('Post'.tr,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: controller.viewNumber.value == 0
                                          ? PRIMARY_COLOR
                                          : GREY_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: tabPadding),
                                  child: Text('About'.tr,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: controller.viewNumber.value == 1
                                          ? PRIMARY_COLOR
                                          : GREY_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: tabPadding),
                                  child: Text('Photos'.tr,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: controller.viewNumber.value == 2
                                          ? PRIMARY_COLOR
                                          : GREY_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: tabPadding),
                                  child: Text('Reels'.tr,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: controller.viewNumber.value == 3
                                          ? PRIMARY_COLOR
                                          : GREY_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: tabPadding),
                                  child: Text('Videos'.tr,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: controller.viewNumber.value == 4
                                          ? PRIMARY_COLOR
                                          : GREY_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Obx(() {
                    if (controller.viewNumber.value == 0) {
                      return AdminFeedComponent(controller: controller);
                    } else if (controller.viewNumber.value == 1) {
                      return SliverToBoxAdapter(
                          child: AboutComponent(controller: controller));
                    } else if (controller.viewNumber.value == 2) {
                      return AdminPagePhotosComponent(controller: controller);
                    } else if (controller.viewNumber.value == 3) {
                      return SliverToBoxAdapter(
                        child: AdminPageProfileReelsComponent(
                          controller: controller,
                        ),
                      );
                    } else if (controller.viewNumber.value == 4) {
                      return AdminPageVideosView(
                        controller: controller,
                      );
                    }
                    return const SliverToBoxAdapter();
                  }),
                ],
              )),
        ),
      ),
    );
  }
}
