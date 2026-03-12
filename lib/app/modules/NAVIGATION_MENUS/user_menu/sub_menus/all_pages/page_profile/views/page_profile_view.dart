import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../component/page_reels_all_components/page_main_reels_component.dart';
import '../component/page_feed_component.dart';
import '../component/page_about.dart';
import '../component/page_more_component.dart';
import '../component/page_more_options/pages_videos_view.dart';
import '../component/page_view_banner_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/page_profile_controller.dart';
import '../component/page_photos_component.dart';

class PageProfileView extends StatefulWidget {
  const PageProfileView({super.key});

  @override
  State<PageProfileView> createState() => _PageProfileViewState();
}

class _PageProfileViewState extends State<PageProfileView>
    with SingleTickerProviderStateMixin {
  late final PageProfileController controller;

  @override
  @override
  void initState() {
    super.initState();

    controller = Get.put(PageProfileController());

    /// MOVE THIS FROM build() TO HERE:
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      controller.pageUserName = Get.arguments['pageUserName'] ?? '';
      controller.isFromPageReels = Get.arguments['isFromPageReels'] ?? 'false';
    } else if (Get.arguments != null) {
      controller.pageUserName = Get.arguments as String;
      controller.isFromPageReels = 'false';
    } else {
      controller.pageUserName = '';
      controller.isFromPageReels = 'false';
    }

    controller.userModel = controller.loginCredential.getUserData();

    controller.getWidgetNumber(pageUserName: controller.pageUserName ?? '');

    controller.initiateAllAPiCall();

    controller.tabController = TabController(
      length: controller.widgetList.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // pageId =Get.arguments as String;
    controller.userModel = controller.loginCredential.getUserData();
    controller.getWidgetNumber(pageUserName: controller.pageUserName ?? '');

    return SafeArea(
      top: true,
      child: Scaffold(
        // backgroundColor: Colors.white,
        // ========================= body section ==============================
        body: RefreshIndicator(
          onRefresh: () async {},
          child: DefaultTabController(
            length: controller.widgetList.length,
            child: CustomScrollView(
              controller: controller.postScrollController,
              slivers: [
                // ========================== page view banner image section ================
                SliverToBoxAdapter(
                  child: Obx(() => Column(
                        children: [
                          // ================ banner image =======================
                          PageViewBannerImage(
                            banner: (controller.pageProfileModel.value
                                        ?.pageDetails?.coverPic ??
                                    '')
                                .formatedProfileUrl,
                            profilePic: (controller.pageProfileModel.value
                                        ?.pageDetails?.profilePic ??
                                    '')
                                .formatedProfileUrl,
                            enableImageUpload: true,
                          ),
                          // ================== page name and followers section ==============
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ============= page name =======================
                                Text(
                                  controller.pageProfileModel.value?.pageDetails
                                          ?.pageName ??
                                      '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // ============== page category ==============
                                    Flexible(
                                      child: Text(
                                        (controller.pageProfileModel.value
                                                    ?.pageDetails?.category)
                                                ?.join(',') ??
                                            '',
                                        style: TextStyle(fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.circle, size: 8),
                                    const SizedBox(width: 5),
                                    // ================ page followers ===========
                                    Text(
                                      '${controller.pageProfileModel.value?.pageDetails?.followerCount ?? 0} ${controller.pageProfileModel.value?.pageDetails?.followerCount == 1 ? "Follower".tr : "Followers".tr}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                // ================ page bio =====================
                                ExpandableText(
                                  controller.pageProfileModel.value?.pageDetails
                                          ?.bio ??
                                      '',
                                  expandText: 'See more',
                                  maxLines: 5,
                                  collapseText: 'See less',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // =================== follow, msg, and more section =============
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
                                    color: Colors.blueGrey.withAlpha(20),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Obx(() => Text(
                                        controller.isFollowing.value
                                            ? 'Unfollow'.tr
                                            : 'Follow'.tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 35,
                                width: Get.width * 0.34,
                                decoration: BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(7)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                        height: 18,
                                        color: Colors.white,
                                        image: AssetImage(
                                            AppAssets.MESSAGER_ICON)),
                                    SizedBox(width: 5),
                                    Text(
                                      'Message'.tr,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),

                              //===========================Pop Up Menu
                              Container(
                                height: 35,
                                width: Get.width * 0.14,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.withAlpha(20),
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
                                              Get.bottomSheet(PageMoreComponent(
                                                  controller: controller,
                                                  onClose: () {
                                                    Get.back();
                                                  }));
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                'More'.tr,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () async {
                                              await controller.homeController
                                                  .getReports();
                                              CustomReportBottomSheet
                                                  .showReportOptions(
                                                context: context,
                                                pageReportList: controller
                                                    .homeController
                                                    .pageReportList
                                                    .value,
                                                selectedReportType: controller
                                                    .homeController
                                                    .selectedReportType,
                                                selectedReportId: controller
                                                    .homeController
                                                    .selectedReportId,
                                                reportDescription: controller
                                                    .homeController
                                                    .reportDescription,
                                                onCancel: () {
                                                  Get.back();
                                                },
                                                reportAction:
                                                    (String report_type_id,
                                                        String report_type,
                                                        String page_id,
                                                        String description) {
                                                  controller.reportAPost(
                                                    report_type: controller
                                                        .homeController
                                                        .selectedReportType
                                                        .value,
                                                    description: controller
                                                        .homeController
                                                        .reportDescription
                                                        .text,
                                                    page_id: controller
                                                            .pageProfileModel
                                                            .value
                                                            ?.pageDetails
                                                            ?.id ??
                                                        '',
                                                    report_type_id: controller
                                                        .homeController
                                                        .selectedReportId
                                                        .value,
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Report'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                )
                                                // Padding(
                                                //   padding: EdgeInsets.all(8.0),
                                                //   child: Text(
                                                //     'Followers                 ',
                                                //       textAlign: TextAlign.center,
                                                //     style: TextStyle(color: Colors.black,fontSize: 17),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ]),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                      double fontSize = screenWidth < 360
                          ? 10
                          : 10; // Smaller font for narrow screens
                      double tabPadding = screenWidth < 360 ? 0 : 0;
                      return TabBar(
                        controller: controller.tabController,
                        tabAlignment: TabAlignment.fill,
                        labelColor: Colors.white,
                        dividerColor: Colors.grey.shade400,
                        indicatorColor: PRIMARY_COLOR,
                        onTap: (index) {
                          if (index < controller.widgetList.length) {
                            controller.viewNumber.value = index; // Normal tabs
                          }
                        },
                        tabs: [
                          Obx(
                            () => Tab(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: tabPadding),
                                child: Text(
                                  'Post'.tr,
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
                                child: Text(
                                  'About'.tr,
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
                                child: Text(
                                  'Photos'.tr,
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
                                child: Text(
                                  'Reels'.tr,
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
                                child: Text(
                                  'Videos'.tr,
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
                    return PageFeedComponent(controller:  controller);
                  } else if (controller.viewNumber.value == 1) {
                    return SliverToBoxAdapter(
                        child: PageAboutComponent(controller: controller));
                  } else if (controller.viewNumber.value == 2) {
                    return PagePhotosComponent(controller: controller);
                  } else if (controller.viewNumber.value == 3) {
                    return SliverToBoxAdapter(
                        child:
                            PageProfileReelsComponent(controller: controller));
                  } else if (controller.viewNumber.value == 4) {
                    return PageVideosView(
                      controller: controller,
                    );
                  }
                  return const SliverToBoxAdapter();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
