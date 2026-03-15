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

class FollowedPageView extends GetView<PagesController> {
  const FollowedPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(),
        title: Text(
          'Followed Pages'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).cardTheme.color,
        color: PRIMARY_COLOR,
        onRefresh: () async {
          await controller.getFollowedPages(forceFetch: true);
        },
        child: Obx(() {
          final isLoading = controller.isLoadingFollowedPages.value;
          final followedPages = controller.followedPageList.value;

          if (isLoading && followedPages.isEmpty) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),
                ...List.generate(
                    6, (_) => _buildShimmerFollowedItem(context)),
              ],
            );
          }

          if (followedPages.isEmpty) {
            return ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.flag_outlined,
                          size: 48,
                          color: FeedDesignTokens.textSecondary(context)),
                      const SizedBox(height: 12),
                      Text(
                        'You haven\'t followed any pages yet'.tr,
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
            controller: controller.followedPageScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: followedPages.length,
            itemBuilder: (context, index) {
              return _buildFollowedPageItem(
                  context, followedPages[index]);
            },
          );
        }),
      ),
    );
  }

  // ─── Single Followed Page Item ───────────────────────────
  Widget _buildFollowedPageItem(
      BuildContext context, AllPagesModel page) {
    return InkWell(
      onTap: () =>
          Get.toNamed(Routes.PAGE_PROFILE, arguments: page.pageUserName),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (page.category.isNotEmpty)
                        ? page.category.join(', ')
                        : '${page.followerCount ?? 0} ${'followers'.tr}',
                    style: TextStyle(
                      fontSize: 13,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Following button
            SizedBox(
              height: 34,
              child: OutlinedButton.icon(
                onPressed: () => _showUnfollowDialog(context, page),
                icon: Icon(Icons.check, size: 16, color: PRIMARY_COLOR),
                label: Text(
                  'Following'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PRIMARY_COLOR,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: PRIMARY_COLOR),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            // Three-dot menu
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz,
                  color: FeedDesignTokens.textSecondary(context), size: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'unfollow') {
                  _showUnfollowDialog(context, page);
                } else if (value == 'view') {
                  Get.toNamed(Routes.PAGE_PROFILE,
                      arguments: page.pageUserName);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility_outlined,
                          size: 20,
                          color: FeedDesignTokens.textPrimary(context)),
                      const SizedBox(width: 12),
                      Text('View Page'.tr),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'unfollow',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove_outlined,
                          size: 20, color: Colors.red),
                      const SizedBox(width: 12),
                      Text('Unfollow'.tr,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Unfollow Dialog ─────────────────────────────────────
  void _showUnfollowDialog(BuildContext context, AllPagesModel page) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FeedDesignTokens.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Unfollow ${page.pageName}?'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        content: Text(
          'You will no longer see updates from this page in your feed.'.tr,
          style: TextStyle(
            fontSize: 14,
            color: FeedDesignTokens.textSecondary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'.tr,
                style: TextStyle(
                    color: FeedDesignTokens.textSecondary(context))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.unfollowPage(page.id ?? '');
            },
            child: Text('Unfollow'.tr,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Shimmer Item ────────────────────────────────────────
  Widget _buildShimmerFollowedItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  width: 140,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 90,
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
            width: 90,
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
