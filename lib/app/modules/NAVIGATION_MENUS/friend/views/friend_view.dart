import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/friend_request.dart';
import '../../../../components/people_may_you_know_card.dart';
import '../../../../components/simmar_loader.dart';
import '../../../../config/constants/color.dart';
import '../../../../config/constants/feed_design_tokens.dart';
import '../../../../models/firend_request.dart';
import '../../../../routes/app_pages.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';
import '../controllers/friend_controller.dart';
import '../model/people_may_you_khnow.dart';

class FriendView extends GetView<FriendController> {
  const FriendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: FeedDesignTokens.textPrimary(context)),
            onPressed: () {
              // Go back to Home tab
              final tabController =
                  Get.find<TabViewController>();
              tabController.tabIndex.value = 0;
              if (tabController.tabControllerInitComplete.value) {
                tabController.tabController.animateTo(0);
              }
            },
          ),
          title: Text(
            'Friends'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: FeedDesignTokens.textPrimary(context),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.search,
                  color: FeedDesignTokens.textPrimary(context), size: 24),
              onPressed: () => Get.toNamed(Routes.ADVANCE_SEARCH),
            ),
          ],
        ),
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).cardTheme.color,
          color: PRIMARY_COLOR,
          onRefresh: () => controller.refreshAll(),
          child: ListView(
            controller: controller.friendsScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 12),
              _buildFilterChips(context),
              const SizedBox(height: 16),
              _buildFriendRequestSection(context),
              const SizedBox(height: 8),
              _buildSuggestionsSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Filter Chips ────────────────────────────────────────
  Widget _buildFilterChips(BuildContext context) {
    return Row(
      children: [
        _FriendFilterChip(
          label: 'Suggestions'.tr,
          onTap: () => Get.toNamed(Routes.FRIEND_SUGGESTION),
        ),
        const SizedBox(width: 8),
        _FriendFilterChip(
          label: 'Your Friends'.tr,
          onTap: () => Get.toNamed(Routes.YOUR_FRIENDS),
        ),
      ],
    );
  }

  // ─── Friend Requests Section ─────────────────────────────
  Widget _buildFriendRequestSection(BuildContext context) {
    return Obx(() {
      if (controller.isFriendRequestLoading.value) {
        return _ShimmerLoadingView(itemCount: 3);
      }

      final requests = controller.friendRequestList.value;
      if (requests.isEmpty) {
        return const SizedBox.shrink();
      }

      // Show max 5 requests in preview
      final previewRequests = requests.take(5).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Friend Requests'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                  TextSpan(
                    text: ' ${requests.length}',
                    style: const TextStyle(
                      color: ACCENT_COLOR,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              if (requests.length > 5)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full request list
                  },
                  child: Text(
                    'See All'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          // Request Cards
          ...previewRequests.map((request) => FriendRequestCard(
                friendRequestModel: request,
                onPressedAccept: () {
                  controller.actionOnFriendRequest(
                    action: 1,
                    requestId: request.id!,
                  );
                },
                onPressedReject: () {
                  controller.actionOnFriendRequest(
                    action: 0,
                    requestId: request.id!,
                  );
                },
              )),

          Divider(color: FeedDesignTokens.divider(context)),
        ],
      );
    });
  }

  // ─── Suggestions Section ─────────────────────────────────
  Widget _buildSuggestionsSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPeopleYouMayKnow.value &&
          controller.peopleMayYouKnowList.value.isEmpty) {
        return _ShimmerLoadingView(itemCount: 4);
      }

      final suggestions = controller.peopleMayYouKnowList.value;
      if (suggestions.isEmpty && !controller.isLoadingPeopleYouMayKnow.value) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'People You May Know'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: FeedDesignTokens.textPrimary(context),
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.FRIEND_SUGGESTION),
                child: Text(
                  'See All'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Suggestion Cards
          ...suggestions.map((people) {
            final index = suggestions.indexOf(people);
            return PeopleMayYouKnowCard(
              peopleMayYouKnowModel: people,
              onPressedAddFriend: () {
                controller.sendFriendRequest(
                  index: index,
                  userId: people.id ?? '',
                );
              },
              onPressedRemove: () {
                controller.removeSuggestion(index);
              },
            );
          }),

          if (controller.isLoadingPeopleYouMayKnow.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: PRIMARY_COLOR),
              ),
            ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════
//  Filter Chip Widget
// ═══════════════════════════════════════════════════════════════
class _FriendFilterChip extends StatelessWidget {
  const _FriendFilterChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: FeedDesignTokens.inputBg(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shimmer Loading View
// ═══════════════════════════════════════════════════════════════
class _ShimmerLoadingView extends StatelessWidget {
  const _ShimmerLoadingView({this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerLoader(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
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
          ),
        );
      },
    );
  }
}
