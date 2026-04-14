import 'package:flutter/material.dart';
import '../models/tipping_models.dart';
import 'supporter_badge.dart';

/// Ranked list of top supporters.
class TopSupporters extends StatelessWidget {
  final List<TopSupporter> supporters;

  const TopSupporters({super.key, required this.supporters});

  @override
  Widget build(BuildContext context) {
    if (supporters.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline,
                  size: 40, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Text('No supporters yet',
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: supporters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final s = supporters[i];
        return _supporterItem(s, i + 1);
      },
    );
  }

  Widget _supporterItem(TopSupporter supporter, int rank) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: rank <= 3 ? Colors.amber.shade700 : Colors.grey.shade600,
              ),
            ),
          ),
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: supporter.avatar != null
                ? NetworkImage(supporter.avatar!)
                : null,
            child: supporter.avatar == null
                ? Text(
                    supporter.userName.isNotEmpty
                        ? supporter.userName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 14))
                : null,
          ),
          const SizedBox(width: 10),
          // Name + badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        supporter.userName,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (supporter.badgeLevel != null) ...[
                      const SizedBox(width: 6),
                      SupporterBadge(level: supporter.badgeLevel!),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${supporter.tipCount} tips',
                  style:
                      TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            '\$${supporter.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
