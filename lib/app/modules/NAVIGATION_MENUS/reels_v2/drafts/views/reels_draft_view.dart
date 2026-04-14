import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_draft_controller.dart';
import '../widgets/draft_card.dart';

/// Reels V2 Drafts View — grid of saved drafts with resume, edit, delete.
class ReelsDraftView extends GetView<ReelsDraftController> {
  const ReelsDraftView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drafts'),
        actions: [
          Obx(() => controller.isSelectionMode.value
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: controller.exitSelectionMode,
                      child: const Text('Cancel'),
                    ),
                    IconButton(
                      onPressed: controller.selectedDraftIds.isNotEmpty
                          ? () => _confirmDelete(context)
                          : null,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.drafts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.drafts_outlined,
                    size: 64, color: Colors.grey[600]),
                const SizedBox(height: 16),
                const Text(
                  'No drafts yet',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your saved and auto-saved reels will appear here',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadDrafts,
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 9 / 16,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: controller.drafts.length,
            itemBuilder: (context, index) {
              final draft = controller.drafts[index];
              return Obx(() => DraftCard(
                    draft: draft,
                    isSelected: controller.selectedDraftIds
                        .contains(draft.id),
                    isSelectionMode: controller.isSelectionMode.value,
                    onTap: () {
                      if (controller.isSelectionMode.value) {
                        controller.toggleSelection(draft.id!);
                      } else {
                        _showDraftActions(context, draft);
                      }
                    },
                    onLongPress: () {
                      if (!controller.isSelectionMode.value) {
                        controller.enterSelectionMode(draft.id!);
                      }
                    },
                  ));
            },
          ),
        );
      }),
    );
  }

  void _showDraftActions(BuildContext context, dynamic draft) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Resume Editing'),
              onTap: () {
                Navigator.pop(ctx);
                controller.resumeDraft(draft);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit & Publish'),
              onTap: () {
                Navigator.pop(ctx);
                controller.editDraft(draft);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmSingleDelete(context, draft.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSingleDelete(BuildContext context, String draftId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Draft?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteDraft(draftId);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            'Delete ${controller.selectedDraftIds.length} drafts?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteSelected();
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
