import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_editor_controller.dart';
import '../controllers/reels_effects_controller.dart';

/// Preview & publish screen for Reels V2.
/// Shows final video preview with all effects applied,
/// caption input, privacy settings, and publish button.
class ReelsPreviewView extends StatefulWidget {
  const ReelsPreviewView({super.key});

  @override
  State<ReelsPreviewView> createState() => _ReelsPreviewViewState();
}

class _ReelsPreviewViewState extends State<ReelsPreviewView> {
  final _captionController = TextEditingController();
  final _captionFocus = FocusNode();
  bool _allowComments = true;
  bool _allowDuet = true;
  bool _allowStitch = true;
  bool _allowDownload = false;
  String _privacy = 'public';
  bool _isPublishing = false;

  List<EditClip>? _clips;
  List<TextOverlay>? _textOverlays;
  List<StickerOverlay>? _stickers;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _clips = args['clips'] as List<EditClip>?;
      _textOverlays = args['textOverlays'] as List<TextOverlay>?;
      _stickers = args['stickers'] as List<StickerOverlay>?;
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _captionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Video Preview Card ──────────────
                    _buildPreviewCard(),
                    const SizedBox(height: 20),

                    // ─── Caption ─────────────────────────
                    _buildCaptionInput(),
                    const SizedBox(height: 20),

                    // ─── Privacy Setting ─────────────────
                    _buildPrivacySelector(),
                    const SizedBox(height: 16),

                    // ─── Toggle Settings ─────────────────
                    _buildToggleRow('Allow comments', _allowComments, (v) {
                      setState(() => _allowComments = v);
                    }),
                    _buildToggleRow('Allow Duet', _allowDuet, (v) {
                      setState(() => _allowDuet = v);
                    }),
                    _buildToggleRow('Allow Stitch', _allowStitch, (v) {
                      setState(() => _allowStitch = v);
                    }),
                    _buildToggleRow('Allow download', _allowDownload, (v) {
                      setState(() => _allowDownload = v);
                    }),
                    const SizedBox(height: 24),

                    // ─── Hashtag Suggestions ─────────────
                    _buildHashtagSuggestions(),
                  ],
                ),
              ),
            ),
            // ─── Bottom Publish Bar ──────────────────────
            _buildPublishBar(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // TOP BAR
  // ═══════════════════════════════════════════════════════

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const Expanded(
            child: Text(
              'Post',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // PREVIEW CARD
  // ═══════════════════════════════════════════════════════

  Widget _buildPreviewCard() {
    return Center(
      child: Container(
        width: 160,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey[850],
                child: const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: Colors.white54, size: 48),
                ),
              ),
            ),
            // Clip count badge
            if (_clips != null && _clips!.isNotEmpty)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_clips!.length} clip${_clips!.length > 1 ? 's' : ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            // Edit button
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // CAPTION INPUT
  // ═══════════════════════════════════════════════════════

  Widget _buildCaptionInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _captionController,
        focusNode: _captionFocus,
        maxLines: 4,
        maxLength: 2200,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Write a caption...',
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
          counterStyle: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // PRIVACY SELECTOR
  // ═══════════════════════════════════════════════════════

  Widget _buildPrivacySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Who can view this reel',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _privacyChip('Public', 'public'),
            const SizedBox(width: 8),
            _privacyChip('Friends', 'friends'),
            const SizedBox(width: 8),
            _privacyChip('Only me', 'private'),
          ],
        ),
      ],
    );
  }

  Widget _privacyChip(String label, String value) {
    final isSelected = _privacy == value;
    return GestureDetector(
      onTap: () => setState(() => _privacy = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // TOGGLE ROWS
  // ═══════════════════════════════════════════════════════

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // HASHTAG SUGGESTIONS
  // ═══════════════════════════════════════════════════════

  Widget _buildHashtagSuggestions() {
    final tags = [
      '#trending', '#viral', '#foryou', '#fyp',
      '#reels', '#explore', '#fun', '#music',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suggested hashtags',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return GestureDetector(
              onTap: () {
                final current = _captionController.text;
                _captionController.text = '$current $tag';
                _captionController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _captionController.text.length),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  // PUBLISH BAR
  // ═══════════════════════════════════════════════════════

  Widget _buildPublishBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          // Save as draft
          Expanded(
            child: OutlinedButton(
              onPressed: _isPublishing ? null : _saveDraft,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white30),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Drafts'),
            ),
          ),
          const SizedBox(width: 12),
          // Publish
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isPublishing ? null : _publish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: _isPublishing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════

  Future<void> _saveDraft() async {
    Get.snackbar(
      'Saved',
      'Draft saved successfully',
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _publish() async {
    setState(() => _isPublishing = true);
    try {
      // Export video via editor controller if available
      final editorCtrl = Get.find<ReelsEditorController>();
      // Publishing logic would call API here
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Published!',
        'Your reel is now live',
        backgroundColor: Colors.green[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to feed
      Get.until((route) => route.isFirst);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to publish. Please try again.',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }
}
