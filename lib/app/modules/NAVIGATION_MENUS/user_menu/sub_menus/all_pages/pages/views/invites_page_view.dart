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
import '../model/invites_page_model.dart';

class InvitesPageView extends GetView<PagesController> {
  const InvitesPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const BackButton(),
          title: Text(
            'Invitations'.tr,
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
            await controller.getInvites();
            await controller.getAllPages(initial: true);
          },
          child: ListView(
            controller: controller.invitePageScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 16),
              _buildPendingInvitationsSection(context),
              const SizedBox(height: 24),
              _buildSuggestedPagesSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Pending Invitations Section ─────────────────────────
  Widget _buildPendingInvitationsSection(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoadingUserPages.value;
      final invites = controller.invitesPageList.value;

      if (isLoading && invites.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending invitations'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: FeedDesignTokens.textPrimary(context),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(3, (_) => _buildShimmerInviteItem(context)),
          ],
        );
      }

      if (invites.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending invitations'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: FeedDesignTokens.textPrimary(context),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Icon(Icons.mail_outline,
                      size: 48,
                      color: FeedDesignTokens.textSecondary(context)),
                  const SizedBox(height: 12),
                  Text(
                    'No pending invitations'.tr,
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Pending invitations'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                  TextSpan(
                    text: ' ${invites.length}',
                    style: const TextStyle(
                      color: ACCENT_COLOR,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Invitation items
          ...invites.map((invite) => _buildInvitationItem(context, invite)),
        ],
      );
    });
  }

  // ─── Single Invitation Item ──────────────────────────────
  Widget _buildInvitationItem(
      BuildContext context, InvitesPageModel invite) {
    final inviterName =
        '${invite.createdBy?.firstName ?? ''} ${invite.createdBy?.lastName ?? ''}'
            .trim();
    final pageName = invite.pageId?.pageName ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inviter avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: FeedDesignTokens.inputBg(context),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    (invite.createdBy?.profilePic ?? '').formatedProfileUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Image(
                  image: AssetImage(AppAssets.DEFAULT_IMAGE),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Invite details + buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "X invited you to follow PageName"
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    children: [
                      TextSpan(
                        text: inviterName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${'invited you to follow'.tr} '),
                      TextSpan(
                        text: pageName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Accept / Decline buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.acceptPage(
                              invite.id ?? '',
                              invite.pageId?.id ?? '',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Accept'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.declinedPage(invite.id ?? '');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FeedDesignTokens.inputBg(context),
                            foregroundColor:
                                FeedDesignTokens.textPrimary(context),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Decline'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Suggested Pages Section ─────────────────────────────
  Widget _buildSuggestedPagesSection(BuildContext context) {
    return Obx(() {
      final pages = controller.allpagesList.value;
      if (pages.isEmpty) return const SizedBox.shrink();

      // Show max 5 suggested pages
      final suggestions = pages.take(5).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: FeedDesignTokens.divider(context)),
          const SizedBox(height: 12),
          Text(
            'Suggested Pages'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: FeedDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 12),
          ...suggestions.map(
              (page) => _buildSuggestedPageItem(context, page)),
        ],
      );
    });
  }

  // ─── Single Suggested Page Item ──────────────────────────
  Widget _buildSuggestedPageItem(
      BuildContext context, AllPagesModel page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () =>
            Get.toNamed(Routes.PAGE_PROFILE, arguments: page.pageUserName),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: FeedDesignTokens.inputBg(context),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: (page.profilePic ?? '').formatedProfileUrl,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
          ],
        ),
      ),
    );
  }

  // ─── Shimmer Invite Item ─────────────────────────────────
  Widget _buildShimmerInviteItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: FeedDesignTokens.inputBg(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 180,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: FeedDesignTokens.inputBg(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: FeedDesignTokens.inputBg(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
