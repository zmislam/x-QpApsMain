import 'package:flutter/material.dart';
import '../../controllers/reels_editor_controller.dart';

/// Sticker picker sheet with tabs: GIF, Emoji, Interactive.
/// GIF stickers via search (Giphy integration placeholder).
/// Emoji grid with frequently used.
/// Interactive stickers: poll, quiz, countdown, mention, location, hashtag.
class StickerPicker extends StatefulWidget {
  final void Function(StickerOverlay sticker) onStickerSelected;

  const StickerPicker({
    super.key,
    required this.onStickerSelected,
  });

  @override
  State<StickerPicker> createState() => _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          // Tab bar
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(text: 'GIFs'),
              Tab(text: 'Emoji'),
              Tab(text: 'Interactive'),
            ],
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGifTab(),
                _buildEmojiTab(),
                _buildInteractiveTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // GIF TAB
  // ═══════════════════════════════════════════════════════

  Widget _buildGifTab() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search GIFs...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
              filled: true,
              fillColor: Colors.grey[800],
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // GIF grid placeholder (Giphy API integration)
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onStickerSelected(StickerOverlay(
                    id: 'gif_${DateTime.now().millisecondsSinceEpoch}',
                    type: StickerType.gif,
                    url: 'gif_placeholder_$index',
                    position: const Offset(0.5, 0.5),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.gif, color: Colors.white38, size: 32),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  // EMOJI TAB
  // ═══════════════════════════════════════════════════════

  Widget _buildEmojiTab() {
    const emojis = [
      '😀', '😂', '🥰', '😎', '🤩', '🥳', '😢', '😡',
      '🔥', '❤️', '💯', '👏', '🎉', '✨', '🌟', '💪',
      '🙏', '👀', '🤔', '😱', '🤯', '💀', '👻', '🎭',
      '🌈', '🦋', '🌺', '🍕', '🎵', '🎸', '⚡', '🏆',
      '🎯', '🚀', '💎', '🦄', '🐱', '🐶', '🌙', '☀️',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onStickerSelected(StickerOverlay(
              id: 'emoji_${DateTime.now().millisecondsSinceEpoch}',
              type: StickerType.emoji,
              url: emojis[index],
              position: const Offset(0.5, 0.5),
            ));
          },
          child: Center(
            child: Text(
              emojis[index],
              style: const TextStyle(fontSize: 28),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════
  // INTERACTIVE TAB
  // ═══════════════════════════════════════════════════════

  Widget _buildInteractiveTab() {
    final items = [
      _InteractiveItem(StickerType.poll, Icons.poll, 'Poll', Colors.purple),
      _InteractiveItem(StickerType.quiz, Icons.quiz, 'Quiz', Colors.orange),
      _InteractiveItem(
          StickerType.mention, Icons.alternate_email, 'Mention', Colors.blue),
      _InteractiveItem(
          StickerType.hashtag, Icons.tag, 'Hashtag', Colors.teal),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _createInteractiveSticker(item.type),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
          ),
        );
      },
    );
  }

  void _createInteractiveSticker(StickerType type) {
    Map<String, dynamic>? interactiveData;

    switch (type) {
      case StickerType.poll:
        interactiveData = {
          'question': 'Ask a question...',
          'options': ['Option 1', 'Option 2'],
        };
        break;
      case StickerType.quiz:
        interactiveData = {
          'question': 'Quiz question...',
          'options': ['Answer 1', 'Answer 2', 'Answer 3'],
          'correctIndex': 0,
        };
        break;
      case StickerType.mention:
        interactiveData = {'username': ''};
        break;
      case StickerType.hashtag:
        interactiveData = {'tag': ''};
        break;
      default:
        break;
    }

    widget.onStickerSelected(StickerOverlay(
      id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      url: type.name,
      position: const Offset(0.5, 0.4),
      interactiveData: interactiveData,
    ));
  }
}

class _InteractiveItem {
  final StickerType type;
  final IconData icon;
  final String label;
  final Color color;
  const _InteractiveItem(this.type, this.icon, this.label, this.color);
}
