import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reel_v2_model.dart';
import '../services/reels_v2_api_service.dart';
import '../utils/reel_enums.dart';

/// Reel detail view — displays the list of reactions on a reel.
/// Shows who reacted with which emoji, grouped by reaction type.
class ReelDetailView extends StatefulWidget {
  final ReelV2Model reel;

  const ReelDetailView({super.key, required this.reel});

  @override
  State<ReelDetailView> createState() => _ReelDetailViewState();
}

class _ReelDetailViewState extends State<ReelDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _api = Get.find<ReelsV2ApiService>();

  final _tabs = <_ReactionTab>[
    _ReactionTab(label: 'All', type: null),
    ...ReelReactionType.values.map(
      (t) => _ReactionTab(label: t.emoji, type: t),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.55,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Reactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Tabs for reaction types
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
          ),

          const Divider(color: Colors.white12, height: 1),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                return _ReactionList(
                  reelId: widget.reel.id ?? '',
                  reactionType: tab.type,
                  api: _api,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReactionTab {
  final String label;
  final ReelReactionType? type;
  _ReactionTab({required this.label, this.type});
}

/// A paginated list of users who reacted with a given type (or all).
class _ReactionList extends StatefulWidget {
  final String reelId;
  final ReelReactionType? reactionType;
  final ReelsV2ApiService api;

  const _ReactionList({
    required this.reelId,
    required this.reactionType,
    required this.api,
  });

  @override
  State<_ReactionList> createState() => _ReactionListState();
}

class _ReactionListState extends State<_ReactionList>
    with AutomaticKeepAliveClientMixin {
  final _reactions = <Map<String, dynamic>>[];
  bool _loading = true;
  String? _cursor;
  bool _hasMore = true;
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadReactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_loading &&
        _hasMore) {
      _loadReactions();
    }
  }

  Future<void> _loadReactions() async {
    if (!_hasMore && _cursor != null) return;
    setState(() => _loading = true);

    try {
      // Use getReel to fetch reaction data — actual endpoint may differ
      final res = await widget.api.getReel(widget.reelId);
      if (res.isSuccessful == true && res.data != null) {
        final data = res.data as Map<String, dynamic>?;
        final reactions = data?['reactions'] as List?;
        if (reactions != null) {
          for (final r in reactions) {
            if (r is Map<String, dynamic>) {
              if (widget.reactionType == null ||
                  r['reaction_type'] == widget.reactionType?.value) {
                _reactions.add(r);
              }
            }
          }
        }
        _hasMore = false; // Single fetch for now
      }
    } catch (_) {}

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_loading && _reactions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      );
    }

    if (_reactions.isEmpty) {
      return const Center(
        child: Text(
          'No reactions yet',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _reactions.length + (_hasMore ? 1 : 0),
      itemBuilder: (ctx, index) {
        if (index >= _reactions.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white54),
            ),
          );
        }

        final r = _reactions[index];
        final userName = r['user_name'] as String? ?? 'User';
        final avatar = r['user_avatar'] as String?;
        final type = r['reaction_type'] as String? ?? 'like';
        final emoji =
            ReelReactionType.values
                .cast<ReelReactionType?>()
                .firstWhere(
                  (e) => e?.value == type,
                  orElse: () => null,
                )
                ?.emoji ??
            '❤️';

        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[800],
            backgroundImage: avatar != null ? NetworkImage(avatar) : null,
            child: avatar == null
                ? const Icon(Icons.person, color: Colors.white54, size: 20)
                : null,
          ),
          title: Text(
            userName,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          trailing: Text(emoji, style: const TextStyle(fontSize: 20)),
          onTap: () {
            final userId = r['user_id'] as String?;
            if (userId != null) {
              Get.toNamed('/profile/$userId');
            }
          },
        );
      },
    );
  }
}
