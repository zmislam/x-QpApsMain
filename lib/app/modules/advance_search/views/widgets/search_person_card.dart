// =============================================================================
// Search Person Card — Matches Facebook mobile search design
// =============================================================================
// Layout: [Circle Avatar]  Name · Action (blue)
//                          Optional subtitle (bio / city / mutual friends)
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../config/constants/api_constant.dart';
import '../../models/search_result_models.dart';

class SearchPersonCard extends StatelessWidget {
  final SearchPersonResult person;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  const SearchPersonCard({
    super.key,
    required this.person,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    // Action text based on friend status
    String actionText;
    Color actionColor;
    switch (person.friendStatus) {
      case 'friend':
        actionText = 'Friends';
        actionColor = Colors.grey;
        break;
      case 'request_sent':
        actionText = 'Cancel Request';
        actionColor = Colors.grey.shade600;
        break;
      case 'request_received':
        actionText = 'Accept';
        actionColor = primaryColor;
        break;
      default:
        actionText = 'Add friend';
        actionColor = primaryColor;
    }

    // Subtitle construction
    String? subtitle;
    if (person.mutualFriendsCount > 0) {
      subtitle = '${person.mutualFriendsCount} mutual friend${person.mutualFriendsCount > 1 ? 's' : ''}';
    } else if (person.presentTown != null && person.presentTown!.isNotEmpty) {
      subtitle = 'Lives in ${person.presentTown}';
    } else if (person.bio != null && person.bio!.isNotEmpty) {
      subtitle = person.bio!.length > 60
          ? '${person.bio!.substring(0, 60)}...'
          : person.bio;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              backgroundImage: person.profilePic != null && person.profilePic!.isNotEmpty
                  ? NetworkImage(
                      person.profilePic!.startsWith('http')
                          ? person.profilePic!
                          : '${ApiConstant.SERVER_IP_PORT}/${person.profilePic}',
                    )
                  : null,
              child: person.profilePic == null || person.profilePic!.isEmpty
                  ? Icon(Icons.person, size: 28, color: Colors.grey.shade500)
                  : null,
            ),
            const SizedBox(width: 12),

            // Name & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          person.fullName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (person.verified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, size: 16, color: primaryColor),
                      ],
                      // Action inline with dot separator
                      if (person.friendStatus != 'friend') ...[
                        Text(
                          ' · ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
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
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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
}
