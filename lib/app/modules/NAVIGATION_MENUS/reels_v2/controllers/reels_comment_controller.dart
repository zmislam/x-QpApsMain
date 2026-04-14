import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reel_comment_model.dart';
import '../services/reels_v2_api_service.dart';
import '../utils/reel_constants.dart';
import '../utils/reel_enums.dart';

/// Comment controller for Reels V2.
/// Manages comment list, threading, pagination, sorting, pinning, reactions.
class ReelsCommentController extends GetxController {
  late final ReelsV2ApiService _apiService;

  // ─── State ─────────────────────────────────────────────
  final RxList<ReelCommentModel> comments = <ReelCommentModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool hasMore = true.obs;
  final Rx<CommentSortOption> sortOption = CommentSortOption.top.obs;
  final RxString activeReelId = ''.obs;
  String? _nextCursor;

  // Reply state
  final RxnString replyingToCommentId = RxnString(null);
  final RxnString replyingToUsername = RxnString(null);

  // Mention autocomplete state
  final RxBool showMentionSuggestions = false.obs;
  final RxList<CommentAuthorModel> mentionSuggestions = <CommentAuthorModel>[].obs;
  final RxString mentionQuery = ''.obs;

  // Text controller
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ReelsV2ApiService>();
  }

  /// Load comments for a reel.
  Future<void> loadComments(String reelId) async {
    activeReelId.value = reelId;
    isLoading.value = true;
    _nextCursor = null;
    comments.clear();

    try {
      final response = await _apiService.getComments(
        reelId,
        sort: sortOption.value.value,
        limit: ReelConstants.commentsPageSize,
      );

      if (response.isSuccessful && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['comments'] as List? ?? [];
        comments.assignAll(
          list.map((c) => ReelCommentModel.fromMap(c as Map<String, dynamic>)),
        );
        _nextCursor = data['next_cursor'] as String?;
        hasMore.value = _nextCursor != null;
      }
    } catch (e) {
      debugPrint('[ReelsComment] Error loading: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more comments (pagination).
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || _nextCursor == null) return;
    isLoadingMore.value = true;

    try {
      final response = await _apiService.getComments(
        activeReelId.value,
        cursor: _nextCursor,
        sort: sortOption.value.value,
        limit: ReelConstants.commentsPageSize,
      );

      if (response.isSuccessful && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['comments'] as List? ?? [];
        comments.addAll(
          list.map((c) => ReelCommentModel.fromMap(c as Map<String, dynamic>)),
        );
        _nextCursor = data['next_cursor'] as String?;
        hasMore.value = _nextCursor != null;
      }
    } catch (e) {
      debugPrint('[ReelsComment] Error loading more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Change sort order.
  void changeSort(CommentSortOption option) {
    if (option == sortOption.value) return;
    sortOption.value = option;
    loadComments(activeReelId.value);
  }

  /// Submit a new comment or reply.
  Future<void> submitComment() async {
    final text = textController.text.trim();
    if (text.isEmpty || activeReelId.value.isEmpty) return;
    isSubmitting.value = true;

    try {
      final data = <String, dynamic>{
        'text': text,
      };

      // Extract mentions from text
      final mentions = RegExp(r'@(\w+)').allMatches(text).map((m) => m.group(1)!).toList();
      if (mentions.isNotEmpty) {
        data['mentioned_user_ids'] = mentions;
      }

      // Check if it's a GIF URL
      if (text.startsWith('http') && (text.contains('.gif') || text.contains('giphy.com'))) {
        data['gif_url'] = text;
        data['text'] = '';
      }

      if (replyingToCommentId.value != null) {
        // Reply to existing comment
        final response = await _apiService.replyToComment(
          replyingToCommentId.value!,
          data,
        );

        if (response.isSuccessful && response.data != null) {
          final reply = ReelCommentModel.fromMap(response.data as Map<String, dynamic>);
          // Find parent comment and add reply
          final parentIndex = comments.indexWhere(
            (c) => c.id == replyingToCommentId.value,
          );
          if (parentIndex != -1) {
            comments[parentIndex].replyCount = (comments[parentIndex].replyCount ?? 0) + 1;
            comments[parentIndex].replies ??= [];
            comments[parentIndex].replies!.add(reply);
            comments.refresh();
          }
        }
        cancelReply();
      } else {
        // New top-level comment
        final response = await _apiService.addComment(activeReelId.value, data);

        if (response.isSuccessful && response.data != null) {
          final comment = ReelCommentModel.fromMap(response.data as Map<String, dynamic>);
          comments.insert(0, comment);
        }
      }

      textController.clear();
    } catch (e) {
      debugPrint('[ReelsComment] Error submitting: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Start replying to a comment.
  void replyTo(ReelCommentModel comment) {
    replyingToCommentId.value = comment.id;
    replyingToUsername.value = comment.user?.displayName;
    textController.text = '@${comment.user?.firstName ?? ''} ';
    focusNode.requestFocus();
  }

  /// Cancel reply mode.
  void cancelReply() {
    replyingToCommentId.value = null;
    replyingToUsername.value = null;
  }

  /// Load replies for a specific comment.
  Future<void> loadReplies(String commentId) async {
    try {
      final response = await _apiService.getCommentReplies(commentId);

      if (response.isSuccessful && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['replies'] as List? ?? [];
        final replies = list
            .map((r) => ReelCommentModel.fromMap(r as Map<String, dynamic>))
            .toList();

        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          comments[index].replies = replies;
          comments.refresh();
        }
      }
    } catch (e) {
      debugPrint('[ReelsComment] Error loading replies: $e');
    }
  }

  /// Pin/unpin a comment (creator only).
  Future<void> togglePin(String commentId) async {
    try {
      await _apiService.pinComment(commentId);

      final index = comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        comments[index].isPinned = !(comments[index].isPinned ?? false);
        comments.refresh();
      }
    } catch (e) {
      debugPrint('[ReelsComment] Error toggling pin: $e');
    }
  }

  /// React to a comment.
  Future<void> reactToComment(String commentId, ReelReactionType type) async {
    try {
      await _apiService.commentReaction(commentId, type.value);

      final index = comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        if (comments[index].myReaction == type.value) {
          comments[index].myReaction = null;
          comments[index].likeCount = (comments[index].likeCount ?? 1) - 1;
        } else {
          if (comments[index].myReaction == null) {
            comments[index].likeCount = (comments[index].likeCount ?? 0) + 1;
          }
          comments[index].myReaction = type.value;
        }
        comments.refresh();
      }
    } catch (e) {
      debugPrint('[ReelsComment] Error reacting: $e');
    }
  }

  /// Delete a comment.
  Future<void> deleteComment(String commentId) async {
    try {
      final response = await _apiService.deleteComment(commentId);
      if (response.isSuccessful) {
        comments.removeWhere((c) => c.id == commentId);
      }
    } catch (e) {
      debugPrint('[ReelsComment] Error deleting: $e');
    }
  }

  /// Handle mention autocomplete (@mention detection in text).
  void onTextChanged(String text) {
    final cursorPos = textController.selection.baseOffset;
    if (cursorPos <= 0) {
      showMentionSuggestions.value = false;
      return;
    }

    final textBefore = text.substring(0, cursorPos);
    final mentionMatch = RegExp(r'@(\w*)$').firstMatch(textBefore);

    if (mentionMatch != null && mentionMatch.group(1)!.isNotEmpty) {
      mentionQuery.value = mentionMatch.group(1)!;
      showMentionSuggestions.value = true;
      // Suggestions would be fetched from a user search API
    } else {
      showMentionSuggestions.value = false;
    }
  }

  /// Insert a mention into the text.
  void insertMention(CommentAuthorModel user) {
    final currentText = textController.text;
    final cursorPos = textController.selection.baseOffset;
    final textBefore = currentText.substring(0, cursorPos);
    final textAfter = currentText.substring(cursorPos);

    final mentionMatch = RegExp(r'@\w*$').firstMatch(textBefore);
    if (mentionMatch != null) {
      final newText =
          '${textBefore.substring(0, mentionMatch.start)}@${user.firstName ?? ''} $textAfter';
      textController.text = newText;
      textController.selection = TextSelection.collapsed(
        offset: mentionMatch.start + (user.firstName?.length ?? 0) + 2,
      );
    }
    showMentionSuggestions.value = false;
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
