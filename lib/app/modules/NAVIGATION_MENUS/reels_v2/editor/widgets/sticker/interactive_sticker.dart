import 'package:flutter/material.dart';
import '../../controllers/reels_editor_controller.dart';

/// Interactive sticker widget for poll, quiz, countdown, mention, location, hashtag.
/// In the editor, this shows the editable form.
/// In the viewer, this shows the interactive UI for audience engagement.
class InteractiveSticker extends StatefulWidget {
  final StickerOverlay sticker;
  final bool isEditing;
  final ValueChanged<StickerOverlay>? onUpdate;

  const InteractiveSticker({
    super.key,
    required this.sticker,
    this.isEditing = false,
    this.onUpdate,
  });

  @override
  State<InteractiveSticker> createState() => _InteractiveStickerState();
}

class _InteractiveStickerState extends State<InteractiveSticker> {
  @override
  Widget build(BuildContext context) {
    switch (widget.sticker.type) {
      case StickerType.poll:
        return _buildPoll();
      case StickerType.quiz:
        return _buildQuiz();
      case StickerType.mention:
        return _buildMention();
      case StickerType.hashtag:
        return _buildHashtag();
      default:
        return const SizedBox.shrink();
    }
  }

  // ═══════════════════════════════════════════════════════
  // POLL
  // ═══════════════════════════════════════════════════════

  Widget _buildPoll() {
    final data = widget.sticker.interactiveData ?? {};
    final question = data['question'] as String? ?? 'Ask a question...';
    final options =
        (data['options'] as List?)?.cast<String>() ?? ['Yes', 'No'];
    final votes = (data['votes'] as List?)?.cast<int>() ??
        List<int>.filled(options.length, 0);
    final totalVotes = votes.fold<int>(0, (a, b) => a + b);

    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Question
          widget.isEditing
              ? _editableText(question, (text) {
                  _updateData({'question': text});
                })
              : Text(
                  question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 12),
          // Options
          ...options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final voteCount = idx < votes.length ? votes[idx] : 0;
            final fraction = totalVotes > 0 ? voteCount / totalVotes : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: widget.isEditing
                    ? null
                    : () => _castPollVote(idx),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Result bar
                      if (!widget.isEditing && totalVotes > 0)
                        Positioned.fill(
                          child: FractionallySizedBox(
                            widthFactor: fraction,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      // Text
                      widget.isEditing
                          ? _editableText(option, (text) {
                              final newOptions = List<String>.from(options);
                              newOptions[idx] = text;
                              _updateData({'options': newOptions});
                            })
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                if (totalVotes > 0)
                                  Text(
                                    '${(fraction * 100).round()}%',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // Add option button (editing only)
          if (widget.isEditing && options.length < 4)
            GestureDetector(
              onTap: () {
                final newOptions = List<String>.from(options);
                newOptions.add('Option ${newOptions.length + 1}');
                _updateData({'options': newOptions});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Add option',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _castPollVote(int optionIndex) {
    final data = Map<String, dynamic>.from(
        widget.sticker.interactiveData ?? {});
    final votes = List<int>.from(
        (data['votes'] as List?) ?? List<int>.filled(
            (data['options'] as List?)?.length ?? 2, 0));
    if (optionIndex < votes.length) {
      votes[optionIndex]++;
    }
    data['votes'] = votes;
    widget.onUpdate?.call(widget.sticker.copyWith(interactiveData: data));
  }

  // ═══════════════════════════════════════════════════════
  // QUIZ
  // ═══════════════════════════════════════════════════════

  Widget _buildQuiz() {
    final data = widget.sticker.interactiveData ?? {};
    final question = data['question'] as String? ?? 'Quiz question...';
    final options =
        (data['options'] as List?)?.cast<String>() ?? ['A', 'B', 'C'];
    final correctIndex = data['correctIndex'] as int? ?? 0;
    final answered = data['answered'] as bool? ?? false;
    final selectedIdx = data['selectedIndex'] as int?;

    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE17055), Color(0xFFFAB1A0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.quiz, color: Colors.white, size: 22),
          const SizedBox(height: 8),
          widget.isEditing
              ? _editableText(question, (text) {
                  _updateData({'question': text});
                })
              : Text(
                  question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 12),
          ...options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isCorrect = idx == correctIndex;
            final isSelected = selectedIdx == idx;
            Color bgColor = Colors.white.withValues(alpha: 0.2);
            if (answered) {
              if (isCorrect) {
                bgColor = Colors.green.withValues(alpha: 0.5);
              } else if (isSelected) {
                bgColor = Colors.red.withValues(alpha: 0.5);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: (widget.isEditing || answered)
                    ? null
                    : () => _answerQuiz(idx),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: widget.isEditing && isCorrect
                        ? Border.all(color: Colors.green, width: 2)
                        : null,
                  ),
                  child: widget.isEditing
                      ? Row(
                          children: [
                            Expanded(
                              child: _editableText(option, (text) {
                                final newOptions =
                                    List<String>.from(options);
                                newOptions[idx] = text;
                                _updateData({'options': newOptions});
                              }),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _updateData({'correctIndex': idx}),
                              child: Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.white54,
                                size: 18,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          option,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _answerQuiz(int selectedIndex) {
    final data = Map<String, dynamic>.from(
        widget.sticker.interactiveData ?? {});
    data['answered'] = true;
    data['selectedIndex'] = selectedIndex;
    widget.onUpdate?.call(widget.sticker.copyWith(interactiveData: data));
  }

  // ═══════════════════════════════════════════════════════
  // MENTION
  // ═══════════════════════════════════════════════════════

  Widget _buildMention() {
    final username =
        widget.sticker.interactiveData?['username'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.alternate_email, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          widget.isEditing
              ? SizedBox(
                  width: 120,
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'username',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (text) => _updateData({'username': text}),
                  ),
                )
              : Text(
                  username.isEmpty ? 'mention' : username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // HASHTAG
  // ═══════════════════════════════════════════════════════

  Widget _buildHashtag() {
    final tag =
        widget.sticker.interactiveData?['tag'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tag, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          widget.isEditing
              ? SizedBox(
                  width: 120,
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'hashtag',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (text) => _updateData({'tag': text}),
                  ),
                )
              : Text(
                  tag.isEmpty ? 'hashtag' : tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════

  Widget _editableText(String text, ValueChanged<String> onChanged) {
    return TextField(
      controller: TextEditingController(text: text),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      textAlign: TextAlign.center,
      onChanged: onChanged,
    );
  }

  void _updateData(Map<String, dynamic> updates) {
    final data = Map<String, dynamic>.from(
        widget.sticker.interactiveData ?? {});
    data.addAll(updates);
    widget.onUpdate?.call(widget.sticker.copyWith(interactiveData: data));
  }
}
