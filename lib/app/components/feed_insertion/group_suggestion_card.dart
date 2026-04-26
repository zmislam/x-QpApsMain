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
                color: FeedDesignTokens.textSecondary(context)
                    .withValues(alpha: 0.3),
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
                () async {
                  try {
                    await EdgeRankRepository()
                        .dismissInsertion(insertionType: 'group_suggestion');
                  } catch (_) {}
                }();
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
                () async {
                  try {
                    await EdgeRankRepository()
                        .dismissInsertion(insertionType: 'group_suggestion');
                  } catch (_) {}
                }();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(20);

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.fromLTRB(4, 2, 4, 4),
        decoration: _buildSectionDecoration(context, isDark, borderRadius),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(child: _buildSectionBackground(context)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopAccentBar(context),

                // ─── Title ───
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: FeedDesignTokens.brand(context)
                              .withValues(alpha: isDark ? 0.2 : 0.12),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          Icons.groups_outlined,
                          size: 18,
                          color: FeedDesignTokens.brand(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Suggested Groups'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.GROUPS),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Text(
                            'See All'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: FeedDesignTokens.brand(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: _showMoreOptions,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: FeedDesignTokens.inputBg(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Horizontal card list ───
                SizedBox(
                  height: 206,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildSectionDecoration(
    BuildContext context,
    bool isDark,
    BorderRadius borderRadius,
  ) {
    return BoxDecoration(
      borderRadius: borderRadius,
      border: Border.all(
        color:
            FeedDesignTokens.brand(context).withValues(alpha: isDark ? 0.25 : 0.14),
        width: 1,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          FeedDesignTokens.cardBg(context),
          FeedDesignTokens.cardBg(context),
          FeedDesignTokens.inputBg(context).withValues(alpha: isDark ? 0.34 : 0.72),
        ],
        stops: const [0, 0.6, 1],
      ),
      boxShadow: [
        BoxShadow(
          color: FeedDesignTokens.brand(context).withValues(alpha: isDark ? 0.12 : 0.07),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildTopAccentBar(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FeedDesignTokens.brand(context),
            const Color(0xFF2AB7CA),
            const Color(0xFF4DAA57),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionBackground(BuildContext context) {
    final accent = FeedDesignTokens.brand(context);
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -36,
            top: -44,
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -52,
            bottom: -58,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.04),
              ),
            ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final normalizedCoverPic = coverPic.trim();
    final hasCoverPic = normalizedCoverPic.isNotEmpty;
    final isJoinable = joinStatus == null;
    final statusLabel = (joinStatus ?? 'Join').tr;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 172,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: FeedDesignTokens.divider(context)
                .withValues(alpha: isDark ? 0.8 : 1),
            width: 0.8,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              FeedDesignTokens.cardBg(context),
              FeedDesignTokens.inputBg(context)
                  .withValues(alpha: isDark ? 0.26 : 0.52),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Cover image ───
            SizedBox(
              height: 90,
              child: hasCoverPic
                  ? Image.network(
                      normalizedCoverPic.formatedGroupProfileUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _buildCoverFallback(context),
                    )
                  : _buildCoverFallback(context),
            ),

            // ─── Name + member count ───
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildSubtitle(),
                    style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── Action row ───
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: isJoinable ? onJoin : null,
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: isJoinable
                              ? FeedDesignTokens.brand(context)
                              : FeedDesignTokens.inputBg(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isJoinable
                                ? Colors.transparent
                                : FeedDesignTokens.divider(context),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isJoinable
                                  ? Icons.group_add_rounded
                                  : joinStatus == 'Joined'
                                      ? Icons.check_rounded
                                      : Icons.hourglass_top_rounded,
                              size: 18,
                              color: isJoinable
                                  ? Colors.white
                                  : FeedDesignTokens.textSecondary(context),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isJoinable
                                    ? Colors.white
                                    : FeedDesignTokens.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: FeedDesignTokens.inputBg(context),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: FeedDesignTokens.divider(context),
                          width: 0.8,
                        ),
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

  Widget _buildCoverFallback(BuildContext context) {
    return Container(
      color: FeedDesignTokens.inputBg(context),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: FeedDesignTokens.cardBg(context),
            shape: BoxShape.circle,
          border: Border.all(
            color: FeedDesignTokens.divider(context),
            width: 1,
          ),
        ),
          child: Icon(
            Icons.groups_rounded,
            size: 24,
            color: FeedDesignTokens.textSecondary(context),
          ),
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
