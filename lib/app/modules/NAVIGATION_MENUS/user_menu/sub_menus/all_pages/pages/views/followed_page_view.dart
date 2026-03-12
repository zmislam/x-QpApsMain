import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/pages_controller.dart';
import '../model/allpages_model.dart';

class FollowedPageView extends GetView<PagesController> {
  const FollowedPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================ appbar section ===========================
      appBar: AppBar(
        title: Text('Followed Page'.tr,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      // ============================ body section =============================
      body: RefreshIndicator(
        onRefresh: () async {
          // controller.followedPageList.value.clear();
          await controller.getFollowedPages();
        },
        child: SingleChildScrollView(
          controller: controller.followedPageScrollController,
          child: Column(
            children: [
              const Divider(),
              Obx(() {
                if (controller.followedPageList.value.isNotEmpty && !controller.isLoadingUserPages.value) {
                  return GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.followedPageList.value.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      AllPagesModel followedPageModel = controller.followedPageList.value[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.PAGE_PROFILE,
                            arguments: followedPageModel.pageUserName,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                errorBuilder: (context, error, stackTrace) {
                                  return const Image(
                                    height: 90,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      AppAssets.DEFAULT_IMAGE,
                                    ),
                                  );
                                },
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: NetworkImage(('${controller.followedPageList.value[index].coverPic}').formatedProfileUrl),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      ('${controller.followedPageList.value[index].profilePic}').formatedProfileUrl,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.PAGE_PROFILE, arguments: followedPageModel.pageUserName);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            followedPageModel.pageName ?? '',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text('${followedPageModel.followerCount ?? 0} - people follow'.tr,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text('Send message'.tr,
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (controller.followedPageList.value.isEmpty && !controller.isLoadingUserPages.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset('assets/image/invitation.png', width: 30, height: 30),
                          const SizedBox(height: 10),
                          Text('You Have no Followed Page Yet'.tr,
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
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
    );
  }
}
