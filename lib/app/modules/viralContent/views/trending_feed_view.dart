import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/viral_content_controller.dart';
import '../widgets/trending_card.dart';
import '../widgets/viral_score_breakdown.dart';

class TrendingFeedView extends GetView<ViralContentController> {
  const TrendingFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: const Text('Trending',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => PopupMenuButton<String>(
                icon: const Icon(Icons.sort, color: Colors.black54, size: 20),
                onSelected: controller.changeSortBy,
                itemBuilder: (_) => [
                  _sortItem('score', 'Viral Score'),
                  _sortItem('views', 'Most Views'),
                  _sortItem('shares', 'Most Shares'),
                ],
                initialValue: controller.sortBy.value,
              )),
        ],
      ),
      body: Obx(() {
        if (!controller.viralEnabled) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('Trending is not available',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
            ),
          );
        }

        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: PRIMARY_COLOR));
        }

        final posts = controller.trendingPosts;
        if (posts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.whatshot_outlined,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('No trending content right now',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500)),
                  const SizedBox(height: 4),
                  Text('Check back later!',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          onRefresh: () => controller.refreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (_, i) {
              final post = posts[i];
              return TrendingCard(
                post: post,
                onTap: () {
                  // Navigate to post detail — can be extended
                },
                onBadgeTap: () async {
                  final breakdown =
                      await controller.getScoreBreakdown(post.postId);
                  if (breakdown != null && context.mounted) {
                    ViralScoreBreakdownWidget.show(context, breakdown);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }

  PopupMenuEntry<String> _sortItem(String value, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
