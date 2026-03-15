import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../extension/string/string_image_path.dart';
import '../../repository/edgerank_repository.dart';
import '../../routes/app_pages.dart';
import '../../services/api_communication.dart';

/// Horizontally scrollable group suggestion carousel for feed insertions.
class GroupSuggestionCard extends StatefulWidget {
  const GroupSuggestionCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<GroupSuggestionCard> createState() => _GroupSuggestionCardState();
}

class _GroupSuggestionCardState extends State<GroupSuggestionCard> {
  late List<Map<String, dynamic>> suggestions;
  final ApiCommunication _api = ApiCommunication();
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
              subtitle: Text('Stop seeing group suggestions here'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'group_suggestion')
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
                    .dismissInsertion(insertionType: 'group_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleJoin(int index) async {
    final item = suggestions[index];
    final groupId = item['_id'] ?? '';
    if (groupId.isEmpty) return;

    final response = await _api.doPostRequest(
      apiEndPoint: 'groups/send-group-invitation-join-request',
      requestData: {
        'group_id': groupId,
        'type': 'join',
        'user_id_arr': [],
      },
    );

    if (response.isSuccessful && mounted) {
      final privacy = item['group_privacy'] ?? 'public';
      setState(() {
        suggestions[index] = {
          ...item,
          '_joinStatus': privacy == 'private' ? 'Requested' : 'Joined',
        };
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
                  Icons.groups_outlined,
                  size: 20,
                  color: FeedDesignTokens.brand(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suggested Groups'.tr,
                    style: TextStyle(
                      fontSize: FeedDesignTokens.nameSize,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.GROUPS),
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
                final groupName = _capitalize(item['group_name'] ?? 'Group');
                final coverPic = item['group_cover_pic'] ?? '';
                final memberCount = item['member_count'] ?? 0;
                final friendsInGroup = item['friends_in_group'] ?? 0;
                final joinStatus = item['_joinStatus'] as String?;

                return _GroupCard(
                  groupName: groupName,
                  coverPic: coverPic,
                  memberCount: memberCount is int ? memberCount : 0,
                  friendsInGroup: friendsInGroup is int ? friendsInGroup : 0,
                  joinStatus: joinStatus,
                  onTap: () {
                    final groupId = item['_id'] ?? '';
                    if (groupId.isNotEmpty) {
                      Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                        'id': groupId,
                        'group_type': '',
                      });
                    }
                  },
                  onJoin: () => _handleJoin(index),
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

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.groupName,
    required this.coverPic,
    required this.memberCount,
    required this.friendsInGroup,
    required this.joinStatus,
    required this.onTap,
    required this.onJoin,
    required this.onDismiss,
  });

  final String groupName;
  final String coverPic;
  final int memberCount;
  final int friendsInGroup;
  final String? joinStatus;
  final VoidCallback onTap;
  final VoidCallback onJoin;
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
                        coverPic.formatedGroupProfileUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.groups,
                          size: 40,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      )
                    : Icon(
                        Icons.groups,
                        size: 40,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
              ),
            ),

            // ─── Name + member count ───
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
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

            // ─── Action Icons Row (Join + Remove) ───
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Row(
                children: [
                  // Join icon button
                  Expanded(
                    child: GestureDetector(
                      onTap: joinStatus == null ? onJoin : null,
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: joinStatus == null
                              ? FeedDesignTokens.brand(context)
                              : FeedDesignTokens.inputBg(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          joinStatus == null
                              ? Icons.group_add_rounded
                              : joinStatus == 'Joined'
                                  ? Icons.check_rounded
                                  : Icons.hourglass_top_rounded,
                          size: 20,
                          color: joinStatus == null
                              ? Colors.white
                              : FeedDesignTokens.textSecondary(context),
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
    parts.add('$memberCount member${memberCount != 1 ? 's' : ''}');
    if (friendsInGroup > 0) {
      parts.add('$friendsInGroup friend${friendsInGroup > 1 ? 's' : ''}');
    }
    return parts.join(' · ');
  }
}
