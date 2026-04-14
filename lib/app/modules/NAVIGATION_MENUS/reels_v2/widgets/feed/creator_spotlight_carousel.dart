import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatorSpotlightCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> creators;

  const CreatorSpotlightCarousel({super.key, required this.creators});

  @override
  Widget build(BuildContext context) {
    if (creators.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey[900]?.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Creators to follow',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _creatorCard(creators[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _creatorCard(Map<String, dynamic> creator) {
    final name = creator['name'] ?? creator['username'] ?? '';
    final username = creator['username'] ?? '';
    final avatar = creator['avatar'] as String?;
    final isVerified = creator['isVerified'] ?? false;
    final reelCount = creator['reelCount'] ?? 0;

    return GestureDetector(
      onTap: () => Get.toNamed('/profile/${creator['_id'] ?? ''}'),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850] ?? Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[700],
              backgroundImage:
                  avatar != null ? NetworkImage(avatar) : null,
              child: avatar == null
                  ? const Icon(Icons.person, color: Colors.white, size: 32)
                  : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                if (isVerified) ...[
                  const SizedBox(width: 3),
                  const Icon(Icons.verified, color: Colors.blue, size: 14),
                ],
              ],
            ),
            Text('@$username',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('Follow',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
