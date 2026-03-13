import 'package:flutter/material.dart';

import '../utils/reaction_stack.dart';

/// Facebook-style reaction user list tile — circular avatar with reaction badge.
/// Redesigned 2026-03-14.
class ReactionListTile extends StatelessWidget {
  final String name;
  final String profilePicUrl;
  final String reaction;
  final VoidCallback? onTapViewProfile;

  const ReactionListTile(
      {super.key,
      required this.name,
      required this.profilePicUrl,
      required this.onTapViewProfile,
      required this.reaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTapViewProfile,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ReactionStack(
              profileImageLink: profilePicUrl,
              reactionImageLink: reaction,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
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
}
