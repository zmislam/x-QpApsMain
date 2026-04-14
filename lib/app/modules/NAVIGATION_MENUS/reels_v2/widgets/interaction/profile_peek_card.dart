import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Profile peek card shown on long-press of an avatar.
/// Shows user avatar, name, bio, follower count, follow button.
class ProfilePeekCard extends StatefulWidget {
  final String userId;
  final String userName;
  final String? userAvatar;
  final String? bio;
  final int followerCount;
  final bool isFollowing;
  final bool isVerified;
  final VoidCallback? onFollow;
  final VoidCallback? onViewProfile;

  const ProfilePeekCard({
    super.key,
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.bio,
    this.followerCount = 0,
    this.isFollowing = false,
    this.isVerified = false,
    this.onFollow,
    this.onViewProfile,
  });

  /// Show profile peek as an overlay at a given position
  static OverlayEntry? _currentEntry;

  static void show({
    required BuildContext context,
    required Offset position,
    required String userId,
    required String userName,
    String? userAvatar,
    String? bio,
    int followerCount = 0,
    bool isFollowing = false,
    bool isVerified = false,
    VoidCallback? onFollow,
    VoidCallback? onViewProfile,
  }) {
    dismiss();

    _currentEntry = OverlayEntry(
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        // Position above the touch point, centered horizontally
        double left = (position.dx - 120).clamp(8.0, size.width - 248.0);
        double top = (position.dy - 200).clamp(8.0, size.height - 260.0);

        return Stack(
          children: [
            // Backdrop to dismiss
            Positioned.fill(
              child: GestureDetector(
                onTap: dismiss,
                child: const ColoredBox(color: Colors.black38),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: ProfilePeekCard(
                  userId: userId,
                  userName: userName,
                  userAvatar: userAvatar,
                  bio: bio,
                  followerCount: followerCount,
                  isFollowing: isFollowing,
                  isVerified: isVerified,
                  onFollow: onFollow,
                  onViewProfile: () {
                    dismiss();
                    onViewProfile?.call();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_currentEntry!);
  }

  static void dismiss() {
    _currentEntry?.remove();
    _currentEntry = null;
  }

  @override
  State<ProfilePeekCard> createState() => _ProfilePeekCardState();
}

class _ProfilePeekCardState extends State<ProfilePeekCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.grey[800],
                backgroundImage: widget.userAvatar != null
                    ? NetworkImage(widget.userAvatar!)
                    : null,
                child: widget.userAvatar == null
                    ? const Icon(Icons.person, color: Colors.white54, size: 36)
                    : null,
              ),
              const SizedBox(height: 10),

              // Name + verified
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 14, color: Colors.blue),
                  ],
                ],
              ),

              // Bio
              if (widget.bio != null && widget.bio!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.bio!,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 8),

              // Follower count
              Text(
                '${_formatCount(widget.followerCount)} followers',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 12),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _PeekButton(
                      label: widget.isFollowing ? 'Following' : 'Follow',
                      filled: !widget.isFollowing,
                      onTap: widget.onFollow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PeekButton(
                      label: 'View Profile',
                      filled: false,
                      onTap: widget.onViewProfile,
                    ),
                  ),
                ],
              ),
            ],
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

class _PeekButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const _PeekButton({
    required this.label,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: filled ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: filled ? Colors.blue : Colors.white30,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
