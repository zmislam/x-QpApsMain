// =============================================================================
// Search Page Card — Matches Facebook mobile search Pages tab design
// =============================================================================
// Layout: [Circle Avatar or Letter]  Page Name · Follow/Like (blue)
//                                    Category · X followers
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../config/constants/api_constant.dart';
import '../../models/search_result_models.dart';

class SearchPageCard extends StatelessWidget {
  final SearchPageResult page;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  const SearchPageCard({
    super.key,
    required this.page,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    final hasAvatar = page.avatarUrl != null && page.avatarUrl!.isNotEmpty;

    // Build subtitle parts
    final subtitleParts = <String>[];
    if (page.category != null && page.category!.isNotEmpty) {
      subtitleParts.add(page.category!);
    }
    if (page.locationCity != null && page.locationCity!.isNotEmpty) {
      subtitleParts.add(page.locationCity!);
    }
    if (page.followersCount > 0) {
      subtitleParts.add('${_formatCount(page.followersCount)} followers');
    }

    final actionText = page.isFollowing ? 'Following' : 'Follow';
    final actionColor = page.isFollowing ? Colors.grey.shade600 : primaryColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar or letter avatar
            hasAvatar
                ? CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      page.avatarUrl!.startsWith('http')
                          ? page.avatarUrl!
                          : '${ApiConstant.SERVER_IP_PORT}/${page.avatarUrl}',
                    ),
                  )
                : CircleAvatar(
                    radius: 28,
                    backgroundColor: _letterAvatarColor(page.pageName),
                    child: Text(
                      page.pageName.isNotEmpty ? page.pageName[0].toUpperCase() : 'P',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(width: 12),

            // Name + action + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          page.pageName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (page.verified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, size: 16, color: primaryColor),
                      ],
                      Text(
                        ' · ',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                      ),
                      GestureDetector(
                        onTap: onActionTap,
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
                  if (subtitleParts.isNotEmpty) ...[
                    const SizedBox(height: 2),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  Color _letterAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    final index = name.isNotEmpty ? name.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }
}
