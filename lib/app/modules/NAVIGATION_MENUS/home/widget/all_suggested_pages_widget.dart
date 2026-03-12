import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/login_creadential.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../config/constants/color.dart';
import '../../../../routes/app_pages.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';
import '../controllers/home_controller.dart';

class AllSuggestedPagesWidget extends GetView<HomeController> {
  const AllSuggestedPagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hide entire section when no data
      if (controller.suggestedPageList.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        color: Theme.of(context).cardTheme.color,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggested Pages'.tr,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final tabCtrl = Get.find<TabViewController>();
                      final cred = LoginCredential();
                      if (cred.getProfileSwitch()) {
                        tabCtrl.tabController.animateTo(2);
                      } else {
                        tabCtrl.tabController.animateTo(3);
                      }
                    },
                    child: Text(
                      'See all'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.suggestedPageList.value.length,
                itemBuilder: (context, index) {
                  final page = controller.suggestedPageList.value[index];
                  return _CompactPageCard(
                    pageName: page.pageName ?? '',
                    category: page.category.isNotEmpty ? page.category.first : '',
                    coverPic: (page.coverPic ?? '').formatedProfileUrl,
                    profilePic: (page.profilePic ?? '').formatedProfileUrl,
                    followerCount: page.followerCount ?? 0,
                    onTap: () => Get.toNamed(Routes.PAGE_PROFILE, arguments: page.pageUserName),
                    onFollow: () => controller.followPage(pageId: page.id ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _CompactPageCard extends StatelessWidget {
  final String pageName;
  final String category;
  final String coverPic;
  final String profilePic;
  final int followerCount;
  final VoidCallback onTap;
  final VoidCallback onFollow;

  const _CompactPageCard({
    required this.pageName,
    required this.category,
    required this.coverPic,
    required this.profilePic,
    required this.followerCount,
    required this.onTap,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image(
                height: 70,
                width: 140,
                fit: BoxFit.cover,
                image: NetworkImage(coverPic),
                errorBuilder: (_, __, ___) => Container(
                  height: 70,
                  width: 140,
                  color: Colors.grey[200],
                  child: const Image(
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                pageName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            if (category.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ),
            const Spacer(),
            // Follow button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                height: 28,
                child: ElevatedButton(
                  onPressed: onFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: Text('Follow'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
