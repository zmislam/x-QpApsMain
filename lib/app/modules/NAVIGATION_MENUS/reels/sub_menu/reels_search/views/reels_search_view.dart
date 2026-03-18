import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../../../model/reels_creator_suggestion_model.dart';
import '../controllers/reels_search_controller.dart';

class ReelsSearchView extends GetView<ReelsSearchController> {
  const ReelsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Expanded(
              child: Obx(() {
                if (controller.isSearching.value) {
                  return _buildSearchResults(context);
                }
                return _buildHomeContent(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar: back + search field + filter icon ──────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                onChanged: controller.onSearchChanged,
                onSubmitted: controller.submitSearch,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search reels',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  suffixIcon: Obx(() => controller.query.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                          onPressed: controller.clearSearch,
                        )
                      : const SizedBox.shrink()),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ── Home content (not searching): watch history + recent + for you ──
  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Reels that you've watched" section
          _buildWatchHistorySection(),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Recent searches
          _buildRecentSearchesSection(),

          // "For you" creators section
          _buildForYouSection(),
        ],
      ),
    );
  }

  // ── Watch History row ───────────────────────────────────────────────
  Widget _buildWatchHistorySection() {
    return InkWell(
      onTap: () => Get.toNamed(Routes.WATCHED_REELS),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Reels that you've watched",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Text(
              'See all',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent searches section ─────────────────────────────────────────
  Widget _buildRecentSearchesSection() {
    return Obx(() {
      if (controller.recentSearches.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(
            'No recent searches',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.recentSearches.clear(),
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...controller.recentSearches.map((term) => ListTile(
                dense: true,
                leading: const Icon(Icons.history, color: Colors.grey, size: 22),
                title: Text(term, style: const TextStyle(fontSize: 15)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () => controller.removeRecentSearch(term),
                ),
                onTap: () => controller.tapSuggestion(term),
              )),
        ],
      );
    });
  }

  // ── "For you" creators section ──────────────────────────────────────
  Widget _buildForYouSection() {
    return Obx(() {
      if (controller.isLoadingSuggestions.value) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(
              color: PRIMARY_COLOR,
              strokeWidth: 2,
            ),
          ),
        );
      }

      if (controller.creatorSuggestions.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'For you',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: controller.refreshSuggestions,
                  child: Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...controller.creatorSuggestions.map(
            (creator) => _buildCreatorTile(creator),
          ),
        ],
      );
    });
  }

  Widget _buildCreatorTile(ReelsCreatorSuggestion creator) {
    final profileUrl = creator.profilePic != null && creator.profilePic!.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/profile_pics/${creator.profilePic}'
        : '';

    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: profileUrl.isNotEmpty
            ? CachedNetworkImageProvider(profileUrl)
            : null,
        child: profileUrl.isEmpty
            ? Icon(Icons.person, color: Colors.grey.shade400, size: 28)
            : null,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              creator.displayName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (creator.isVerified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified, size: 16, color: Colors.blue),
          ],
        ],
      ),
      subtitle: Text(
        creator.subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: () {
        if (creator.username != null) {
          ProfileNavigator.navigateToProfile(
            username: creator.username!,
            isFromReels: 'false',
          );
        }
      },
    );
  }

  // ── Search results ──────────────────────────────────────────────────
  Widget _buildSearchResults(BuildContext context) {
    if (controller.isLoadingResults.value) {
      return const Center(
        child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
      );
    }

    final results = controller.searchResults.value;

    if (results.isEmpty && controller.query.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: Colors.grey.shade300, size: 48),
            const SizedBox(height: 12),
            Text('No reels found for "${controller.query.value}"',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final reel = results[index];
        return _buildReelThumbnail(reel);
      },
    );
  }

  Widget _buildReelThumbnail(dynamic reel) {
    String imageUrl = '';
    if (reel.image != null && reel.image!.isNotEmpty) {
      imageUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/${reel.image!.first}';
    } else if (reel.video_thumbnail != null && reel.video_thumbnail!.isNotEmpty) {
      imageUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/${reel.video_thumbnail}';
    }

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.OTHER_USER_VIDEO, arguments: {'reelsID': reel.id}),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey[200]),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.play_circle_outline,
                    color: Colors.grey, size: 40),
              ),
            )
          else
            Container(
              color: Colors.grey[200],
              child: const Icon(Icons.play_circle_outline,
                  color: Colors.grey, size: 40),
            ),
          Positioned(
            bottom: 6,
            left: 6,
            child: Row(
              children: [
                const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                const SizedBox(width: 2),
                Text(
                  _formatCount(reel.view_count ?? 0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
