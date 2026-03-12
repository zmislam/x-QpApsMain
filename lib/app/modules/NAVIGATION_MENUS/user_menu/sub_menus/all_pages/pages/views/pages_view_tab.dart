import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/pages_controller.dart';
import '../model/allpages_model.dart';
import 'create_page_view.dart';
import 'discover_page_search.dart';
import 'followed_page_view.dart';
import 'invites_page_view.dart';
import 'my_pages_view.dart';

class PagesViewTab extends GetView<PagesController> {
  final bool? isFromTab;

  const PagesViewTab({super.key, this.isFromTab});

  @override
  Widget build(BuildContext context) {
    final size = Get.size;
    return Scaffold(
      // ============================== body section ===========================
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.allpagesList.value.clear();
            // Todo: resolve when cash is implemented
            controller.skip = 0;
            await controller.getAllPages(initial: true);
          },
          child: CustomScrollView(
            controller: controller.discoverPageScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isFromTab != true)
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back)),
                      Text('Discover '.tr,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => const CreatePageView());
                          },
                          icon: Image.asset(AppAssets.CREATE_ICON),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => const DiscoverPageSearch());
                          },
                          icon: const Image(image: AssetImage(AppAssets.SEARCH_ICON)),
                        ),
                      )
                    ],
                  ),
                ),
              // ========================= divider =============================
              if (isFromTab != true) const SliverToBoxAdapter(child: Divider()),
              // ========================= top action buttons ==================
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 10),
                        // ======================== discover button ============
                        ActionChip(
                          side: BorderSide.none,
                          padding: EdgeInsets.symmetric(horizontal: _getWidthPadding()),
                          backgroundColor: controller.view.value == 0 ? Colors.grey.shade300 : PRIMARY_COLOR,
                          label: Text('Discover'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            controller.view.value == 0;
                          },
                        ),
                        const SizedBox(width: 5),
                        // ======================== followed page ==============
                        ActionChip(
                          side: BorderSide.none,
                          // backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: _getWidthPadding()),
                          label: Text('Followed Page'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            controller.getFollowedPages();
                            Get.to(() => const FollowedPageView());
                          },
                        ),
                        if (!controller.loginCredential.getProfileSwitch()) const SizedBox(width: 5),
                        // ======================== invites ====================
                        if (!controller.loginCredential.getProfileSwitch())
                          ActionChip(
                            side: BorderSide.none,
                            // backgroundColor: Colors.white,
                            label: Text('Invites'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              controller.getInvites();
                              Get.to(() => const InvitesPageView());
                            },
                          ),
                        if (!controller.loginCredential.getProfileSwitch()) const SizedBox(width: 5),
                        // ======================== my pages ===================
                        if (!controller.loginCredential.getProfileSwitch())
                          ActionChip(
                            side: BorderSide.none,
                            // backgroundColor: Colors.white,
                            label: Text('My Pages'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              controller.getMyPages();
                              Get.to(() => const MyPagesView());
                            },
                          ),
                        SizedBox(width: (controller.loginCredential.getProfileSwitch()) ? 10 : 5),
                      ],
                    ),
                  ),
                ),
              ),
              // =================== discover page title =======================
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Discover Page'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Add loading indicator

              //? PAGE LIST
              Obx(() {
                if (controller.allpagesList.value.isNotEmpty) {
                  return SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: isFromTab == true ? 0 : 0,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.80,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          AllPagesModel allPagesModel = controller.allpagesList.value[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 0,
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  Routes.PAGE_PROFILE,
                                  arguments: allPagesModel.pageUserName,
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              CachedNetworkImage(
                              imageUrl: ('${allPagesModel.coverPic}').formatedProfileUrl,
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,

                              // Placeholder (optional)
                              placeholder: (context, url) => const SizedBox(
                                height: 90,
                                width: double.infinity,
                                child: Center(child: CircularProgressIndicator()),
                              ),

                              // Error widget
                              errorWidget: (context, url, error) => const Image(
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: AssetImage(AppAssets.DEFAULT_IMAGE),
                              ),
                            ),
                              const SizedBox(height: 5),
                                  Text(
                                    allPagesModel.pageName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    (allPagesModel.category as List<String>?)?.join('') ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${allPagesModel.followerCount}-people follow'.tr,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 35,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        controller.followPage(allPagesModel.id ?? '');
                                      },
                                      child: Text(
                                        'Follow'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: controller.allpagesList.value.length,
                      ),
                    ),
                  );
                }

                // Show empty state if no pages and not loading
                if (!controller.isLoadingUserPages.value &&
                    controller.allpagesList.value.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 250),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                                'assets/image/invitation.png',
                                width: 30,
                                height: 30
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No Pages to Discover'.tr,
                              style: TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),


              //* LOADING ANIMATION
              Obx(() {
                if (controller.isLoadingUserPages.value) {
                  return const SliverToBoxAdapter(child: GroupShimmerLoader());
                } else {
                  return const SliverToBoxAdapter(child: SizedBox());
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  double _getWidthPadding() {
    return (controller.loginCredential.getProfileSwitch()) ? ((Get.size.width / 4) - 55) : 10;
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../../../extension/string/string_image_path.dart';
// import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
// import '../../../../../../../config/constants/app_assets.dart';
// import '../../../../../../../config/constants/color.dart';
// import '../../../../../../../routes/app_pages.dart';
// import '../controllers/pages_controller.dart';
// import '../model/allpages_model.dart';
// import 'create_page_view.dart';
// import 'discover_page_search.dart';
// import 'followed_page_view.dart';
// import 'invites_page_view.dart';
// import 'my_pages_view.dart';
//
// class PagesViewTab extends GetView<PagesController> {
//   final bool? isFromTab;
//
//   const PagesViewTab({super.key, this.isFromTab});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = Get.size;
//     return Scaffold(
//       // ============================== body section ===========================
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             controller.allpagesList.value.clear();
//             // Todo: resolve when cash is implemented
//             controller.skip = 0;
//             await controller.getAllPages(skip: 0);
//           },
//           child: CustomScrollView(
//             controller: controller.discoverPageScrollController,
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               if (isFromTab != true)
//                 SliverToBoxAdapter(
//                   child: Row(
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           icon: const Icon(Icons.arrow_back)),
//                       Text('Discover '.tr,
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(
//                         height: 48,
//                         width: 48,
//                         child: IconButton(
//                           onPressed: () {
//                             Get.to(() => const CreatePageView());
//                           },
//                           icon: Image.asset(AppAssets.CREATE_ICON),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 48,
//                         width: 48,
//                         child: IconButton(
//                           onPressed: () {
//                             Get.to(() => const DiscoverPageSearch());
//                           },
//                           icon: const Image(image: AssetImage(AppAssets.SEARCH_ICON)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               // ========================= divider =============================
//               if (isFromTab != true) const SliverToBoxAdapter(child: Divider()),
//               // ========================= top action buttons ==================
//               SliverToBoxAdapter(
//                 child: Container(
//                   alignment: Alignment.centerLeft,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const SizedBox(width: 10),
//                         // ======================== discover button ============
//                         ActionChip(
//                           side: BorderSide.none,
//                           padding: EdgeInsets.symmetric(horizontal: _getWidthPadding()),
//                           backgroundColor: controller.view.value == 0 ? Colors.grey.shade300 : PRIMARY_COLOR,
//                           label: Text('Discover'.tr,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: PRIMARY_COLOR,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           onPressed: () {
//                             controller.view.value == 0;
//                           },
//                         ),
//                         const SizedBox(width: 5),
//                         // ======================== followed page ==============
//                         ActionChip(
//                           side: BorderSide.none,
//                           // backgroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(horizontal: _getWidthPadding()),
//                           label: Text('Followed Page'.tr,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: PRIMARY_COLOR,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           onPressed: () {
//                             controller.getFollowedPages();
//                             Get.to(() => const FollowedPageView());
//                           },
//                         ),
//                         if (!controller.loginCredential.getProfileSwitch()) const SizedBox(width: 5),
//                         // ======================== invites ====================
//                         if (!controller.loginCredential.getProfileSwitch())
//                           ActionChip(
//                             side: BorderSide.none,
//                             // backgroundColor: Colors.white,
//                             label: Text('Invites'.tr,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: PRIMARY_COLOR,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             onPressed: () {
//                               controller.getInvites();
//                               Get.to(() => const InvitesPageView());
//                             },
//                           ),
//                         if (!controller.loginCredential.getProfileSwitch()) const SizedBox(width: 5),
//                         // ======================== my pages ===================
//                         if (!controller.loginCredential.getProfileSwitch())
//                           ActionChip(
//                             side: BorderSide.none,
//                             // backgroundColor: Colors.white,
//                             label: Text('My Pages'.tr,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: PRIMARY_COLOR,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             onPressed: () {
//                               controller.getMyPages();
//                               Get.to(() => const MyPagesView());
//                             },
//                           ),
//                         SizedBox(width: (controller.loginCredential.getProfileSwitch()) ? 10 : 5),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // =================== discover page title =======================
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Text('Discover Page'.tr,
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//
//               // Add loading indicator
//
//               //? PAGE LIST
//               Obx(() {
//                 if (controller.allpagesList.value.isNotEmpty) {
//                   return SliverPadding(
//                     padding: EdgeInsets.only(
//                       bottom: isFromTab == true ? 160 : 0, // Dynamic bottom padding for the whole grid
//                     ),
//                     sliver: SliverGrid(
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.80,
//                       ),
//                       delegate: SliverChildBuilderDelegate(
//                             (BuildContext context, int index) {
//                           AllPagesModel allPagesModel = controller.allpagesList.value[index];
//                           return Padding(
//                             padding: const EdgeInsets.only(
//                               top: 10,
//                               left: 10,
//                               right: 10,
//                               bottom: 0,
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Get.toNamed(
//                                   Routes.PAGE_PROFILE,
//                                   arguments: allPagesModel.pageUserName,
//                                 );
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Image(
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return const Image(
//                                         height: 90,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         image: AssetImage(AppAssets.DEFAULT_IMAGE),
//                                       );
//                                     },
//                                     height: 90,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                     image: NetworkImage(('${allPagesModel.coverPic}').formatedProfileUrl),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     allPagesModel.pageName ?? '',
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     (allPagesModel.category as List<String>?)?.join('') ?? '',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text('${allPagesModel.followerCount}-people follow'.tr,
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Container(
//                                     height: 35,
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: PRIMARY_COLOR,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: TextButton(
//                                       onPressed: () {
//                                         controller.followPage(allPagesModel.id ?? '');
//                                       },
//                                       child: Text('Follow'.tr,
//                                         style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
//                                       ),
//                                     ),
//                                   ),
//                                   // const SizedBox(
//                                   //   height: 10,
//                                   // )
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                         childCount: controller.allpagesList.value.length,
//                       ),
//                     ),
//                   );
//                 } else if (!controller.isLoadingUserPages.value) {
//                   return SliverToBoxAdapter(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 250),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Image.asset('assets/image/invitation.png', width: 30, height: 30),
//                             const SizedBox(height: 10),
//                             Text('No Pages to Discover'.tr,
//                               style: TextStyle(color: Colors.grey, fontSize: 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return const SliverToBoxAdapter();
//                 }
//               }),
//
//               //* LOADING ANIMATION
//               Obx(() {
//                 if (controller.isLoadingUserPages.value) {
//                   return const SliverToBoxAdapter(child: GroupShimmerLoader());
//                 } else {
//                   return const SliverToBoxAdapter(child: SizedBox());
//                 }
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   double _getWidthPadding() {
//     return (controller.loginCredential.getProfileSwitch()) ? ((Get.size.width / 4) - 55) : 10;
//   }
// }
