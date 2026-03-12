import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class SmartText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextStyle? urlStyle;
  final TextStyle? hashtagStyle;
  final TextStyle? mentionStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaleFactor;
  final int maxLines;
  final String expandText;
  final String? collapseText;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final Curve animationCurve;
  final Function(String)? onUrlTap;
  final Function(String)? onHashtagTap;
  final Function(String)? onMentionTap;
  final bool detectUrls;
  final bool detectHashtags;
  final bool detectMentions;

  const SmartText(
    this.text, {
    super.key,
    this.style,
    this.linkStyle,
    this.urlStyle,
    this.hashtagStyle,
    this.mentionStyle,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines = 2,
    this.expandText = 'See more',
    this.collapseText,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.fastOutSlowIn,
    this.onUrlTap,
    this.onHashtagTap,
    this.onMentionTap,
    this.detectUrls = true,
    this.detectHashtags = true,
    this.detectMentions = true,
  });

  @override
  State<SmartText> createState() => _SmartTextState();
}

class _SmartTextState extends State<SmartText> {
  late bool _expanded;
  late TapGestureRecognizer _linkTapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _linkTapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _linkTapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (!uri.hasScheme) {
      await launchUrl(Uri.parse('https://$url'));
    } else {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final effectiveTextStyle = widget.style ?? defaultTextStyle.style;
    final linkText = _expanded ? (widget.collapseText ?? 'See less') : widget.expandText;
    final linkColor = widget.linkStyle?.color ?? Theme.of(context).colorScheme.primary;
    final linkTextStyle = effectiveTextStyle.merge(widget.linkStyle).copyWith(color: linkColor);

    // Parse the text for patterns
    final segments = _parseText(widget.text);

    return LayoutBuilder(
      builder: (context, constraints) {
        // First check if we need to truncate at all
        final textSpan = _buildTextSpan(
          segments: segments,
          effectiveTextStyle: effectiveTextStyle,
          includeLink: false,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textAlign: widget.textAlign ?? TextAlign.start,
          textDirection: widget.textDirection ?? Directionality.of(context),
          textScaler: widget.textScaleFactor ?? MediaQuery.textScalerOf(context),
          maxLines: widget.maxLines,
        )..layout(maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return RichText(
            text: textSpan,
            textAlign: widget.textAlign ?? TextAlign.left,
            textDirection: widget.textDirection,
            softWrap: widget.softWrap ?? true,
            overflow: widget.overflow ?? TextOverflow.clip,
          );
        }

        // If we need truncation, build with link
        final linkSpan = TextSpan(
          text: ' $linkText'.tr,
          style: linkTextStyle,
          recognizer: _linkTapGestureRecognizer,
        );

        final truncatedTextSpan = _buildTextSpan(
          segments: segments,
          effectiveTextStyle: effectiveTextStyle,
          includeLink: true,
          linkSpan: linkSpan,
          maxLines: widget.maxLines,
          maxWidth: constraints.maxWidth,
        );

        return AnimatedSize(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          alignment: Alignment.topLeft,
          child: RichText(
            text: _expanded
                ? TextSpan(
                    children: [
                      ..._buildTextSpans(segments, effectiveTextStyle),
                      linkSpan,
                    ],
                    style: effectiveTextStyle,
                  )
                : truncatedTextSpan,
            textAlign: widget.textAlign ?? TextAlign.left,
            textDirection: widget.textDirection,
            softWrap: widget.softWrap ?? true,
            overflow: widget.overflow ?? TextOverflow.clip,
          ),
        );
      },
    );
  }

  TextSpan _buildTextSpan({
    required List<TextSegment> segments,
    required TextStyle effectiveTextStyle,
    bool includeLink = false,
    TextSpan? linkSpan,
    int? maxLines,
    double? maxWidth,
  }) {
    if (!includeLink) {
      return TextSpan(
        children: _buildTextSpans(segments, effectiveTextStyle),
        style: effectiveTextStyle,
      );
    }

    // Find the truncation point
    final textPainter = TextPainter(
      text: TextSpan(
        children: _buildTextSpans(segments, effectiveTextStyle),
        style: effectiveTextStyle,
      ),
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? Directionality.of(context),
      textScaler: widget.textScaleFactor ?? MediaQuery.textScalerOf(context),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth!);

    final position = textPainter.getPositionForOffset(Offset(
      maxWidth - 50, // Approximate space needed for link
      textPainter.size.height,
    ));
    final endOffset = max(textPainter.getOffsetBefore(position.offset) ?? 0, 0);

    // Rebuild with truncated text
    final truncatedSegments = _truncateSegments(segments, endOffset);
    return TextSpan(
      children: [
        ..._buildTextSpans(truncatedSegments, effectiveTextStyle),
        linkSpan!,
      ],
      style: effectiveTextStyle,
    );
  }

  List<TextSegment> _truncateSegments(List<TextSegment> segments, int endOffset) {
    final result = <TextSegment>[];
    int currentLength = 0;

    for (final segment in segments) {
      if (currentLength >= endOffset) break;

      final remaining = endOffset - currentLength;
      if (remaining >= segment.text.length) {
        result.add(segment);
        currentLength += segment.text.length;
      } else {
        result.add(TextSegment(
          text: segment.text.substring(0, remaining),
          type: segment.type,
        ));
        break;
      }
    }

    return result;
  }

  List<TextSpan> _buildTextSpans(List<TextSegment> segments, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final urlStyle = baseStyle.merge(widget.urlStyle).copyWith(
          color: widget.urlStyle?.color ?? Colors.blue,
          decoration: widget.urlStyle?.decoration ?? TextDecoration.underline,
        );
    final hashtagStyle = baseStyle.merge(widget.hashtagStyle).copyWith(
          color: widget.hashtagStyle?.color ?? Colors.green,
        );
    final mentionStyle = baseStyle.merge(widget.mentionStyle).copyWith(
          color: widget.mentionStyle?.color ?? Colors.blue,
        );

    for (final segment in segments) {
      TextStyle? style;
      GestureRecognizer? recognizer;

      switch (segment.type) {
        case TextSegmentType.url:
          if (widget.detectUrls) {
            style = urlStyle;
            recognizer = TapGestureRecognizer()
              ..onTap = () {
                if (widget.onUrlTap != null) {
                  widget.onUrlTap!(segment.text);
                } else {
                  _launchUrl(segment.text);
                }
              };
          }
          break;
        case TextSegmentType.hashtag:
          if (widget.detectHashtags) {
            style = hashtagStyle;
            if (widget.onHashtagTap != null) {
              recognizer = TapGestureRecognizer()..onTap = () => widget.onHashtagTap!(segment.text);
            }
          }
          break;
        case TextSegmentType.mention:
          if (widget.detectMentions) {
            style = mentionStyle;
            if (widget.onMentionTap != null) {
              recognizer = TapGestureRecognizer()..onTap = () => widget.onMentionTap!(segment.text);
            }
          }
          break;
        case TextSegmentType.text:
          // No special styling
          break;
      }

      spans.add(TextSpan(
        text: segment.text,
        style: style,
        recognizer: recognizer,
      ));
    }

    return spans;
  }

  List<TextSegment> _parseText(String text) {
    final segments = <TextSegment>[];
    final urlRegex = RegExp(r'(https?://[^\s]+)');
    final hashtagRegex = RegExp(r'(#\w+)');
    final mentionRegex = RegExp(r'(@\w+)');

    int currentIndex = 0;

    // Find all matches and the text between them
    final allMatches = [
      ...urlRegex.allMatches(text),
      ...hashtagRegex.allMatches(text),
      ...mentionRegex.allMatches(text),
    ]..sort((a, b) => a.start.compareTo(b.start));

    for (final match in allMatches) {
      // Add preceding text if any
      if (match.start > currentIndex) {
        segments.add(TextSegment(
          text: text.substring(currentIndex, match.start),
          type: TextSegmentType.text,
        ));
      }

      // Add the matched segment
      final matchedText = match.group(0)!;
      TextSegmentType type;
      if (urlRegex.hasMatch(matchedText)) {
        type = TextSegmentType.url;
      } else if (hashtagRegex.hasMatch(matchedText)) {
        type = TextSegmentType.hashtag;
      } else {
        type = TextSegmentType.mention;
      }

      segments.add(TextSegment(
        text: matchedText,
        type: type,
      ));

      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      segments.add(TextSegment(
        text: text.substring(currentIndex),
        type: TextSegmentType.text,
      ));
    }

    return segments;
  }
}

enum TextSegmentType {
  text,
  url,
  hashtag,
  mention,
}

class TextSegment {
  final String text;
  final TextSegmentType type;

  TextSegment({
    required this.text,
    required this.type,
  });
}
