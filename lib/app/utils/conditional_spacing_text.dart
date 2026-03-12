import 'package:flutter/material.dart';

class ConditionalSpacingText extends StatefulWidget {
  final String text;
  
  const ConditionalSpacingText({super.key, required this.text});

  @override
  State<ConditionalSpacingText> createState() => _ConditionalSpacingTextState();
}

class _ConditionalSpacingTextState extends State<ConditionalSpacingText> {
  bool _needsSpacing = false;
  final _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureText());
  }

  void _measureText() {
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: renderBox.size.width);
    if (!textPainter.didExceedMaxLines) {
      setState(() => _needsSpacing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          key: _textKey,
          textAlign: TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_needsSpacing) const SizedBox(height: 15),
      ],
    );
  }
}