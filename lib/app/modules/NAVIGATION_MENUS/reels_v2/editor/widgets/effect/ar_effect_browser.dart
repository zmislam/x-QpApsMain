import 'package:flutter/material.dart';
import '../../models/reel_filter_model.dart';

/// AR face/background effects browser with categories and previews.
/// Supports minimum 10 AR effects across face, background, world, beauty.
class AREffectBrowser extends StatefulWidget {
  final String? selectedEffectId;
  final ValueChanged<AREffect> onSelectEffect;
  final VoidCallback onClearEffect;

  const AREffectBrowser({
    super.key,
    this.selectedEffectId,
    required this.onSelectEffect,
    required this.onClearEffect,
  });

  @override
  State<AREffectBrowser> createState() => _AREffectBrowserState();
}

class _AREffectBrowserState extends State<AREffectBrowser>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';

  static const List<String> _categories = [
    'all',
    'face',
    'beauty',
    'background',
    'world',
  ];

  // 10+ built-in AR effects
  static const List<AREffect> _builtInEffects = [
    AREffect(id: 'ar_dog_ears', name: 'Dog Ears', category: 'face'),
    AREffect(id: 'ar_cat_face', name: 'Cat Face', category: 'face'),
    AREffect(id: 'ar_crown', name: 'Crown', category: 'face'),
    AREffect(id: 'ar_sunglasses', name: 'Sunglasses', category: 'face'),
    AREffect(id: 'ar_butterfly', name: 'Butterfly', category: 'face'),
    AREffect(id: 'ar_smooth_skin', name: 'Smooth Skin', category: 'beauty'),
    AREffect(id: 'ar_big_eyes', name: 'Big Eyes', category: 'beauty'),
    AREffect(id: 'ar_slim_face', name: 'Slim Face', category: 'beauty'),
    AREffect(id: 'ar_teeth_whiten', name: 'Whiten Teeth', category: 'beauty'),
    AREffect(id: 'ar_bg_blur', name: 'BG Blur', category: 'background'),
    AREffect(id: 'ar_bg_neon', name: 'Neon Glow', category: 'background'),
    AREffect(id: 'ar_bg_stars', name: 'Stars', category: 'background'),
    AREffect(id: 'ar_3d_hearts', name: '3D Hearts', category: 'world'),
    AREffect(id: 'ar_confetti', name: 'Confetti', category: 'world'),
    AREffect(id: 'ar_snow', name: 'Snow', category: 'world'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedCategory = _categories[_tabController.index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AREffect> get _filteredEffects {
    if (_selectedCategory == 'all') return _builtInEffects;
    return _builtInEffects.where((e) => e.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 320),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AR Effects',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.selectedEffectId != null)
                  TextButton(
                    onPressed: widget.onClearEffect,
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.purple,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: _categories
                .map((c) => Tab(text: c[0].toUpperCase() + c.substring(1)))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Effects grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredEffects.length,
              itemBuilder: (context, index) {
                final effect = _filteredEffects[index];
                final isSelected = widget.selectedEffectId == effect.id;
                return _AREffectTile(
                  effect: effect,
                  isSelected: isSelected,
                  onTap: () => widget.onSelectEffect(effect),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AREffectTile extends StatelessWidget {
  final AREffect effect;
  final bool isSelected;
  final VoidCallback onTap;

  const _AREffectTile({
    required this.effect,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _categoryIcon {
    switch (effect.category) {
      case 'face':
        return Icons.face;
      case 'beauty':
        return Icons.auto_fix_high;
      case 'background':
        return Icons.wallpaper;
      case 'world':
        return Icons.public;
      default:
        return Icons.auto_awesome;
    }
  }

  Color get _categoryColor {
    switch (effect.category) {
      case 'face':
        return Colors.purpleAccent;
      case 'beauty':
        return Colors.pinkAccent;
      case 'background':
        return Colors.blueAccent;
      case 'world':
        return Colors.tealAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? _categoryColor.withOpacity(0.3) : Colors.white10,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _categoryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              _categoryIcon,
              color: isSelected ? _categoryColor : Colors.white54,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            effect.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
