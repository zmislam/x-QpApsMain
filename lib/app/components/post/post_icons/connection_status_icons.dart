import 'package:flutter/material.dart';

import '../../../models/post.dart';

/// Connection status icons — show relationship between logged-in user
/// and the post author.
///
/// Layout: appears **after** the username in the post header name row.
/// Matches web implementation in `ConnectionStatusIcons.jsx`.

// ─── Colors ────────────────────────────────────────────────
const Color _friendBlue = Color(0xFF1877F2);
const Color _pageOrange = Color(0xFFF57C00);
const Color _groupGreen = Color(0xFF43A047);
const Color _groupGreenLight = Color(0xFF66BB6A);
const Color _successGreen = Color(0xFF42B72A);
const Color _pendingGray = Color(0xFF65676B);

/// Connection status enum for post headers.
enum ConnectionStatus {
  friend,
  requestSent,
  notConnected,
  followingPage,
  notFollowingPage,
  groupMember,
  notGroupMember,
}

/// Determines connection status for a **user post** (no page, no group).
ConnectionStatus? getUserPostConnectionStatus(PostModel post, String currentUserId) {
  final authorId = post.user_id?.id;
  if (authorId == null || authorId == currentUserId) return null;

  if (post.isFriend == true) return ConnectionStatus.friend;
  if (post.isFriendRequestSended == true) return ConnectionStatus.requestSent;
  return ConnectionStatus.notConnected;
}

/// Determines connection status for a **page post**.
ConnectionStatus? getPagePostConnectionStatus(PostModel post, String currentUserId) {
  // Don't show for own pages
  final authorId = post.user_id?.id;
  if (authorId == currentUserId) return null;

  if (post.isFollowingPage == true) return ConnectionStatus.followingPage;
  return ConnectionStatus.notFollowingPage;
}

/// Determines connection status for a **group post**.
ConnectionStatus? getGroupPostConnectionStatus(PostModel post, String currentUserId) {
  final authorId = post.user_id?.id;
  if (authorId == currentUserId) return null;

  if (post.isGroupMember == true) return ConnectionStatus.groupMember;
  return ConnectionStatus.notGroupMember;
}

/// Returns the appropriate connection icon widget. Returns null if no icon.
///
/// [onAddFriend] callback is only used for `notConnected` status (clickable).
Widget? getConnectionStatusIcon(
  ConnectionStatus? status, {
  double size = 16,
  VoidCallback? onAddFriend,
  VoidCallback? onFollowPage,
  VoidCallback? onJoinGroup,
}) {
  if (status == null) return null;

  switch (status) {
    case ConnectionStatus.friend:
      return _FriendConnectedIcon(size: size);
    case ConnectionStatus.requestSent:
      return _RequestSentIcon(size: size);
    case ConnectionStatus.notConnected:
      return GestureDetector(
        onTap: onAddFriend,
        child: _AddFriendIcon(size: size),
      );
    case ConnectionStatus.followingPage:
      return _FollowingPageIcon(size: size);
    case ConnectionStatus.notFollowingPage:
      return GestureDetector(
        onTap: onFollowPage,
        child: _FollowPageIcon(size: size),
      );
    case ConnectionStatus.groupMember:
      return _JoinedGroupIcon(size: size);
    case ConnectionStatus.notGroupMember:
      return GestureDetector(
        onTap: onJoinGroup,
        child: _JoinGroupIcon(size: size),
      );
  }
}

/// Semantic label for accessibility.
String getConnectionStatusLabel(ConnectionStatus? status) {
  switch (status) {
    case ConnectionStatus.friend:
      return 'Friend';
    case ConnectionStatus.requestSent:
      return 'Friend request sent';
    case ConnectionStatus.notConnected:
      return 'Add friend';
    case ConnectionStatus.followingPage:
      return 'Following';
    case ConnectionStatus.groupMember:
      return 'Group member';
    case ConnectionStatus.notFollowingPage:
      return 'Follow page';
    case ConnectionStatus.notGroupMember:
      return 'Join group';
    case null:
      return '';
  }
}

// ═══════════════════════════════════════════════════════════
// Icon Widgets (CustomPaint-based for crisp rendering)
// ═══════════════════════════════════════════════════════════

/// Person + green checkmark badge — Friends.
class _FriendConnectedIcon extends StatelessWidget {
  final double size;
  const _FriendConnectedIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Friend',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _FriendConnectedPainter()),
      ),
    );
  }
}

class _FriendConnectedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Person
    final personPaint = Paint()..color = _friendBlue..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(8 * s, 5 * s), 3 * s, personPaint);

    final personStroke = Paint()
      ..color = _friendBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;
    final bodyPath = Path()
      ..moveTo(2 * s, 14 * s)
      ..quadraticBezierTo(5 * s, 10 * s, 8 * s, 10 * s)
      ..quadraticBezierTo(10 * s, 10 * s, 11.85 * s, 11 * s);
    canvas.drawPath(bodyPath, personStroke);

    // Green checkmark badge
    final badgePaint = Paint()..color = _successGreen..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(15 * s, 13 * s), 5 * s, badgePaint);

    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final checkPath = Path()
      ..moveTo(12.5 * s, 13 * s)
      ..lineTo(14 * s, 14.5 * s)
      ..lineTo(17.5 * s, 11 * s);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Person + gray clock badge — Request sent.
class _RequestSentIcon extends StatelessWidget {
  final double size;
  const _RequestSentIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Friend request sent',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _RequestSentPainter()),
      ),
    );
  }
}

class _RequestSentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Person
    final personPaint = Paint()..color = _friendBlue..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(7 * s, 5 * s), 2.5 * s, personPaint);

    final personStroke = Paint()
      ..color = _friendBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    final bodyPath = Path()
      ..moveTo(2 * s, 13 * s)
      ..quadraticBezierTo(4 * s, 9.5 * s, 7 * s, 9.5 * s)
      ..quadraticBezierTo(8 * s, 9.5 * s, 9.6 * s, 10 * s);
    canvas.drawPath(bodyPath, personStroke);

    // Gray clock badge
    final badgePaint = Paint()..color = _pendingGray..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(14.5 * s, 12.5 * s), 5 * s, badgePaint);

    final clockPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final clockPath = Path()
      ..moveTo(14.5 * s, 10 * s)
      ..lineTo(14.5 * s, 12.5 * s)
      ..lineTo(16.5 * s, 13.5 * s);
    canvas.drawPath(clockPath, clockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Person + green plus badge — Add friend (clickable).
class _AddFriendIcon extends StatelessWidget {
  final double size;
  const _AddFriendIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Add friend',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _AddFriendPainter()),
      ),
    );
  }
}

class _AddFriendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Person
    final personPaint = Paint()..color = _friendBlue..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(7 * s, 5 * s), 2.5 * s, personPaint);

    final personStroke = Paint()
      ..color = _friendBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    final bodyPath = Path()
      ..moveTo(2 * s, 13 * s)
      ..quadraticBezierTo(4 * s, 9.5 * s, 7 * s, 9.5 * s)
      ..quadraticBezierTo(8 * s, 9.5 * s, 9.6 * s, 10 * s);
    canvas.drawPath(bodyPath, personStroke);

    // Green plus badge
    final badgePaint = Paint()..color = _successGreen..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(14.5 * s, 12.5 * s), 5 * s, badgePaint);

    final plusPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    // Vertical line
    canvas.drawLine(Offset(14.5 * s, 10 * s), Offset(14.5 * s, 15 * s), plusPaint);
    // Horizontal line
    canvas.drawLine(Offset(12 * s, 12.5 * s), Offset(17 * s, 12.5 * s), plusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Flag + green checkmark badge — Following page.
class _FollowingPageIcon extends StatelessWidget {
  final double size;
  const _FollowingPageIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Following',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _FollowingPagePainter()),
      ),
    );
  }
}

class _FollowingPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Flag pole
    final polePaint = Paint()
      ..color = _pageOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(3 * s, 2 * s), Offset(3 * s, 16 * s), polePaint);

    // Flag body
    final flagPaint = Paint()..color = _pageOrange..style = PaintingStyle.fill;
    final flagPath = Path()
      ..moveTo(3 * s, 3 * s)
      ..lineTo(12 * s, 3 * s)
      ..quadraticBezierTo(13 * s, 3 * s, 13 * s, 4 * s)
      ..lineTo(13 * s, 9 * s)
      ..quadraticBezierTo(13 * s, 10 * s, 12 * s, 10 * s)
      ..lineTo(3 * s, 10 * s)
      ..close();
    canvas.drawPath(flagPath, flagPaint);

    // Green checkmark badge
    final badgePaint = Paint()..color = _successGreen..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(15 * s, 13 * s), 5 * s, badgePaint);

    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final checkPath = Path()
      ..moveTo(12.5 * s, 13 * s)
      ..lineTo(14 * s, 14.5 * s)
      ..lineTo(17.5 * s, 11 * s);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// People + green checkmark badge — Group member.
class _JoinedGroupIcon extends StatelessWidget {
  final double size;
  const _JoinedGroupIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Group member',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _JoinedGroupPainter()),
      ),
    );
  }
}

class _JoinedGroupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Front person
    final frontPaint = Paint()..color = _groupGreen..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(6 * s, 5 * s), 2.5 * s, frontPaint);

    final frontStroke = Paint()
      ..color = _groupGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    final frontBody = Path()
      ..moveTo(2 * s, 13 * s)
      ..quadraticBezierTo(4 * s, 10 * s, 6 * s, 10 * s)
      ..quadraticBezierTo(7 * s, 10 * s, 8.5 * s, 10.7 * s);
    canvas.drawPath(frontBody, frontStroke);

    // Back person
    final backPaint = Paint()..color = _groupGreenLight..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(11 * s, 6 * s), 2 * s, backPaint);

    // Green checkmark badge
    final badgePaint = Paint()..color = _successGreen..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(15 * s, 13 * s), 5 * s, badgePaint);

    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final checkPath = Path()
      ..moveTo(12.5 * s, 13 * s)
      ..lineTo(14 * s, 14.5 * s)
      ..lineTo(17.5 * s, 11 * s);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════
// Clickable Action Icons (Follow Page / Join Group)
// ═══════════════════════════════════════════════════════════

/// Flag + plus badge — Follow page (clickable).
class _FollowPageIcon extends StatelessWidget {
  final double size;
  const _FollowPageIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Follow page',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _FollowPagePainter()),
      ),
    );
  }
}

class _FollowPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Flag pole
    final polePaint = Paint()
      ..color = _pageOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(3 * s, 2 * s), Offset(3 * s, 16 * s), polePaint);

    // Flag body
    final flagPaint = Paint()..color = _pageOrange..style = PaintingStyle.fill;
    final flagPath = Path()
      ..moveTo(3 * s, 3 * s)
      ..lineTo(12 * s, 3 * s)
      ..quadraticBezierTo(13 * s, 3 * s, 13 * s, 4 * s)
      ..lineTo(13 * s, 9 * s)
      ..quadraticBezierTo(13 * s, 10 * s, 12 * s, 10 * s)
      ..lineTo(3 * s, 10 * s)
      ..close();
    canvas.drawPath(flagPath, flagPaint);

    // Blue plus badge (indicates action available)
    final badgePaint = Paint()..color = _friendBlue..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(15 * s, 13 * s), 5 * s, badgePaint);

    final plusPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(15 * s, 10.5 * s), Offset(15 * s, 15.5 * s), plusPaint);
    canvas.drawLine(Offset(12.5 * s, 13 * s), Offset(17.5 * s, 13 * s), plusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// People + plus badge — Join group (clickable).
class _JoinGroupIcon extends StatelessWidget {
  final double size;
  const _JoinGroupIcon({this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Join group',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _JoinGroupPainter()),
      ),
    );
  }
}

class _JoinGroupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;

    // Front person
    final frontPaint = Paint()..color = _groupGreen..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(6 * s, 5 * s), 2.5 * s, frontPaint);

    final frontStroke = Paint()
      ..color = _groupGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    final frontBody = Path()
      ..moveTo(2 * s, 13 * s)
      ..quadraticBezierTo(4 * s, 10 * s, 6 * s, 10 * s)
      ..quadraticBezierTo(7 * s, 10 * s, 8.5 * s, 10.7 * s);
    canvas.drawPath(frontBody, frontStroke);

    // Back person
    final backPaint = Paint()..color = _groupGreenLight..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(11 * s, 6 * s), 2 * s, backPaint);

    // Blue plus badge (indicates action available)
    final badgePaint = Paint()..color = _friendBlue..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(15 * s, 13 * s), 5 * s, badgePaint);

    final plusPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(15 * s, 10.5 * s), Offset(15 * s, 15.5 * s), plusPaint);
    canvas.drawLine(Offset(12.5 * s, 13 * s), Offset(17.5 * s, 13 * s), plusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
