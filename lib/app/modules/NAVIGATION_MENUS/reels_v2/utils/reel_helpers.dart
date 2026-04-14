/// Utility helpers for Reels V2.
class ReelHelpers {
  ReelHelpers._();

  /// Format view count for display: 1K, 1.2M, etc.
  static String formatCount(int? count) {
    if (count == null || count <= 0) return '0';
    if (count < 1000) return count.toString();
    if (count < 10000) return '${(count / 1000).toStringAsFixed(1)}K';
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(0)}K';
    if (count < 10000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count < 1000000000) return '${(count / 1000000).toStringAsFixed(0)}M';
    return '${(count / 1000000000).toStringAsFixed(1)}B';
  }

  /// Format duration in ms to mm:ss display.
  static String formatDuration(int? durationMs) {
    if (durationMs == null || durationMs <= 0) return '0:00';
    final seconds = (durationMs / 1000).round();
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  /// Format timestamp to relative time (e.g., "2h ago", "3d ago").
  static String formatRelativeTime(String? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.tryParse(timestamp);
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  /// Extract hashtags from caption text.
  static List<String> extractHashtags(String caption) {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(caption).map((m) => m.group(1)!).toList();
  }

  /// Extract @mentions from caption text.
  static List<String> extractMentions(String caption) {
    final regex = RegExp(r'@(\w+)');
    return regex.allMatches(caption).map((m) => m.group(1)!).toList();
  }

  /// Truncate text with ellipsis.
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Calculate video quality based on connection speed.
  static String selectQuality(double? connectionSpeedMbps) {
    if (connectionSpeedMbps == null) return '480p';
    if (connectionSpeedMbps >= 10) return '1080p';
    if (connectionSpeedMbps >= 5) return '720p';
    if (connectionSpeedMbps >= 2) return '480p';
    return '360p';
  }

  /// Generate cursor pagination params for API calls.
  static Map<String, dynamic> buildCursorParams({
    String? cursor,
    int limit = 10,
  }) {
    final params = <String, dynamic>{'limit': limit};
    if (cursor != null) params['cursor'] = cursor;
    return params;
  }

  /// Parse cursor from API response for next page.
  static String? parseCursor(Map<String, dynamic>? response) {
    if (response == null) return null;
    return response['next_cursor'] as String?;
  }
}
