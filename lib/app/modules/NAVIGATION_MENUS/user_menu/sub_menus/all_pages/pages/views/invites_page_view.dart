import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/pages_controller.dart';
import '../model/invites_page_model.dart';

class InvitesPageView extends GetView<PagesController> {
  const InvitesPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ======================== appbar section =============================
        appBar: AppBar(
          title: Text('Invites'.tr,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: const BackButton(),
        ),
        // ======================== body section ===============================
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getInvites();
          },
          child: SingleChildScrollView(
            controller: controller.invitePageScrollController,
            child: Column(
              children: [
                const Divider(),
                Obx(() {
                  if (controller.invitesPageList.value.isNotEmpty && !controller.isLoadingUserPages.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.invitesPageList.value.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          InvitesPageModel invitesPageModel = controller.invitesPageList.value[index];

                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                Routes.PAGE_PROFILE,
                                arguments: invitesPageModel.pageId?.pageUserName,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
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
                                      image: NetworkImage(('${controller.invitesPageList.value[index].pageId?.coverPic}').formatedProfileUrl),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    invitesPageModel.pageId?.pageName ?? '',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Invited by ${invitesPageModel.createdBy?.firstName ?? ''} ${invitesPageModel.createdBy?.lastName ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 35,
                                          decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: BorderRadius.circular(10)),
                                          child: TextButton(
                                              onPressed: () {
                                                controller.acceptPage(invitesPageModel.id ?? '', '${invitesPageModel.pageId ?? ''}');
                                              },
                                              child: Text('Accept'.tr,
                                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Container(
                                          height: 35,
                                          decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(10)),
                                          child: TextButton(
                                              onPressed: () {
                                                controller.declinedPage(invitesPageModel.id ?? '');
                                              },
                                              child: Text('Cancel'.tr,
                                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (controller.invitesPageList.value.isEmpty && !controller.isLoadingUserPages.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 250),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/image/invitation.png', width: 30, height: 30),
                            const SizedBox(height: 10),
                            Text('No Pages Invitation'.tr,
                              style: TextStyle(color: Colors.grey, fontSize: 20),
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
                //     return SizedBox();
                //   }
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
