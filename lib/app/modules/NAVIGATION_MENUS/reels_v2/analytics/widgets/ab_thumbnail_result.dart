import 'package:flutter/material.dart';

class AbThumbnailResult extends StatelessWidget {
  final String? thumbnailAUrl;
  final String? thumbnailBUrl;
  final int thumbnailAImpressions;
  final int thumbnailBImpressions;
  final double thumbnailACtr;
  final double thumbnailBCtr;

  const AbThumbnailResult({
    super.key,
    this.thumbnailAUrl,
    this.thumbnailBUrl,
    this.thumbnailAImpressions = 0,
    this.thumbnailBImpressions = 0,
    this.thumbnailACtr = 0.0,
    this.thumbnailBCtr = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final aWins = thumbnailACtr >= thumbnailBCtr;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Thumbnail A
              Expanded(child: _thumbnailSlot('A', thumbnailAUrl,
                  thumbnailAImpressions, thumbnailACtr, aWins)),
              const SizedBox(width: 12),
              // Thumbnail B
              Expanded(child: _thumbnailSlot('B', thumbnailBUrl,
                  thumbnailBImpressions, thumbnailBCtr, !aWins)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Thumbnail ${aWins ? 'A' : 'B'} performed better',
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbnailSlot(
      String label, String? url, int impressions, double ctr, bool isWinner) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 130,
                width: double.infinity,
                color: Colors.grey[800],
                child: url != null
                    ? Image.network(url, fit: BoxFit.cover)
                    : Center(
                        child: Text(label,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
              ),
            ),
            if (isWinner)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Winner',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Thumbnail $label',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('${_formatCount(impressions)} impressions',
            style: const TextStyle(color: Colors.grey, fontSize: 11)),
        Text('CTR: ${ctr.toStringAsFixed(1)}%',
            style: TextStyle(
                color: isWinner ? Colors.green : Colors.grey, fontSize: 12)),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
