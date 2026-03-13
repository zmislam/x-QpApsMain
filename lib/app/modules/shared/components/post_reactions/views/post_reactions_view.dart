// =============================================================================
// Post Reactions View — Facebook-style bottom sheet modal
// =============================================================================
// Redesigned 2026-03-14: Full-page Scaffold replaced with bottom-sheet-style
// layout. Shows reaction filter tabs (All | 👍 | ❤️ | 🤩 | 😄 | 😮 | 😢 | 😠)
// with counts, drag handle, and scrollable user list with avatar + reaction
// badge overlay — matching Facebook's reaction viewer design exactly.
//
// Can be opened as:
//   - Named route: Get.toNamed(Routes.REACTIONS, arguments: postId)
//   - Bottom sheet: ReactionsBottomSheet.show(context, postId)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../models/reaction_model.dart';
import '../../../../../models/user_id.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../../utils/post_utlis.dart';
import '../controllers/post_reactions_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ReactionsView — GetX routed page (preserves backward-compatible route)
//  Uses opaque:false in GetPage so the previous screen shows through.
//  DraggableScrollableSheet allows drag-to-dismiss.
// ─────────────────────────────────────────────────────────────────────────────
class ReactionsView extends GetView<ReactionsController> {
  const ReactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String postId = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearReactions();
      controller.getReactions(postId);
    });

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      body: _DraggableReactionsSheet(controller: controller),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Draggable sheet wrapper — handles drag-to-dismiss + tap-outside-to-close
// ─────────────────────────────────────────────────────────────────────────────
class _DraggableReactionsSheet extends StatefulWidget {
  final ReactionsController controller;
  const _DraggableReactionsSheet({required this.controller});

  @override
  State<_DraggableReactionsSheet> createState() =>
      _DraggableReactionsSheetState();
}

class _DraggableReactionsSheetState extends State<_DraggableReactionsSheet> {
  final DraggableScrollableController _dragController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _dragController.addListener(_onDrag);
  }

  void _onDrag() {
    // If dragged below 15% threshold, dismiss
    if (_dragController.isAttached && _dragController.size < 0.15) {
      Get.back();
    }
  }

  @override
  void dispose() {
    _dragController.removeListener(_onDrag);
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tap outside the sheet → close
      onTap: () => Get.back(),
      behavior: HitTestBehavior.opaque,
      child: DraggableScrollableSheet(
        controller: _dragController,
        initialChildSize: 0.55,
        minChildSize: 0.0,
        maxChildSize: 0.85,
        snap: true,
        snapSizes: const [0.55, 0.85],
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () {}, // Absorb taps on the sheet body
            child: _ReactionsSheetBody(
              controller: widget.controller,
              scrollController: scrollController,
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ReactionsBottomSheet — static helper to show as a modal bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class ReactionsBottomSheet {
  /// Show the Facebook-style reaction modal as a bottom sheet.
  /// Does NOT require GetX binding — creates its own controller.
  static Future<void> show(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _StandaloneReactionsSheet(postId: postId),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Standalone sheet (creates its own controller, for bottom-sheet usage)
// ─────────────────────────────────────────────────────────────────────────────
class _StandaloneReactionsSheet extends StatefulWidget {
  final String postId;
  const _StandaloneReactionsSheet({required this.postId});

  @override
  State<_StandaloneReactionsSheet> createState() =>
      _StandaloneReactionsSheetState();
}

class _StandaloneReactionsSheetState extends State<_StandaloneReactionsSheet> {
  late final ReactionsController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = ReactionsController();
    _ctrl.onInit();
    _ctrl.getReactions(widget.postId);
  }

  @override
  void dispose() {
    _ctrl.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StandaloneDraggableSheet(controller: _ctrl);
  }
}
class _StandaloneDraggableSheet extends StatefulWidget {
  final ReactionsController controller;
  const _StandaloneDraggableSheet({required this.controller});

  @override
  State<_StandaloneDraggableSheet> createState() => _StandaloneDraggableSheetState();
}

class _StandaloneDraggableSheetState extends State<_StandaloneDraggableSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.0,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.55, 0.85],
      expand: false,
      builder: (context, scrollController) {
        return _ReactionsSheetBody(
          controller: widget.controller,
          scrollController: scrollController,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Core sheet body — used by both route-based and bottom-sheet approaches
// ─────────────────────────────────────────────────────────────────────────────
class _ReactionsSheetBody extends StatefulWidget {
  final ReactionsController controller;
  final ScrollController? scrollController;
  const _ReactionsSheetBody({required this.controller, this.scrollController});

  @override
  State<_ReactionsSheetBody> createState() => _ReactionsSheetBodyState();
}

class _ReactionsSheetBodyState extends State<_ReactionsSheetBody> {
  int _selectedTabIndex = 0;

  // Tab definitions — only tabs with count > 0 are shown (except "All")
  static const List<_ReactionTabDef> _allTabs = [
    _ReactionTabDef(type: null, asset: null),  // "All"
    _ReactionTabDef(type: 'like', asset: 'assets/icon/reaction/like_icon.png'),
    _ReactionTabDef(type: 'love', asset: 'assets/icon/reaction/love_icon.png'),
    _ReactionTabDef(type: 'haha', asset: 'assets/icon/reaction/haha_icon.png'),
    _ReactionTabDef(type: 'wow', asset: 'assets/icon/reaction/wow_icon.png'),
    _ReactionTabDef(type: 'sad', asset: 'assets/icon/reaction/sad_icon.png'),
    _ReactionTabDef(type: 'angry', asset: 'assets/icon/reaction/angry_icon.png'),
  ];

  ReactionsController get c => widget.controller;

  List<ReactionModel> _listForType(String? type) {
    if (type == null) return c.reactionList.value;
    switch (type) {
      case 'like': return c.likeList.value;
      case 'love': return c.loveList.value;
      case 'haha': return c.hahaList.value;
      case 'wow': return c.wowList.value;
      case 'sad': return c.sadList.value;
      case 'angry': return c.angryList.value;
      case 'dislike': return c.unlikeList.value;
      default: return c.reactionList.value;
    }
  }

  List<_ReactionTabDef> _visibleTabs() {
    final visible = <_ReactionTabDef>[_allTabs[0]];
    for (int i = 1; i < _allTabs.length; i++) {
      if (_listForType(_allTabs[i].type).isNotEmpty) {
        visible.add(_allTabs[i]);
      }
    }
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF242526) : Colors.white;

    // When used inside DraggableScrollableSheet, the sheet controls sizing.
    // When used as a standalone bottom sheet, constrain height.
    final hasExternalScroll = widget.scrollController != null;

    return Container(
      constraints: hasExternalScroll
          ? const BoxConstraints()
          : BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.60),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ───────────────────────────────────────────
          _buildDragHandle(isDark),
          // ── Filter tabs ───────────────────────────────────────────
          Obx(() => _buildFilterTabs(isDark)),
          // ── Divider ───────────────────────────────────────────────
          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          // ── User list ─────────────────────────────────────────────
          Expanded(child: Obx(() => _buildUserList(isDark))),
        ],
      ),
    );
  }

  Widget _buildDragHandle(bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    final tabs = _visibleTabs();
    if (_selectedTabIndex >= tabs.length) _selectedTabIndex = 0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isActive = index == _selectedTabIndex;
          final count = _listForType(tab.type).length;

          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? PRIMARY_COLOR : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.asset != null) ...[
                    Image.asset(tab.asset!, width: 20, height: 20),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    tab.type == null ? '${'All'.tr} $count' : '$count',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? PRIMARY_COLOR
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserList(bool isDark) {
    if (c.isReactionLoding.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: PRIMARY_COLOR),
        ),
      );
    }

    final tabs = _visibleTabs();
    if (_selectedTabIndex >= tabs.length) return const SizedBox.shrink();
    final selectedType = tabs[_selectedTabIndex].type;
    final list = _listForType(selectedType);

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'No reactions yet'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final ReactionModel model = list[index];
        final UserIdModel? user = model.user_id;
        if (user == null) return const SizedBox.shrink();

        final name = '${user.first_name ?? ''} ${user.last_name ?? ''}'.trim();
        final profilePic = (user.profile_pic ?? '').formatedProfileUrl;
        final reactionAsset = getReactionIconPath(model.reaction_type ?? '');

        return _FbReactionUserTile(
          name: name,
          profilePicUrl: profilePic,
          reactionAsset: reactionAsset,
          isDark: isDark,
          onTap: () {
            ProfileNavigator.navigateToProfile(
              username: user.username ?? '',
              isFromReels: 'false',
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Facebook-style user tile — circular avatar + reaction badge bottom-right
// ─────────────────────────────────────────────────────────────────────────────
class _FbReactionUserTile extends StatelessWidget {
  final String name;
  final String profilePicUrl;
  final String reactionAsset;
  final bool isDark;
  final VoidCallback onTap;

  const _FbReactionUserTile({
    required this.name,
    required this.profilePicUrl,
    required this.reactionAsset,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // ── Avatar with reaction badge ───────────────────────────
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        profilePicUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          size: 28,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  // ── Reaction badge (bottom-right of avatar) ────────
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF242526) : Colors.white,
                        border: Border.all(
                          color: isDark ? const Color(0xFF242526) : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          reactionAsset,
                          width: 16,
                          height: 16,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // ── User name ────────────────────────────────────────────
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab definition
// ─────────────────────────────────────────────────────────────────────────────
class _ReactionTabDef {
  final String? type; // null = "All"
  final String? asset;
  const _ReactionTabDef({required this.type, required this.asset});
}
