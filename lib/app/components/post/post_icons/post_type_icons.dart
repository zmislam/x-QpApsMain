import 'package:flutter/material.dart';

import '../../../models/post.dart';

/// Post type icons — colorful icons to visually identify post source type.
///
/// Layout: appears **before** the avatar in the post header row.
/// Matches web implementation in `PostTypeIcons.jsx`.

// ─── Colors ────────────────────────────────────────────────
const Color _userBlue = Color(0xFF1877F2);
const Color _pageOrange = Color(0xFFF57C00);
const Color _groupGreen = Color(0xFF43A047);
const Color _groupGreenLight = Color(0xFF66BB6A);
const Color _sponsoredYellow = Color(0xFFFFC107);
const Color _sponsoredOrange = Color(0xFFFFA000);

/// Determines and returns the appropriate post type icon widget.
Widget? getPostTypeIcon(PostModel post, {double size = 20}) {
  final type = _detectPostType(post);
  switch (type) {
    case _PostType.sponsored:
      return SponsoredPostIcon(size: size);
    case _PostType.group:
      return GroupPostIcon(size: size);
    case _PostType.page:
      return PagePostIcon(size: size);
    case _PostType.user:
      return UserPostIcon(size: size);
  }
}

enum _PostType { user, page, group, sponsored }

_PostType _detectPostType(PostModel post) {
  if (post.campaign_id?.id != null && (post.campaign_id?.id?.isNotEmpty ?? false)) {
    return _PostType.sponsored;
  }
  if ((post.groupId.groupName?.length ?? 0) > 1) {
    return _PostType.group;
  }
  if ((post.page_id.pageName?.length ?? 0) > 1) {
    return _PostType.page;
  }
  return _PostType.user;
}

/// Blue person silhouette — User post.
class UserPostIcon extends StatelessWidget {
  final double size;
  const UserPostIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _UserPostPainter()),
    );
  }
}

class _UserPostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _userBlue
      ..style = PaintingStyle.fill;
    final s = size.width / 24;

    // Head circle
    canvas.drawCircle(Offset(12 * s, 8 * s), 4 * s, paint);

    // Body arc
    final bodyPath = Path()
      ..moveTo(4 * s, 20 * s)
      ..quadraticBezierTo(4 * s, 14 * s, 12 * s, 14 * s)
      ..quadraticBezierTo(20 * s, 14 * s, 20 * s, 20 * s)
      ..lineTo(20 * s, 21 * s)
      ..lineTo(4 * s, 21 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Orange flag — Page post.
class PagePostIcon extends StatelessWidget {
  final double size;
  const PagePostIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PagePostPainter()),
    );
  }
}

class _PagePostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;

    // Flag pole
    final polePaint = Paint()
      ..color = _pageOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(5 * s, 3 * s), Offset(5 * s, 21 * s), polePaint);

    // Flag body
    final flagPaint = Paint()
      ..color = _pageOrange
      ..style = PaintingStyle.fill;
    final flagPath = Path()
      ..moveTo(5 * s, 4 * s)
      ..lineTo(18 * s, 4 * s)
      ..quadraticBezierTo(19 * s, 4 * s, 19 * s, 5 * s)
      ..lineTo(19 * s, 12 * s)
      ..quadraticBezierTo(19 * s, 13 * s, 18 * s, 13 * s)
      ..lineTo(5 * s, 13 * s)
      ..close();
    canvas.drawPath(flagPath, flagPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Green people — Group post.
class GroupPostIcon extends StatelessWidget {
  final double size;
  const GroupPostIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GroupPostPainter()),
    );
  }
}

class _GroupPostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;

    // Front person (darker green)
    final frontPaint = Paint()
      ..color = _groupGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(9 * s, 7 * s), 3 * s, frontPaint);
    final frontBody = Path()
      ..moveTo(3 * s, 18 * s)
      ..quadraticBezierTo(3 * s, 13 * s, 9 * s, 13 * s)
      ..quadraticBezierTo(15 * s, 13 * s, 15 * s, 18 * s)
      ..lineTo(15 * s, 19 * s)
      ..lineTo(3 * s, 19 * s)
      ..close();
    canvas.drawPath(frontBody, frontPaint);

    // Back person (lighter green)
    final backPaint = Paint()
      ..color = _groupGreenLight
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(16 * s, 8 * s), 2.5 * s, backPaint);
    final backBody = Path()
      ..moveTo(13 * s, 19 * s)
      ..quadraticBezierTo(13 * s, 15 * s, 17 * s, 15 * s)
      ..quadraticBezierTo(21 * s, 15 * s, 21 * s, 19 * s)
      ..lineTo(13 * s, 19 * s)
      ..close();
    canvas.drawPath(backBody, backPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Yellow megaphone — Sponsored post.
class SponsoredPostIcon extends StatelessWidget {
  final double size;
  const SponsoredPostIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SponsoredPostPainter()),
    );
  }
}

class _SponsoredPostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;

    final fillPaint = Paint()
      ..color = _sponsoredYellow
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = _sponsoredOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;

    // Speaker cone
    final conePath = Path()
      ..moveTo(18 * s, 8 * s)
      ..lineTo(22 * s, 4 * s)
      ..lineTo(22 * s, 20 * s)
      ..lineTo(18 * s, 16 * s)
      ..close();
    canvas.drawPath(conePath, fillPaint);
    canvas.drawPath(conePath, strokePaint);

    // Speaker body (rounded rect)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2 * s, 7 * s, 16 * s, 10 * s),
      Radius.circular(2 * s),
    );
    canvas.drawRRect(bodyRect, fillPaint);
    canvas.drawRRect(bodyRect, strokePaint);

    // Handle legs
    final legPaint = Paint()
      ..color = _sponsoredOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(6 * s, 17 * s), Offset(6 * s, 21 * s), legPaint);
    canvas.drawLine(Offset(10 * s, 17 * s), Offset(10 * s, 20 * s), legPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
