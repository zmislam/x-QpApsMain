import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../extension/string/string_image_path.dart';
import '../../repository/edgerank_repository.dart';
import '../../repository/page_repository.dart';
import '../../routes/app_pages.dart';

/// Horizontally scrollable page suggestion carousel for feed insertions.
class PageSuggestionCard extends StatefulWidget {
  const PageSuggestionCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<PageSuggestionCard> createState() => _PageSuggestionCardState();
}

class _PageSuggestionCardState extends State<PageSuggestionCard> {
  late List<Map<String, dynamic>> suggestions;
  final PageRepository _pageRepo = PageRepository();
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
              subtitle: Text('Stop seeing page suggestions here'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'page_suggestion')
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
                    .dismissInsertion(insertionType: 'page_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleFollow(int index) async {
    final item = suggestions[index];
    final pageId = item['_id'] ?? '';
    if (pageId.isEmpty) return;

    final response = await _pageRepo.followPage(pageId);
    if (response.isSuccessful && mounted) {
      setState(() {
        suggestions[index] = {...item, '_followed': true};
      });
    }
  }

  void _handleDismiss(int index) {
    setState(() {
      suggestions.removeAt(index);
    });
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
                  Icons.article_outlined,
                  size: 20,
                  color: FeedDesignTokens.brand(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suggested Pages'.tr,
                    style: TextStyle(
                      fontSize: FeedDesignTokens.nameSize,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.PAGES),
                  child: Text(
                    'See All'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.brand(context),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
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

          // ─── Horizontal card list ───
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: FeedDesignTokens.cardPaddingH,
              ),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                final pageName = _capitalize(item['page_name'] ?? 'Page');
                final coverPic = item['cover_pic'] ?? item['profile_pic'] ?? '';
                final category = item['category'] is List
                    ? (item['category'] as List).isNotEmpty
                        ? item['category'][0].toString()
                        : ''
                    : (item['category'] ?? '').toString();
                final followerCount = item['likes_count'] ?? 0;
                final pageUserName = item['page_user_name'] ?? item['_id'] ?? '';
                final followed = item['_followed'] == true;

                return _PageCard(
                  pageName: pageName,
                  coverPic: coverPic,
                  category: category,
                  followerCount: followerCount is int ? followerCount : 0,
                  followed: followed,
                  onTap: () {
                    if (pageUserName.isNotEmpty) {
                      Get.toNamed(Routes.PAGE_PROFILE, arguments: pageUserName);
                    }
                  },
                  onFollow: () => _handleFollow(index),
                  onDismiss: () => _handleDismiss(index),
                );
              },
            ),
          ),

          // ─── Card separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _PageCard extends StatelessWidget {
  const _PageCard({
    required this.pageName,
    required this.coverPic,
    required this.category,
    required this.followerCount,
    required this.followed,
    required this.onTap,
    required this.onFollow,
    required this.onDismiss,
  });

  final String pageName;
  final String coverPic;
  final String category;
  final int followerCount;
  final bool followed;
  final VoidCallback onTap;
  final VoidCallback onFollow;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: FeedDesignTokens.cardBg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FeedDesignTokens.divider(context),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Cover image ───
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 100,
                color: FeedDesignTokens.inputBg(context),
                child: coverPic.isNotEmpty
                    ? Image.network(
                        coverPic.formatedPageProfileUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.article,
                          size: 40,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      )
                    : Icon(
                        Icons.article,
                        size: 40,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
              ),
            ),

            // ─── Name + category + followers ───
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pageName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _buildSubtitle(),
                    style: TextStyle(
                      fontSize: 11,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── Action Icons Row (Follow + Remove) ───
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Row(
                children: [
                  // Follow icon button
                  Expanded(
                    child: GestureDetector(
                      onTap: followed ? null : onFollow,
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: followed
                              ? FeedDesignTokens.inputBg(context)
                              : FeedDesignTokens.brand(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          followed ? Icons.check_rounded : Icons.add_rounded,
                          size: 20,
                          color: followed
                              ? FeedDesignTokens.textSecondary(context)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Remove icon button
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: FeedDesignTokens.inputBg(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
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

  String _buildSubtitle() {
    final parts = <String>[];
    if (category.isNotEmpty) parts.add(category);
    if (followerCount > 0) {
      parts.add('$followerCount follower${followerCount != 1 ? 's' : ''}');
    }
    return parts.join(' · ');
  }
}
