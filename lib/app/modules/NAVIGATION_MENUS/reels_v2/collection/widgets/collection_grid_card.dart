import 'package:flutter/material.dart';
import '../../models/reel_collection_model.dart';

class CollectionGridCard extends StatelessWidget {
  final ReelCollectionModel collection;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CollectionGridCard({
    super.key,
    required this.collection,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image grid (2x2 thumbnails)
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: _buildCoverGrid(),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${collection.reelCount} reels',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverGrid() {
    final covers = collection.coverUrls ?? [];
    if (covers.isEmpty) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.bookmark, color: Colors.grey, size: 40),
        ),
      );
    }
    if (covers.length == 1) {
      return Image.network(covers[0], fit: BoxFit.cover, width: double.infinity);
    }

    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: covers.take(4).map((url) {
        return Image.network(url, fit: BoxFit.cover);
      }).toList(),
    );
  }
}
