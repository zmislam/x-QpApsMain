import 'package:flutter/material.dart';

class CreatorSpotlightCard extends StatelessWidget {
  final Map<String, dynamic> creator;
  const CreatorSpotlightCard({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    final name = creator['name'] ?? creator['username'] ?? 'Creator';
    final username = creator['username'] ?? '';
    final avatar = creator['avatar'] as String?;
    final followers = creator['followerCount'] ?? 0;
    final isVerified = creator['isVerified'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[800],
          backgroundImage: avatar != null ? NetworkImage(avatar) : null,
          child: avatar == null
              ? const Icon(Icons.person, color: Colors.white, size: 24)
              : null,
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Colors.blue, size: 16),
            ],
          ],
        ),
        subtitle: Text(
          '@$username · ${_formatCount(followers)} followers',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Follow',
            style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
