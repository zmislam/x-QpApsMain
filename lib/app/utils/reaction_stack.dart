import 'package:flutter/cupertino.dart';

/// Circular profile avatar with a small reaction emoji badge at bottom-right.
/// Facebook-style design — 2026-03-14 redesign.
class ReactionStack extends StatelessWidget {
  final String profileImageLink;
  final String reactionImageLink;

  const ReactionStack(
      {super.key,
      required this.profileImageLink,
      required this.reactionImageLink});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Circular avatar ───────────────────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE4E6EA),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(profileImageLink),
              ),
            ),
          ),
          // ── Reaction badge (bottom-right) ─────────────────────────
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: Image.asset(
                  reactionImageLink,
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
