import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/people_may_you_know_card.dart';
import '../../../../components/simmar_loader.dart';
import '../../../../config/constants/color.dart';
import '../../../../config/constants/feed_design_tokens.dart';
import '../controllers/friend_controller.dart';

class FriendSuggestionView extends GetView<FriendController> {
  const FriendSuggestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure suggestions are loaded
    if (controller.peopleMayYouKnowList.value.isEmpty &&
        !controller.isLoadingPeopleYouMayKnow.value) {
      controller.getPeopleMayYouKnow(skip: 0, limit: 20);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FeedDesignTokens.cardBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: FeedDesignTokens.textPrimary(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Suggestions'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final suggestions = controller.peopleMayYouKnowList.value;
        final isLoading = controller.isLoadingPeopleYouMayKnow.value;

        if (isLoading && suggestions.isEmpty) {
          return _buildShimmer();
        }

        if (suggestions.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          backgroundColor: FeedDesignTokens.cardBg(context),
          onRefresh: () async {
            controller.friendSearchHasReachedLimit = false;
            controller.peopleMayYouKnowList.value.clear();
            await controller.getPeopleMayYouKnow(skip: 0, limit: 20);
          },
          child: ListView(
            controller: controller.friendsScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 12),

              // Section Header
              Text(
                'People You May Know'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: FeedDesignTokens.textPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on your connections and activity'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
              const SizedBox(height: 16),

              // Suggestion Cards
              ...suggestions.asMap().entries.map((entry) {
                final index = entry.key;
                final people = entry.value;
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

              // Loading more indicator
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: PRIMARY_COLOR),
                  ),
                ),

              // End of list
              if (controller.friendSearchHasReachedLimit && suggestions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No more suggestions'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_disabled_outlined,
              size: 64, color: FeedDesignTokens.textSecondary(context)),
          const SizedBox(height: 12),
          Text(
            'No suggestions available'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: FeedDesignTokens.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new suggestions'.tr,
            style: TextStyle(
              fontSize: 14,
              color: FeedDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
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
                        width: 100,
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
