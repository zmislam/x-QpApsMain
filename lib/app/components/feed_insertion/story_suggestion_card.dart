import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../extension/string/string_image_path.dart';
import '../../models/merge_story.dart';
import '../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../modules/NAVIGATION_MENUS/home/views/story_view.dart';
import '../../repository/edgerank_repository.dart';
import '../../repository/story_repository.dart';

/// Horizontally scrollable story suggestion carousel for feed insertions.
/// Renders story thumbnails with a gradient overlay, avatar ring, and user name.
class StorySuggestionCard extends StatefulWidget {
  const StorySuggestionCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<StorySuggestionCard> createState() => _StorySuggestionCardState();
}

class _StorySuggestionCardState extends State<StorySuggestionCard> {
  late List<Map<String, dynamic>> suggestions;
  final StoryRepository _storyRepo = StoryRepository();
  bool _isNavigating = false;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    suggestions = List<Map<String, dynamic>>.from(
      (widget.data['suggestions'] ?? []).map(
        (e) => Map<String, dynamic>.from(e as Map),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: FeedDesignTokens.textSecondary(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.visibility_off_outlined,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Hide this suggestion'.tr,
                  style: TextStyle(color: FeedDesignTokens.textPrimary(context))),
              subtitle: Text('Stop seeing story suggestions here'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'story_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
            ListTile(
              leading: Icon(Icons.not_interested_outlined,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Not interested'.tr,
                  style: TextStyle(color: FeedDesignTokens.textPrimary(context))),
              subtitle: Text('See fewer suggestions like this'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'story_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Fetch the user's full stories by story_id, then open StoryView.
  Future<void> _openStory(Map<String, dynamic> item) async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    try {
      final storyId = (item['_id'] ?? '').toString();
      if (storyId.isEmpty) return;

      final storyModels = await _storyRepo.getUserStoryById(storyId: storyId);
      if (storyModels.isEmpty || !mounted) return;

      // Get HomeController for story callbacks
      final HomeController controller = Get.find<HomeController>();

      Get.to(
        () => StoryView(
          storyMergeList: storyModels,
          onStoryViewed: ({required storyId}) {
            controller.storyViewed(storyId);
          },
          onTapReaction: ({required reactionType, required storyId}) {
            controller.doReactionOnStory(storyId, reactionType);
          },
          onTapSendMessage: ({required comment, required storyId}) {},
          onTapDeleteStory: ({required storyId}) {
            controller.deleteStory(storyId);
          },
        ),
        arguments: 0,
      );
    } catch (e) {
      debugPrint('[StorySuggestionCard] Error opening story: $e');
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hidden || suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Card separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),

          // ─── Title ───
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FeedDesignTokens.cardPaddingH, 14,
              FeedDesignTokens.cardPaddingH, 10,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  size: 20,
                  color: FeedDesignTokens.brand(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Stories You Might Like'.tr,
                    style: TextStyle(
                      fontSize: FeedDesignTokens.nameSize,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                // Three-dot menu
                InkWell(
                  onTap: _showMoreOptions,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.more_horiz,
                      size: 22,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Horizontal story cards ───
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: FeedDesignTokens.cardPaddingH,
              ),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return _StoryCard(
                  item: item,
                  onTap: () => _openStory(item),
                );
              },
            ),
          ),

          const SizedBox(height: 4),

          // ─── Card separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.item, required this.onTap});

  final Map<String, dynamic> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final firstName = _capitalize(item['first_name'] ?? '');
    final shortName =
        firstName.length > 10 ? '${firstName.substring(0, 10)}…' : firstName;
    final profilePic = (item['profile_pic'] ?? '').toString();
    final thumbnail = (item['thumbnail'] ?? '').toString();

    // Background: prefer story thumbnail, fall back to profile pic
    final bgUrl = thumbnail.isNotEmpty
        ? thumbnail.formatedStoryUrl
        : profilePic.isNotEmpty
            ? profilePic.formatedProfileUrl
            : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FeedDesignTokens.inputBg(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ─── Background image ───
            if (bgUrl.isNotEmpty)
              Image.network(
                bgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: FeedDesignTokens.inputBg(context),
                  child: Icon(
                    Icons.auto_awesome,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
              ),

            // ─── Gradient overlay ───
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),

            // ─── Avatar ring (top-left) ───
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FeedDesignTokens.brand(context),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: profilePic.isNotEmpty
                      ? Image.network(
                          profilePic.formatedProfileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: 20,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 20,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                ),
              ),
            ),

            // ─── Name (bottom) ───
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                shortName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
