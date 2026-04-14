import 'package:flutter/material.dart';
import '../models/tipping_models.dart';

/// Transaction history list for tips.
class TipHistory extends StatelessWidget {
  final List<TipTransaction> transactions;
  final String type; // 'received' or 'sent'

  const TipHistory({
    super.key,
    required this.transactions,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type == 'received'
                    ? Icons.call_received
                    : Icons.call_made,
                size: 40,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 8),
              Text(
                type == 'received' ? 'No tips received' : 'No tips sent',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _transactionItem(transactions[i]),
    );
  }

  Widget _transactionItem(TipTransaction tx) {
    final isReceived = type == 'received';
    final name = isReceived ? tx.fromUserName : tx.toUserName;
    final avatar = isReceived ? tx.fromUserAvatar : tx.toUserAvatar;

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
          CircleAvatar(
            radius: 18,
            backgroundImage:
                avatar != null ? NetworkImage(avatar) : null,
            child: avatar == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 14))
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReceived ? 'From $name' : 'To $name',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (tx.message != null && tx.message!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '"${tx.message}"',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  '${tx.createdAt.day}/${tx.createdAt.month}/${tx.createdAt.year}',
                  style:
                      TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          Text(
            '${isReceived ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isReceived
                  ? Colors.green.shade700
                  : Colors.red.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
