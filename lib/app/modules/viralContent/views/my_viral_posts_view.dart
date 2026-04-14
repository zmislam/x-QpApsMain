import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/viral_content_controller.dart';
import '../models/viral_content_models.dart';
import '../widgets/viral_badge.dart';

class MyViralPostsView extends GetView<ViralContentController> {
  const MyViralPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: const Text('My Viral Posts',
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: PRIMARY_COLOR));
        }

        final data = controller.myViralPosts.value;
        if (data == null ||
            (data.active.isEmpty && data.historical.isEmpty)) {
          return _emptyState();
        }

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          onRefresh: () => controller.refreshData(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (data.active.isNotEmpty) ...[
                _sectionHeader('Active Viral Posts'),
                const SizedBox(height: 8),
                ...data.active.map((p) => _viralPostItem(p, active: true)),
              ],
              if (data.historical.isNotEmpty) ...[
                const SizedBox(height: 20),
                _sectionHeader('Past Viral Posts'),
                const SizedBox(height: 8),
                ...data.historical.map((p) => _viralPostItem(p, active: false)),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No viral posts yet',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(
              'Create engaging content to go viral!\n'
              '• Post original, high-quality content\n'
              '• Engage with your audience\n'
              '• Share at peak hours',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _viralPostItem(ViralPostInfo post, {required bool active}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: active
            ? Border.all(color: Colors.orange.shade100, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: badge + score
          Row(
            children: [
              ViralBadge(
                tierKey: post.viralTierKey,
                label: post.label,
                multiplier: post.multiplier,
              ),
              const SizedBox(width: 8),
              Text(
                'Score: ${post.viralScore.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              if (post.bonusEarned > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+\$${post.bonusEarned.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Metrics
          Row(
            children: [
              _metric(Icons.visibility_outlined, _fmt(post.metrics.views)),
              const SizedBox(width: 12),
              _metric(Icons.share_outlined, _fmt(post.metrics.shares)),
              const SizedBox(width: 12),
              _metric(
                  Icons.favorite_outline, _fmt(post.metrics.reactions)),
              const SizedBox(width: 12),
              _metric(Icons.chat_bubble_outline,
                  _fmt(post.metrics.comments)),
            ],
          ),
          if (post.detectedAt != null || post.expiresAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (post.detectedAt != null)
                  Text(
                    'Detected: ${_formatDate(post.detectedAt!)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                const Spacer(),
                if (post.expiresAt != null && active)
                  Text(
                    'Expires: ${_formatDate(post.expiresAt!)}',
                    style:
                        TextStyle(fontSize: 10, color: Colors.orange.shade500),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(value,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
