// =============================================================================
// Feeds Controller — Manages state for the dedicated Feeds page
// =============================================================================
// Tabs: All (latest) | Favourites (for_you) | Friends | Groups | Pages | Explore
//
// - All / Favourites / Friends → edgerank/feed cursor-based
// - Groups → get-all-groups-post offset-based
// - Pages → get-all-pages-post offset-based
// - Explore → explore/feed cursor-based
//
// Created: 2026-03-14
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/api_response.dart';
import '../../../../models/comment_model.dart';
import '../../../../models/post.dart';
import '../../../../models/user.dart';
import '../../../../repository/post_repository.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/post_utlis.dart';
import '../repository/feeds_repository.dart';

/// Tab definitions — keys used internally for state management.
enum FeedsTab { all, favourites, friends, groups, pages, explore }

class FeedsController extends GetxController with GetTickerProviderStateMixin {
  final FeedsRepository _feedsRepo = FeedsRepository();
  final PostRepository _postRepo = PostRepository();
  final ApiCommunication _apiCommunication = ApiCommunication();

  late UserModel userModel;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  Rx<List<XFile>> xfiles = Rx([]);

  // ── Tab controller ──
  late TabController tabController;
  final Rx<FeedsTab> activeTab = FeedsTab.all.obs;

  static const tabOrder = [
    FeedsTab.all,
    FeedsTab.favourites,
    FeedsTab.friends,
    FeedsTab.groups,
    FeedsTab.pages,
    FeedsTab.explore,
  ];

  static const _tabLabels = {
    FeedsTab.all: 'All',
    FeedsTab.favourites: 'Favourites',
    FeedsTab.friends: 'Friends',
    FeedsTab.groups: 'Groups',
    FeedsTab.pages: 'Pages',
    FeedsTab.explore: 'Explore',
  };

  static String tabLabel(FeedsTab tab) => _tabLabels[tab] ?? '';

  // ── Per-tab state ──
  final Map<FeedsTab, RxList<PostModel>> posts = {};
  final Map<FeedsTab, RxBool> isLoading = {};
  final Map<FeedsTab, RxBool> isLoadingMore = {};
  final Map<FeedsTab, RxBool> exhausted = {};

  // Cursor tabs (All, Favourites, Friends, Explore)
  final Map<FeedsTab, String?> _cursors = {};
  final Map<FeedsTab, int> _sessionSeeds = {};

  // Offset tabs (Groups, Pages)
  final Map<FeedsTab, int> _pageNos = {};
  final Map<FeedsTab, int> _pageCounts = {};

  // Scroll controllers per tab
  final Map<FeedsTab, ScrollController> scrollControllers = {};

  // ── Init flag to fetch only once per tab ──
  final Set<FeedsTab> _initialized = {};

  @override
  void onInit() {
    super.onInit();

    userModel = LoginCredential().getUserData();
    commentController = TextEditingController();
    commentReplyController = TextEditingController();

    tabController = TabController(length: tabOrder.length, vsync: this);
    tabController.addListener(_onTabChanged);

    // Initialize per-tab state
    for (final tab in tabOrder) {
      posts[tab] = <PostModel>[].obs;
      isLoading[tab] = true.obs;
      isLoadingMore[tab] = false.obs;
      exhausted[tab] = false.obs;
      _cursors[tab] = null;
      _sessionSeeds[tab] = DateTime.now().millisecondsSinceEpoch;
      _pageNos[tab] = 1;
      _pageCounts[tab] = 999;
      scrollControllers[tab] = ScrollController();
      scrollControllers[tab]!.addListener(() => _onScroll(tab));
    }

    // Load initial tab
    _fetchTab(FeedsTab.all, isInitial: true);
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    for (final sc in scrollControllers.values) {
      sc.dispose();
    }
    commentController.dispose();
    commentReplyController.dispose();
    _feedsRepo.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Tab switching
  // ─────────────────────────────────────────────────────────────────────────

  void _onTabChanged() {
    if (!tabController.indexIsChanging) return;
    final tab = tabOrder[tabController.index];
    activeTab.value = tab;
    if (!_initialized.contains(tab)) {
      _fetchTab(tab, isInitial: true);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Scroll listener — load more when near bottom
  // ─────────────────────────────────────────────────────────────────────────

  void _onScroll(FeedsTab tab) {
    if (tab != activeTab.value) return;
    final sc = scrollControllers[tab];
    if (sc == null || !sc.hasClients) return;
    if (sc.position.pixels >= sc.position.maxScrollExtent - 500) {
      _loadMore(tab);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Data fetching
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _fetchTab(FeedsTab tab, {bool isInitial = false}) async {
    if (isInitial) {
      isLoading[tab]!.value = true;
      exhausted[tab]!.value = false;
      _cursors[tab] = null;
      _sessionSeeds[tab] = DateTime.now().millisecondsSinceEpoch;
      _pageNos[tab] = 1;
      posts[tab]!.clear();
    }

    _initialized.add(tab);

    switch (tab) {
      case FeedsTab.all:
        await _fetchEdgeRank(tab, 'latest');
        break;
      case FeedsTab.favourites:
        await _fetchEdgeRank(tab, 'for_you');
        break;
      case FeedsTab.friends:
        await _fetchEdgeRank(tab, 'friends_first');
        break;
      case FeedsTab.groups:
        await _fetchOffsetGroups(tab);
        break;
      case FeedsTab.pages:
        await _fetchOffsetPages(tab);
        break;
      case FeedsTab.explore:
        await _fetchExploreFeed(tab);
        break;
    }

    if (isInitial) {
      isLoading[tab]!.value = false;
    }
  }

  Future<void> _loadMore(FeedsTab tab) async {
    if (isLoadingMore[tab]!.value || exhausted[tab]!.value) return;
    isLoadingMore[tab]!.value = true;
    await _fetchTab(tab); // not initial — appends
    isLoadingMore[tab]!.value = false;
  }

  Future<void> refreshTab(FeedsTab tab) async {
    await _fetchTab(tab, isInitial: true);
  }

  // ─── EdgeRank-based (All / Favourites / Friends) ─────────────────────────

  Future<void> _fetchEdgeRank(FeedsTab tab, String feedMode) async {
    final response = await _feedsRepo.getEdgeRankFeed(
      feedMode: feedMode,
      cursor: _cursors[tab],
      sessionSeed: _cursors[tab] == null ? _sessionSeeds[tab] : null,
    );

    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final newPosts = data['posts'] as List<PostModel>? ?? [];
      final nextCursor = data['nextCursor'] as String?;
      final hasMore = data['hasMore'] as bool? ?? false;

      // Deduplicate
      final existingIds = posts[tab]!.map((p) => p.id).toSet();
      final unique = newPosts.where((p) => !existingIds.contains(p.id)).toList();

      posts[tab]!.addAll(unique);
      _cursors[tab] = nextCursor;

      if (!hasMore || unique.isEmpty) {
        exhausted[tab]!.value = true;
      }
    } else {
      if (posts[tab]!.isEmpty) {
        exhausted[tab]!.value = true;
      }
    }
  }

  // ─── Offset-based (Groups) ──────────────────────────────────────────────

  Future<void> _fetchOffsetGroups(FeedsTab tab) async {
    final pageNo = _pageNos[tab] ?? 1;

    final response = await _feedsRepo.getGroupsFeed(pageNo: pageNo);

    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final newPosts = data['posts'] as List<PostModel>? ?? [];
      final pageCount = data['pageCount'] as int? ?? 1;

      final existingIds = posts[tab]!.map((p) => p.id).toSet();
      final unique = newPosts.where((p) => !existingIds.contains(p.id)).toList();

      posts[tab]!.addAll(unique);
      _pageCounts[tab] = pageCount;
      _pageNos[tab] = pageNo + 1;

      if (pageNo >= pageCount || unique.isEmpty) {
        exhausted[tab]!.value = true;
      }
    } else {
      if (posts[tab]!.isEmpty) {
        exhausted[tab]!.value = true;
      }
    }
  }

  // ─── Offset-based (Pages) ───────────────────────────────────────────────

  Future<void> _fetchOffsetPages(FeedsTab tab) async {
    final pageNo = _pageNos[tab] ?? 1;

    final response = await _feedsRepo.getPagesFeed(pageNo: pageNo);

    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final newPosts = data['posts'] as List<PostModel>? ?? [];
      final pageCount = data['pageCount'] as int? ?? 1;

      final existingIds = posts[tab]!.map((p) => p.id).toSet();
      final unique = newPosts.where((p) => !existingIds.contains(p.id)).toList();

      posts[tab]!.addAll(unique);
      _pageCounts[tab] = pageCount;
      _pageNos[tab] = pageNo + 1;

      if (pageNo >= pageCount || unique.isEmpty) {
        exhausted[tab]!.value = true;
      }
    } else {
      if (posts[tab]!.isEmpty) {
        exhausted[tab]!.value = true;
      }
    }
  }

  // ─── Explore (cursor-based) ─────────────────────────────────────────────

  Future<void> _fetchExploreFeed(FeedsTab tab) async {
    final response = await _feedsRepo.getExploreFeed(
      cursor: _cursors[tab],
      sessionSeed: _cursors[tab] == null ? _sessionSeeds[tab] : null,
    );

    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final newPosts = data['posts'] as List<PostModel>? ?? [];
      final nextCursor = data['nextCursor'] as String?;
      final hasMore = data['hasMore'] as bool? ?? false;

      final existingIds = posts[tab]!.map((p) => p.id).toSet();
      final unique = newPosts.where((p) => !existingIds.contains(p.id)).toList();

      posts[tab]!.addAll(unique);
      _cursors[tab] = nextCursor;

      if (!hasMore || unique.isEmpty) {
        exhausted[tab]!.value = true;
      }
    } else {
      if (posts[tab]!.isEmpty) {
        exhausted[tab]!.value = true;
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Post interactions — delegates to PostRepository (same APIs as HomeCtrl)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> reactOnPost({
    required FeedsTab tab,
    required PostModel postModel,
    required String reaction,
    required int index,
  }) async {
    final user = LoginCredential().getUserData();
    // Optimistic update using shared utility
    applyOptimisticReaction(
      post: postModel,
      userId: user.id ?? '',
      reactionType: reaction,
      userDetails: {
        '_id': user.id,
        'first_name': user.first_name,
        'last_name': user.last_name,
        'username': user.username,
        'profile_pic': user.profile_pic,
      },
    );
    posts[tab]![index] = postModel;

    await _postRepo.reactOnPost(
      postModel: postModel,
      reaction: reaction,
      key: postModel.key ?? '',
    );
  }

  Future<void> hidePost(FeedsTab tab, String postId) async {
    final response = await _postRepo.hidePost(status: 1, post_id: postId);
    if (response.isSuccessful) {
      posts[tab]!.removeWhere((p) => p.id == postId);
      Get.back();
    }
  }

  Future<void> bookmarkPost(FeedsTab tab, String postId, String privacy, int index) async {
    await _postRepo.bookMarkAPost(
      post_id: postId,
      postPrivacy: privacy,
    );
  }

  Future<void> removeBookmark(FeedsTab tab, String postId, String bookmarkId, int index) async {
    await _postRepo.unBookmarkAPost(post_id: postId, bookMarkId: bookmarkId);
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Comment interactions
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> updatePostList(FeedsTab tab, String postId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'view-single-main-post-with-comments/$postId',
      responseDataKey: 'post',
    );
    if (apiResponse.isSuccessful) {
      List<PostModel> postModelList =
          (apiResponse.data as List).map((e) => PostModel.fromMap(e)).toList();
      if (postModelList.isNotEmpty) {
        posts[tab]![index] = postModelList.first;
        posts[tab]!.refresh();
      }
    }
  }

  Future<List<CommentModel>> getSinglePostsComments(String postID) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-comments-direct-post/$postID',
    );
    if (apiResponse.isSuccessful) {
      return (((apiResponse.data as Map<String, dynamic>)['comments']) as List)
          .map((element) => CommentModel.fromMap(element))
          .toList();
    }
    return [];
  }

  Future<void> commentOnPost(FeedsTab tab, int index, PostModel postModel) async {
    if (commentController.text.isNotEmpty || xfiles.value.isNotEmpty) {
      final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-user-comment-by-post',
        isFormData: true,
        enableLoading: true,
        requestData: {
          'user_id': postModel.user_id?.id,
          'post_id': postModel.id,
          'comment_name': commentController.text,
          'link': null,
          'link_title': null,
          'link_description': null,
          'link_image': null,
          'key': postModel.key,
        },
        fileKey: 'image_or_video',
        mediaXFiles: xfiles.value,
        responseDataKey: 'posts',
      );
      if (apiResponse.isSuccessful) {
        updatePostList(tab, postModel.id ?? '', index);
        commentController.clear();
        xfiles.value.clear();
      }
    }
  }

  void commentReply({
    required FeedsTab tab,
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required int postIndex,
    required String processedFileData,
  }) async {
    if (replies_comment_name.isNotEmpty || processedFileData.isNotEmpty) {
      ApiResponse apiResponse = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'reply-comment-by-direct-post',
        enableLoading: true,
        requestData: {
          'comment_id': comment_id,
          'replies_user_id': userModel.id,
          'replies_comment_name': replies_comment_name,
          'post_id': post_id,
          'image_or_video': processedFileData,
        },
        fileKey: 'image_or_video',
      );
      if (apiResponse.isSuccessful) {
        updatePostList(tab, post_id, postIndex);
        commentReplyController.text = '';
      }
    }
  }

  void commentReaction({
    required FeedsTab tab,
    required int postIndex,
    required String reaction_type,
    required String post_id,
    required String comment_id,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-comment-reaction-of-direct-post',
      requestData: {
        'reaction_type': reaction_type,
        'post_id': post_id,
        'comment_id': comment_id,
      },
    );
    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      posts[tab]![postIndex].comments = comments;
      posts[tab]!.refresh();
    }
  }

  void commentReplyReaction({
    required FeedsTab tab,
    required int postIndex,
    required String reaction_type,
    required String post_id,
    required String comment_id,
    required String comment_replies_id,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-comment-reaction-of-direct-post',
      requestData: {
        'reaction_type': reaction_type,
        'user_id': userModel.id,
        'post_id': post_id,
        'comment_id': comment_id,
        'comment_replies_id': comment_replies_id,
      },
    );
    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      posts[tab]![postIndex].comments = comments;
      posts[tab]!.refresh();
    }
  }

  void commentDelete(FeedsTab tab, String commentId, String postId, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-single-comment',
      requestData: {
        'comment_id': commentId,
        'post_id': postId,
        'type': 'main_comment',
      },
    );
    if (apiResponse.isSuccessful) {
      updatePostList(tab, postId, postIndex);
    }
  }

  void replyDelete(FeedsTab tab, String replyId, String postId, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-single-comment',
      requestData: {
        'comment_id': replyId,
        'post_id': postId,
        'type': 'reply_comment',
      },
    );
    if (apiResponse.isSuccessful) {
      updatePostList(tab, postId, postIndex);
    }
  }
}
