import 'package:flutter/material.dart';

/// Inline caption editor with #hashtag and @mention autocomplete.
class CaptionEditor extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onHashtagTap;
  final ValueChanged<String> onMentionTap;

  const CaptionEditor({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.onChanged,
    required this.onHashtagTap,
    required this.onMentionTap,
  });

  @override
  State<CaptionEditor> createState() => _CaptionEditorState();
}

class _CaptionEditorState extends State<CaptionEditor> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  String _currentQuery = '';
  bool _isHashtagMode = false;
  bool _isMentionMode = false;

  // Placeholder suggestions — real impl fetches from API
  final List<String> _hashtagSuggestions = [
    'fyp', 'viral', 'trending', 'reels', 'comedy',
    'music', 'dance', 'food', 'travel', 'beauty',
    'fitness', 'fashion', 'art', 'photography', 'nature',
  ];

  final List<Map<String, String>> _mentionSuggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged(widget.controller.text);
    _detectAutocomplete();
  }

  void _detectAutocomplete() {
    final text = widget.controller.text;
    final cursorPos = widget.controller.selection.baseOffset;
    if (cursorPos <= 0 || cursorPos > text.length) {
      _removeOverlay();
      return;
    }

    // Find the word being typed at cursor
    final beforeCursor = text.substring(0, cursorPos);
    final hashMatch = RegExp(r'#(\w*)$').firstMatch(beforeCursor);
    final mentionMatch = RegExp(r'@(\w*)$').firstMatch(beforeCursor);

    if (hashMatch != null) {
      _isHashtagMode = true;
      _isMentionMode = false;
      _currentQuery = hashMatch.group(1) ?? '';
      _showOverlay();
    } else if (mentionMatch != null) {
      _isHashtagMode = false;
      _isMentionMode = true;
      _currentQuery = mentionMatch.group(1) ?? '';
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    List<Widget> items;
    if (_isHashtagMode) {
      final filtered = _hashtagSuggestions
          .where((t) => t.toLowerCase().contains(_currentQuery.toLowerCase()))
          .take(5)
          .toList();
      if (filtered.isEmpty) return;
      items = filtered
          .map((tag) => ListTile(
                dense: true,
                leading: const Icon(Icons.tag, size: 18),
                title: Text('#$tag'),
                onTap: () {
                  widget.onHashtagTap(tag);
                  _removeOverlay();
                },
              ))
          .toList();
    } else {
      // Mention mode — in real impl fetch user search results
      if (_mentionSuggestions.isEmpty) return;
      items = _mentionSuggestions
          .where((u) => (u['name'] ?? '')
              .toLowerCase()
              .contains(_currentQuery.toLowerCase()))
          .take(5)
          .map((user) => ListTile(
                dense: true,
                leading: const CircleAvatar(radius: 14),
                title: Text('@${user['name']}'),
                onTap: () {
                  widget.onMentionTap(user['name']!);
                  _removeOverlay();
                },
              ))
          .toList();
    }
    if (items.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: items,
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isHashtagMode = false;
    _isMentionMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          maxLines: 5,
          minLines: 3,
          maxLength: widget.maxLength,
          decoration: const InputDecoration(
            hintText: 'Write a caption...\nUse # for hashtags, @ for mentions',
            border: InputBorder.none,
            counterText: '',
          ),
          style: const TextStyle(fontSize: 15),
        ),
        // Character count
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${widget.controller.text.length}/${widget.maxLength}',
            style: TextStyle(
              fontSize: 12,
              color: widget.controller.text.length > widget.maxLength * 0.9
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
