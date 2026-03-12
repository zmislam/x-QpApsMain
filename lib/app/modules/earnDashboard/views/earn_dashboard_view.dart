import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/earn_dashboard_controller.dart';

class EarnDashboardView extends GetView<EarnDashboardController> {
    EarnDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   Color(0xFFF5F5F5),
      appBar: AppBar(
        title:   Text('Earn Dashboard'.tr),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return   Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding:   EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Post Earning'),
                SizedBox(height: 12),
              buildPostEarningGrid(),
                SizedBox(height: 24),
              buildSectionTitle('Activity Earning'),
                SizedBox(height: 12),
              buildActivityEarningGrid(),
                SizedBox(height: 24),
              buildSectionTitle('Campaign Earning'),
                SizedBox(height: 12),
              buildCampaignEarningGrid(),
                SizedBox(height: 20),
              buildSectionTitle('Earning Profile Overview'),
                SizedBox(height: 12),
              buildEarningProfileView(),
                SizedBox(height: 24),
              buildTop3SummarySections(),
            ],
          ),
        );
      }),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style:   TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget buildPostEarningGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return   Center(child: CircularProgressIndicator());
      }

      if (controller.earningPoints.value == null) {
        return   Center(child: Text('No earning data available'.tr));
      }

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics:   NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          buildEarningCard(
            'Total Reaction Points',
            controller.earningPoints.value?.myActivityPostReactionPointCount
                    ?.points ??
                0.0,
            Colors.green.shade100,
            Colors.green,
          ),
          buildEarningCard(
            'Total Comment Points',
            controller.earningPoints.value?.myActivityPostCommentPointCount
                    ?.points ??
                0.0,
            Colors.blue.shade100,
            Colors.blue,
          ),
          buildEarningCard(
            'Total Reels Points',
            controller.earningPoints.value?.myActivityReelsViewPoints?.points ??
                0.0,
            Colors.purple.shade100,
            Colors.purple,
          ),
          buildEarningCard(
            'Total Share Points',
            controller.earningPoints.value?.myActivityPostSharePointCount
                    ?.points ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
        ],
      );
    });
  }

  Widget buildActivityEarningGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return   Center(child: CircularProgressIndicator());
      }

      if (controller.earningPoints.value == null) {
        return   Center(child: Text('No activity data available'.tr));
      }

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics:   NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          buildEarningCard(
            'Total Reaction Points',
            controller.earningPoints.value?.myActivityPostReactionPointCount
                    ?.points ??
                0.0,
            Colors.green.shade100,
            Colors.green,
          ),
          buildEarningCard(
            'Total Comment Points',
            controller.earningPoints.value?.myActivityPostCommentPointCount
                    ?.points ??
                0.0,
            Colors.blue.shade100,
            Colors.blue,
          ),
          buildEarningCard(
            'Total Reels Points',
            controller.earningPoints.value?.myActivityReelsViewPoints?.points ??
                0.0,
            Colors.purple.shade100,
            Colors.purple,
          ),
          buildEarningCard(
            'Total Share Points',
            controller.earningPoints.value?.myActivityPostSharePointCount
                    ?.points ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
        ],
      );
    });
  }

  Widget buildCampaignEarningGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return   Center(child: CircularProgressIndicator());
      }

      if (controller.earningPoints.value == null) {
        return   Center(child: Text('No campaign data available'.tr));
      }

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics:   NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          buildEarningCard(
            'Campaign Click\nPoints',
            controller
                    .earningPoints.value?.campaignPoints?.campaignClickPoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Campaign Impression\nPoints',
            controller.earningPoints.value?.campaignPoints
                    ?.campaignImpressionPoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Campaign Reached\nPoints',
            controller.earningPoints.value?.campaignPoints
                    ?.campaignReachedPoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Campaign Reaction\nPoints',
            controller.earningPoints.value?.campaignPoints
                    ?.campaignReactionPoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Campaign Comment\nPoints',
            controller.earningPoints.value?.campaignPoints
                    ?.campaignCommentPoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Campaign Share\nPoints',
            controller
                    .earningPoints.value?.campaignPoints?.campaignSharePoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Campaign Watch 10 Sec\nPoints',
            controller.earningPoints.value?.campaignPoints
                    ?.campaignWatch10SecPoint ??
                0.0,
            Colors.orange.shade100,
            Colors.orange,
          ),
          buildEarningCard(
            'Total Points',
            controller.earningPoints.value?.totalPoints ?? 0.0,
            Colors.yellow.shade100,
            Colors.amber.shade700,
          ),
          buildEarningCard(
            'Current Points',
            controller.earningPoints.value?.currentPoints ?? 0.0,
            Colors.teal.shade100,
            Colors.teal,
          ),
          buildEarningCard(
            'Withdraw Points',
            controller.earningPoints.value?.withdrawPoints?.points ?? 0.0,
            Colors.pink.shade100,
            Colors.pink,
          ),
        ],
      );
    });
  }

  Widget buildEarningCard(
    String title,
    double points,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset:   Offset(0, 2),
          ),
        ],
      ),
      padding:   EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style:   TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                points.toStringAsFixed(8),
                style:   TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Container(
          //   padding:   EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     color: bgColor,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Icon(
          //     Icons.trending_up,
          //     color: iconColor,
          //     size: 20,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildEarningProfileOverview({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconBgColor = const Color(0xFF0D7377),
    Color iconColor = Colors.white,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin:   EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding:   EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with background circle
            Container(
              padding:   EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
              SizedBox(width: 12),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:   TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                    SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEarningProfileView(){
    return Obx(() {
      if (controller.isLoading.value) {
        return   Center(child: CircularProgressIndicator());
      }

      final data = controller.earningSummary.value;

      if (data == null) {
        return   Center(child: Text('No profile data available'.tr));
      }

      return GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        physics:   NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        childAspectRatio: 4,
        children: [
          buildEarningProfileOverview(
            icon: Icons.post_add_rounded,
            title: 'Post Reacted'.tr,
            subtitle: '${(data.totalPostReactionCount?.isNotEmpty ?? false) ? data.totalPostReactionCount!.first.count : 0}'.tr,
            iconBgColor: Colors.teal.shade600,
          ),
          buildEarningProfileOverview(
            icon: Icons.comment_rounded,
            title: 'Post Commented'.tr,
            subtitle: '${(data.totalPostCommentCount?.isNotEmpty ?? false) ? data.totalPostCommentCount!.first.count : 0}'.tr,
            iconBgColor: Colors.blue.shade600,
          ),
          buildEarningProfileOverview(
            icon: Icons.ios_share_rounded,
            title: 'Post Shared'.tr,
            subtitle: '${(data.totalSharePost?.isNotEmpty ?? false) ? data.totalSharePost!.first.count : 0}'.tr,
            iconBgColor: Colors.orange.shade600,
          ),
        ],
      );
    });
  }

  Widget buildTop3SummarySections() {
    final data = controller.earningTop3Summary.value;

    return Column(
      children: [
        // Top Reacted Post Section
        buildTopSection(
          title: 'Top Reacted Post'.tr,
          items: data?.top3ReactedPost
                  ?.map((post) => TopItem(
                        title: post.description?.isNotEmpty == true
                            ? post.description!
                            : 'No Description',
                        reactionCount: post.reactions?.count ?? 0,
                        commentCount: post.comments?.count ?? 0,
                        shareCount: 0,
                      ))
                  .toList() ??
              [],
        ),

          SizedBox(height: 24),

        // Top Commented Post Section
        buildTopSection(
          title: 'Top Commented Post'.tr,
          items: data?.top3CommentedPost
                  ?.map((post) => TopItem(
                        title: post.description?.isNotEmpty == true
                            ? post.description!
                            : 'No Description',
                        reactionCount: post.reactions?.count ?? 0,
                        commentCount: post.comments?.count ?? 0,
                        shareCount: 0,
                      ))
                  .toList() ??
              [],
        ),

          SizedBox(height: 24),

        // Top Shared Post Section
        buildTopSection(
          title: 'Top Shared Post'.tr,
          items: data?.top3SharedPost
                  ?.map((sharedPost) => TopItem(
                        title: sharedPost.post?.description?.isNotEmpty == true
                            ? sharedPost.post!.description!
                            : 'No Description',
                        reactionCount: sharedPost.post?.reactions?.count ?? 0,
                        commentCount: sharedPost.post?.comments?.count ?? 0,
                        shareCount: sharedPost.count ?? 0,
                      ))
                  .toList() ??
              [],
        ),

          SizedBox(height: 24),

        // Top Reels View Section (if you want to include it)
        if (data?.top3ReelsView?.isNotEmpty == true) ...[
          buildTopReelsSection(
            title: 'Top Reels View'.tr,
            items: data!.top3ReelsView!
                .map((reelsView) => TopReelsItem(
                      title: reelsView.reels?.description?.isNotEmpty == true
                          ? reelsView.reels!.description!
                          : 'No Description',
                      viewCount: reelsView.reels?.views?.count ??
                          reelsView.reels?.viewCount ??
                          0,
                    ))
                .toList(),
          ),
            SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget buildTopSection({
    required String title,
    required List<TopItem> items,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset:   Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding:   EdgeInsets.all(16.0),
            child: Text(
              title,
              style:   TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Divider
            Divider(height: 1, thickness: 1),

          // Items List
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                // Item
                Padding(
                  padding:   EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Number indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: getRankColor(index),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${index + 1}'.tr,
                            style:   TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                        SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              item.title,
                              style:   TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                              SizedBox(height: 4),

                            // Stats
                            Text(
                              title.contains('Shared')
                                  ? 'Shared ${item.shareCount} | Reacted ${item.reactionCount} | Commented ${item.commentCount}'
                                  : 'Reacted ${item.reactionCount} | Commented ${item.commentCount}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider between items (except last)
                if (index < items.length - 1)
                    Divider(height: 1, thickness: 1, indent: 16),
              ],
            );
          }),

          // See Full Details Button
          if (items.isNotEmpty) ...[
              Divider(height: 1, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // Handle see full details
                  // You can navigate to a detailed page here
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding:   EdgeInsets.all(16),
                  shape:   RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                child:   Text('See Full Details'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildTopReelsSection({
    required String title,
    required List<TopReelsItem> items,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset:   Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding:   EdgeInsets.all(16.0),
            child: Text(
              title,
              style:   TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Divider
            Divider(height: 1, thickness: 1),

          // Items List
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                // Item
                Padding(
                  padding:   EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Number indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: getRankColor(index),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${index + 1}'.tr,
                            style:   TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                        SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              item.title,
                              style:   TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                              SizedBox(height: 4),

                            // Stats
                            Text('Views ${item.viewCount}'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider between items (except last)
                if (index < items.length - 1)
                    Divider(height: 1, thickness: 1, indent: 16),
              ],
            );
          }),

          // See Full Details Button
          if (items.isNotEmpty) ...[
              Divider(height: 1, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // Handle see full details
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding:   EdgeInsets.all(16),
                  shape:   RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                child:   Text('See Full Details'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color getRankColor(int index) {
    switch (index) {
      case 0:
        return   Color(0xFFFFD700); // Gold for 1st
      case 1:
        return   Color(0xFFC0C0C0); // Silver for 2nd
      case 2:
        return   Color(0xFFCD7F32); // Bronze for 3rd
      default:
        return Colors.grey; // Grey for others
    }
  }
}

// Helper classes for the items
class TopItem {
  final String title;
  final int reactionCount;
  final int commentCount;
  final int shareCount;

  TopItem({
    required this.title,
    required this.reactionCount,
    required this.commentCount,
    required this.shareCount,
  });
}

class TopReelsItem {
  final String title;
  final int viewCount;

  TopReelsItem({
    required this.title,
    required this.viewCount,
  });
}

// Your existing helper methods (buildSectionTitle, buildEarningCard, etc.) remain the same
Widget buildSectionTitle(String title) {
  return Text(
    title,
    style:   TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}

Widget buildEarningCard(
  String title,
  double points,
  Color bgColor,
  Color iconColor,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset:   Offset(0, 2),
        ),
      ],
    ),
    padding:   EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style:   TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              points.toStringAsFixed(8),
              style:   TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
