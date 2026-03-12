import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../extension/string/string_image_path.dart';
import '../../repository/edgerank_repository.dart';
import '../../repository/user_relationships_repository.dart';
import '../../routes/app_pages.dart';
import '../../routes/profile_navigator.dart';

/// Facebook-style horizontally scrollable friend suggestion carousel.
class FriendSuggestionCard extends StatefulWidget {
  const FriendSuggestionCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<FriendSuggestionCard> createState() => _FriendSuggestionCardState();
}

class _FriendSuggestionCardState extends State<FriendSuggestionCard> {
  late List<Map<String, dynamic>> suggestions;
  final UserRelationshipRepository _repo = UserRelationshipRepository();
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    suggestions = List<Map<String, dynamic>>.from(
      (widget.data['suggestions'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
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
              subtitle: Text('Stop seeing friend suggestions here'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'friend_suggestion')
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
                    .dismissInsertion(insertionType: 'friend_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddFriend(int index) async {
    final item = suggestions[index];
    final userId = item['_id'] ?? item['id'] ?? '';
    if (userId.isEmpty) return;

    final apiResponse = await _repo.sendFriendRequestToUser(userId: userId);
    if (apiResponse.isSuccessful) {
      setState(() {
        suggestions.removeAt(index);
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
              FeedDesignTokens.cardPaddingH, 14, FeedDesignTokens.cardPaddingH, 10,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 20,
                  color: FeedDesignTokens.brand(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'People You May Know'.tr,
                    style: TextStyle(
                      fontSize: FeedDesignTokens.nameSize,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.FRIEND_SUGGESTION),
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
                // Support both data shapes: new API (name/profilePic) and raw model (first_name/profile_pic)
                final name = item['name'] ?? '${item['first_name'] ?? ''} ${item['last_name'] ?? ''}'.trim();
                final username = item['username'] ?? '';
                final profilePic = item['profilePic'] ?? item['profile_pic'] ?? '';
                final mutualFriends = item['mutualFriends'] ?? item['mutual_friends_count'] ?? 0;

                return _SuggestionCard(
                  name: name,
                  username: username,
                  profilePic: profilePic,
                  mutualFriends: mutualFriends is int ? mutualFriends : 0,
                  onTap: () {
                    if (username.isNotEmpty) {
                      ProfileNavigator.navigateToProfile(username: username);
                    }
                  },
                  onAdd: () => _handleAddFriend(index),
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
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.name,
    required this.username,
    required this.profilePic,
    required this.mutualFriends,
    required this.onTap,
    required this.onAdd,
    required this.onDismiss,
  });

  final String name;
  final String username;
  final String profilePic;
  final int mutualFriends;
  final VoidCallback onTap;
  final VoidCallback onAdd;
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
          // ─── Avatar ───
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 120,
              color: FeedDesignTokens.inputBg(context),
              child: profilePic.isNotEmpty
                  ? Image.network(
                      profilePic.formatedProfileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.person,
                        size: 48,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 48,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
            ),
          ),

          // ─── Name + Mutual ───
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
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
                  '$mutualFriends ${'mutual friends'.tr}',
                  style: TextStyle(
                    fontSize: 11,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          // ─── Add Friend Button ───
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FeedDesignTokens.brand(context),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: Text(
                  'Add Friend'.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
