import 'package:flutter/material.dart';
import '../../models/reel_template_model.dart';

/// Template browser — trending templates with preview, beat markers,
/// and auto-place clips at beat timestamps.
class TemplateBrowser extends StatefulWidget {
  final ValueChanged<ReelTemplate> onSelectTemplate;

  const TemplateBrowser({
    super.key,
    required this.onSelectTemplate,
  });

  @override
  State<TemplateBrowser> createState() => _TemplateBrowserState();
}

class _TemplateBrowserState extends State<TemplateBrowser> {
  String _selectedCategory = 'trending';
  final List<ReelTemplate> _templates = _sampleTemplates;

  static const List<String> _categories = [
    'trending',
    'new',
    'transitions',
    'beats',
    'storytelling',
    'saved',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
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
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  'Templates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Category tabs
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white10,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        cat[0].toUpperCase() + cat.substring(1),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Template grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 9 / 16,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                return _TemplateTile(
                  template: template,
                  onTap: () => _showTemplatePreview(template),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTemplatePreview(ReelTemplate template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _TemplatePreviewSheet(
        template: template,
        onUse: () {
          Navigator.pop(context);
          widget.onSelectTemplate(template);
        },
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  final ReelTemplate template;
  final VoidCallback onTap;

  const _TemplateTile({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.4),
              Colors.blue.withOpacity(0.4),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Template info
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${template.clipCount} clips · ${_formatDuration(template.durationMs)}',
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                ],
              ),
            ),
            // Trending badge
            if (template.isTrending)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 10)),
                      SizedBox(width: 2),
                      Text(
                        'Trending',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            // Usage count
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_formatCount(template.usageCount)} uses',
                  style: const TextStyle(color: Colors.white60, fontSize: 9),
                ),
              ),
            ),
            // Play icon
            const Center(
              child: Icon(Icons.play_circle_outline, color: Colors.white54, size: 40),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int ms) {
    final seconds = ms ~/ 1000;
    return '${seconds}s';
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }
}

class _TemplatePreviewSheet extends StatelessWidget {
  final ReelTemplate template;
  final VoidCallback onUse;

  const _TemplatePreviewSheet({
    required this.template,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template name
          Text(
            template.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (template.authorName != null)
            Text(
              'by ${template.authorName}',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          const SizedBox(height: 12),
          // Stats row
          Row(
            children: [
              _StatBadge(icon: Icons.movie_creation, label: '${template.clipCount} clips'),
              const SizedBox(width: 12),
              _StatBadge(
                  icon: Icons.timer, label: '${template.durationMs ~/ 1000}s'),
              const SizedBox(width: 12),
              _StatBadge(
                  icon: Icons.music_note, label: template.soundName ?? 'No sound'),
              const SizedBox(width: 12),
              _StatBadge(
                  icon: Icons.people,
                  label: '${template.usageCount} uses'),
            ],
          ),
          const SizedBox(height: 12),
          // Beat markers preview
          if (template.beatMarkers.isNotEmpty) ...[
            const Text(
              'Beat Markers',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30,
              child: Stack(
                children: [
                  // Track background
                  Container(
                    height: 4,
                    margin: const EdgeInsets.only(top: 13),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Beat dots
                  ...template.beatMarkers.map((beat) {
                    final progress = template.durationMs > 0
                        ? beat.timestampMs / template.durationMs
                        : 0.0;
                    return Positioned(
                      left: progress * (MediaQuery.of(context).size.width - 64),
                      top: beat.type == 'drop' ? 4 : 8,
                      child: Container(
                        width: beat.type == 'drop' ? 10 : 6,
                        height: beat.type == 'drop' ? 10 : 6,
                        decoration: BoxDecoration(
                          color: beat.type == 'drop'
                              ? Colors.amber
                              : beat.type == 'transition'
                                  ? Colors.purpleAccent
                                  : Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Use template button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onUse,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Use This Template',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white54),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}

// ─── Sample Templates ────────────────────────────────────────

final List<ReelTemplate> _sampleTemplates = [
  ReelTemplate(
    id: 'tpl_fast_cuts',
    name: 'Fast Cuts',
    authorName: 'QP Official',
    durationMs: 15000,
    clipCount: 5,
    isTrending: true,
    usageCount: 125000,
    beatMarkers: [
      const BeatMarker(timestampMs: 0, type: 'beat'),
      const BeatMarker(timestampMs: 3000, type: 'beat'),
      const BeatMarker(timestampMs: 6000, type: 'drop', intensity: 1.0),
      const BeatMarker(timestampMs: 9000, type: 'beat'),
      const BeatMarker(timestampMs: 12000, type: 'transition'),
    ],
    clipSlots: [
      const TemplateClipSlot(index: 0, startMs: 0, durationMs: 3000),
      const TemplateClipSlot(index: 1, startMs: 3000, durationMs: 3000, transitionType: 'fade'),
      const TemplateClipSlot(index: 2, startMs: 6000, durationMs: 3000, transitionType: 'zoom'),
      const TemplateClipSlot(index: 3, startMs: 9000, durationMs: 3000, transitionType: 'slide'),
      const TemplateClipSlot(index: 4, startMs: 12000, durationMs: 3000, transitionType: 'dissolve'),
    ],
  ),
  ReelTemplate(
    id: 'tpl_slow_reveal',
    name: 'Slow Reveal',
    authorName: 'QP Official',
    durationMs: 30000,
    clipCount: 3,
    isTrending: true,
    usageCount: 89000,
    beatMarkers: [
      const BeatMarker(timestampMs: 0, type: 'beat'),
      const BeatMarker(timestampMs: 10000, type: 'transition'),
      const BeatMarker(timestampMs: 20000, type: 'drop', intensity: 1.0),
    ],
    clipSlots: [
      const TemplateClipSlot(index: 0, startMs: 0, durationMs: 10000),
      const TemplateClipSlot(index: 1, startMs: 10000, durationMs: 10000, transitionType: 'fade'),
      const TemplateClipSlot(index: 2, startMs: 20000, durationMs: 10000, transitionType: 'dissolve'),
    ],
  ),
  ReelTemplate(
    id: 'tpl_day_in_life',
    name: 'Day in Life',
    authorName: 'Creators Hub',
    durationMs: 60000,
    clipCount: 8,
    usageCount: 52000,
    beatMarkers: [
      const BeatMarker(timestampMs: 0, type: 'beat'),
      const BeatMarker(timestampMs: 7500, type: 'beat'),
      const BeatMarker(timestampMs: 15000, type: 'beat'),
      const BeatMarker(timestampMs: 22500, type: 'drop', intensity: 0.8),
      const BeatMarker(timestampMs: 30000, type: 'beat'),
      const BeatMarker(timestampMs: 37500, type: 'transition'),
      const BeatMarker(timestampMs: 45000, type: 'beat'),
      const BeatMarker(timestampMs: 52500, type: 'drop', intensity: 1.0),
    ],
    clipSlots: List.generate(
      8,
      (i) => TemplateClipSlot(
        index: i,
        startMs: i * 7500,
        durationMs: 7500,
        transitionType: i % 2 == 0 ? 'fade' : 'slide',
      ),
    ),
  ),
  ReelTemplate(
    id: 'tpl_before_after',
    name: 'Before/After',
    authorName: 'QP Official',
    durationMs: 10000,
    clipCount: 2,
    isTrending: true,
    usageCount: 200000,
    beatMarkers: [
      const BeatMarker(timestampMs: 0, type: 'beat'),
      const BeatMarker(timestampMs: 5000, type: 'drop', intensity: 1.0),
    ],
    clipSlots: [
      const TemplateClipSlot(index: 0, startMs: 0, durationMs: 5000),
      const TemplateClipSlot(index: 1, startMs: 5000, durationMs: 5000, transitionType: 'zoom'),
    ],
  ),
];
