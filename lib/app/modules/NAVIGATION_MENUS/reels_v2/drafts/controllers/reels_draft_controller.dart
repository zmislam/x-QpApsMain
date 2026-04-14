import 'package:get/get.dart';
import '../../services/reels_v2_api_service.dart';
import '../../models/reel_draft_model.dart';

/// Reels V2 Draft Controller — manages draft grid, resume, edit, delete.
class ReelsDraftController extends GetxController {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();

  final RxList<ReelDraftModel> drafts = <ReelDraftModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSelectionMode = false.obs;
  final RxSet<String> selectedDraftIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDrafts();
  }

  // ─── Load Drafts ────────────────────────────────────

  Future<void> loadDrafts() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getDrafts();
      if (response.data != null && (response.data as Map)['drafts'] != null) {
        drafts.value = ((response.data as Map)['drafts'] as List)
            .map((e) => ReelDraftModel.fromMap(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load drafts');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Resume Draft ───────────────────────────────────

  void resumeDraft(ReelDraftModel draft) {
    // Navigate back to editor with draft data
    Get.toNamed('/reels-v2-editor', arguments: {
      'draft': draft.toMap(),
      'draftId': draft.id,
    });
  }

  // ─── Edit Draft (go to publish screen) ──────────────

  void editDraft(ReelDraftModel draft) {
    Get.toNamed('/reels-v2-publish', arguments: {
      'videoPath': draft.segments.isNotEmpty ? draft.segments.first : null,
      'soundId': draft.soundId,
      'editingState': draft.editingState,
      'draftId': draft.id,
    });
  }

  // ─── Delete Draft ───────────────────────────────────

  Future<void> deleteDraft(String draftId) async {
    try {
      await _apiService.deleteDraft(draftId);
      drafts.removeWhere((d) => d.id == draftId);
      Get.snackbar('Deleted', 'Draft removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete draft');
    }
  }

  // ─── Bulk Delete ────────────────────────────────────

  Future<void> deleteSelected() async {
    final ids = selectedDraftIds.toList();
    for (final id in ids) {
      await deleteDraft(id);
    }
    selectedDraftIds.clear();
    isSelectionMode.value = false;
  }

  // ─── Selection ──────────────────────────────────────

  void toggleSelection(String draftId) {
    if (selectedDraftIds.contains(draftId)) {
      selectedDraftIds.remove(draftId);
    } else {
      selectedDraftIds.add(draftId);
    }
    if (selectedDraftIds.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  void enterSelectionMode(String draftId) {
    isSelectionMode.value = true;
    selectedDraftIds.add(draftId);
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedDraftIds.clear();
  }
}
