import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/pages_controller.dart';
import '../model/allpages_model.dart';
import 'discover_page_search.dart';

class DiscoverPagesView extends GetView<PagesController> {
  const DiscoverPagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(),
        title: Text(
          'Discover'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search,
                color: FeedDesignTokens.textPrimary(context), size: 24),
            onPressed: () => Get.to(() => const DiscoverPageSearch()),
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).cardTheme.color,
        color: PRIMARY_COLOR,
        onRefresh: () => controller.getAllPages(initial: true),
        child: Obx(() {
          final isLoading = controller.isLoadingDiscoverPages.value;
          final pages = controller.allpagesList.value;

          if (isLoading && pages.isEmpty) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),
                Text(
                  'Suggested for you'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(8, (_) => _buildShimmerItem(context)),
              ],
            );
          }

          if (pages.isEmpty) {
            return ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.explore_outlined,
                          size: 48,
                          color: FeedDesignTokens.textSecondary(context)),
                      const SizedBox(height: 12),
                      Text(
                        'No pages to discover'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            controller: controller.discoverPageScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pages.length + 1, // +1 for header
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12),
                  child: Text(
                    'Suggested for you'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                );
              }

              final page = pages[index - 1];
              return _buildDiscoverPageItem(context, page);
            },
          );
        }),
      ),
    );
  }

  // ─── Single Discover Page Item ───────────────────────────
  Widget _buildDiscoverPageItem(
      BuildContext context, AllPagesModel page) {
    return InkWell(
      onTap: () =>
          Get.toNamed(Routes.PAGE_PROFILE, arguments: page.pageUserName),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Page avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: FeedDesignTokens.inputBg(context),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: (page.profilePic ?? '').formatedProfileUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Page info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.pageName ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${page.followerCount ?? 0} ${'followers'.tr}',
                    style: TextStyle(
                      fontSize: 13,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            // Follow button
            SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: () => controller.followPage(page.id ?? ''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Follow'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Remove / dismiss button
            IconButton(
              onPressed: () {
                controller.allpagesList.value.removeWhere(
                    (p) => p.id == page.id);
                controller.allpagesList.refresh();
              },
              icon: Icon(Icons.close,
                  size: 20,
                  color: FeedDesignTokens.textSecondary(context)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                  minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shimmer Item ────────────────────────────────────────
  Widget _buildShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: FeedDesignTokens.inputBg(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 130,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 34,
            width: 80,
            decoration: BoxDecoration(
              color: FeedDesignTokens.inputBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
