// =============================================================================
// Search Group Card — Matches Facebook mobile search Groups design
// =============================================================================
// Layout: [Rounded rect cover]  Group Name · Join (blue)
//                               Privacy · X members · activity
//                               [avatar] 1 friend is a member
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../config/constants/api_constant.dart';
import '../../models/search_result_models.dart';

class SearchGroupCard extends StatelessWidget {
  final SearchGroupResult group;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  const SearchGroupCard({
    super.key,
    required this.group,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    final actionText = group.isMember ? 'Joined' : 'Join';
    final actionColor = group.isMember ? Colors.grey.shade600 : primaryColor;

    // Subtitle parts
    final subtitleParts = <String>[];
    subtitleParts.add(group.privacy == 'private' ? 'Private' : 'Public');
    if (group.membersCount > 0) {
      subtitleParts.add('${_formatCount(group.membersCount)} members');
    }
    if (group.postsCount > 0) {
      subtitleParts.add('${_formatCount(group.postsCount)} posts');
    }

    final hasCover = group.coverImage != null && group.coverImage!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image (rounded rectangle, not circle — per Facebook design)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 60,
                height: 60,
                child: hasCover
                    ? Image.network(
                        group.coverImage!.startsWith('http')
                            ? group.coverImage!
                            : '${ApiConstant.SERVER_IP_PORT}/${group.coverImage}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderCover(isDark),
                      )
                    : _placeholderCover(isDark),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + action
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          group.groupName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                      ),
                      GestureDetector(
                        onTap: group.isMember ? null : onActionTap,
                        child: Text(
                          actionText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: actionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Privacy · members · posts
                  Text(
                    subtitleParts.join(' · '),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderCover(bool isDark) {
    return Container(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      child: const Icon(Icons.group, size: 28, color: Colors.grey),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
