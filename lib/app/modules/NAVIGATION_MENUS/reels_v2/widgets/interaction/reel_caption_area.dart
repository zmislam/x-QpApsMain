import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Expandable caption area for reels.
/// Truncated by default with "more" button.
/// Tappable hashtags (#) and mentions (@).
class ReelCaptionArea extends StatefulWidget {
  final String? caption;
  final List<String>? hashtags;
  final List<String>? mentionedUserIds;

  const ReelCaptionArea({
    super.key,
    this.caption,
    this.hashtags,
    this.mentionedUserIds,
  });

  @override
  State<ReelCaptionArea> createState() => _ReelCaptionAreaState();
}

class _ReelCaptionAreaState extends State<ReelCaptionArea> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.caption == null || widget.caption!.isEmpty) {
      return const SizedBox.shrink();
    }

    final caption = widget.caption!;
    final maxLength = _isExpanded ? caption.length : 100;
    final shouldTruncate = caption.length > 100 && !_isExpanded;

    return GestureDetector(
      onTap: () {
        if (shouldTruncate) {
          setState(() => _isExpanded = true);
        }
      },
      child: RichText(
        maxLines: _isExpanded ? null : 2,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            ..._buildCaptionSpans(
              caption.substring(0, caption.length.clamp(0, maxLength)),
            ),
            if (shouldTruncate)
              TextSpan(
                text: '... more',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() => _isExpanded = true);
                  },
              ),
            if (_isExpanded && caption.length > 100)
              TextSpan(
                text: ' less',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() => _isExpanded = false);
                  },
              ),
          ],
        ),
      ),
    );
  }

  /// Build TextSpan list with tappable hashtags (#) and mentions (@).
  List<InlineSpan> _buildCaptionSpans(String text) {
    final List<InlineSpan> spans = [];
    // Match #hashtag or @mention
    final regex = RegExp(r'(#\w+|@\w+)');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Text before the match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: _normalStyle,
        ));
      }

      final tag = match.group(0)!;
      final isHashtag = tag.startsWith('#');

      spans.add(TextSpan(
        text: tag,
        style: _highlightStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (isHashtag) {
              _onHashtagTap(tag.substring(1));
            } else {
              _onMentionTap(tag.substring(1));
            }
          },
      ));

      lastEnd = match.end;
    }

    // Remaining text after last match
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: _normalStyle,
      ));
    }

    return spans;
  }

  void _onHashtagTap(String tag) {
    // Navigate to hashtag feed
    Get.toNamed('/hashtag/$tag');
  }

  void _onMentionTap(String username) {
    // Navigate to user profile
    Get.toNamed('/profile/$username');
  }

  TextStyle get _normalStyle => const TextStyle(
        color: Colors.white,
        fontSize: 13,
        height: 1.4,
        shadows: [Shadow(color: Colors.black38, blurRadius: 3)],
      );

  TextStyle get _highlightStyle => const TextStyle(
        color: Colors.white,
        fontSize: 13,
        height: 1.4,
        fontWeight: FontWeight.w600,
        shadows: [Shadow(color: Colors.black38, blurRadius: 3)],
      );
}
