import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../data/post_local_data.dart';
import '../../../../models/api_response.dart';
import '../../../../models/comment_model.dart';
import '../../../../models/post.dart';
import '../../../../models/user.dart';
import '../../../../repository/post_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/post_utlis.dart';
import '../../../../utils/snackbar.dart';
import '../repository/explore_page_repository.dart';

class ExploreController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;

  late ScrollController postScrollController;
  final ExplorePageRepository explorePageRepository = ExplorePageRepository();

  late TextEditingController descriptionController;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;

  RxString postPrivacy = 'public'.obs;
  RxString dropdownValue = privacyList.first.obs;

  Rx<List<XFile>> xfiles = Rx([]);

  // ─── Cursor-based pagination state ───────────────────────
  RxBool isLoadingNewsFeed = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMorePosts = true.obs;
  RxBool feedExhausted = false.obs;

  String? _nextCursor;
  int _sessionSeed = DateTime.now().millisecondsSinceEpoch;
  int _emptyDedupCount = 0;
  static const int _maxConsecutiveEmptyDedup = 10;

  // Legacy fallback state
  bool _useLegacy = false;
  int _legacyPageNo = 1;
  static const int _legacyPageSize = 15;

  final RxList<PostModel> postList = <PostModel>[].obs;

  // Scroll throttle
  Timer? _scrollThrottle;

  // React / post repo
  final PostRepository postRepository = PostRepository();

  // ============================ INIT =============================
  @override
  void onInit() async {
    super.onInit();

    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();

    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();

    postScrollController = ScrollController();
    postScrollController.addListener(_scrollListener);

    await _fetchExplorePosts(isInitial: true);
  }

  @override
  void onClose() {
    postScrollController.removeListener(_scrollListener);
    postScrollController.dispose();
    commentController.dispose();
    commentReplyController.dispose();
    descriptionController.dispose();
    _scrollThrottle?.cancel();
    super.onClose();
  }

  // ============================ SCROLL LISTENER (THROTTLED) =============================
  void _scrollListener() {
    if (_scrollThrottle?.isActive ?? false) return;
    _scrollThrottle = Timer(const Duration(milliseconds: 200), () {
      _checkAndLoadMore();
    });
  }

  /// Re-check scroll position and trigger load if near bottom.
  /// Called from scroll listener AND after each fetch completes.
  void _checkAndLoadMore() {
    if (isLoadingMore.value || isLoadingNewsFeed.value) return;
    if (feedExhausted.value || !hasMorePosts.value) return;
    if (!postScrollController.hasClients) return;

    if (postScrollController.position.pixels >=
        postScrollController.position.maxScrollExtent - 500) {
      _fetchExplorePosts();
    }
  }

  // ============================ MAIN FETCH (CURSOR-BASED) =============================
  Future<void> _fetchExplorePosts({bool isInitial = false}) async {
    if (isLoadingMore.value && !isInitial) return;
    if (feedExhausted.value && !isInitial) return;

    if (isInitial) {
      isLoadingNewsFeed.value = true;
      _useLegacy = false;
    } else {
      isLoadingMore.value = true;
    }

    try {
      if (_useLegacy) {
        await _fetchLegacy(isInitial: isInitial);
      } else {
        await _fetchCursorBased(isInitial: isInitial);
      }
    } catch (e) {
      debugPrint('[Explore] Fetch error: $e');
      // Try legacy fallback on first failure
      if (!_useLegacy) {
        _useLegacy = true;
        debugPrint('[Explore] Falling back to legacy pagination');
        try {
          await _fetchLegacy(isInitial: isInitial);
        } catch (_) {
          feedExhausted.value = true;
        }
      }
    } finally {
      isLoadingNewsFeed.value = false;
      isLoadingMore.value = false;
      // After new items render, re-check if still near bottom to continue loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndLoadMore();
      });
    }
  }

  /// Fetch using cursor-based explore/feed API
  Future<void> _fetchCursorBased({bool isInitial = false, int retryDepth = 0}) async {
    // Hard recursion guard — prevent runaway retries
    if (retryDepth > 5) {
      debugPrint('[Explore] Max retry depth reached, stopping');
      feedExhausted.value = true;
      return;
    }

    final response = await explorePageRepository.getExploreFeed(
      limit: 10,
      cursor: isInitial ? null : _nextCursor,
      sessionSeed: _sessionSeed,
      forceRecallAPI: isInitial ? true : null,
    );

    if (response.isSuccessful && response.data is ExploreFeedResponse) {
      final feedData = response.data as ExploreFeedResponse;

      if (isInitial) {
        postList.clear();
      }

      // Dedup against existing posts
      final existingIds = postList.map((p) => p.id).toSet();
      final newPosts = feedData.posts
          .where((p) => p.id != null && !existingIds.contains(p.id))
          .toList();

      // Always advance cursor even when all posts are duplicates
      _nextCursor = feedData.nextCursor;

      // ── Exhaustion detection (aligned with web behaviour) ──
      // Web only exhausts when: hasMore=false AND posts.length === 0
      // This ensures stage transitions (backend waterfall) are never
      // prematurely stopped.
      final bool apiReturnedPosts = feedData.posts.isNotEmpty;
      final bool gotNewUniquePosts = newPosts.isNotEmpty;
      final bool backendHasMore =
          feedData.hasMore || feedData.nextCursor != null;

      if (gotNewUniquePosts) {
        // ── Normal: new unique posts added ──
        _emptyDedupCount = 0;
        postList.addAll(newPosts);
        _prefetchPostImages(newPosts);
        hasMorePosts.value = true; // keep scroll alive

        // Web behaviour: if hasMore=false but posts returned, keep alive
        // for one more attempt (stage transition)
        if (!feedData.hasMore && feedData.nextCursor == null) {
          // True exhaustion — all stages done, no cursor, last batch
          feedExhausted.value = true;
          debugPrint('[Explore] Feed exhausted — final batch served');
        }
      } else if (!apiReturnedPosts && !backendHasMore) {
        // ── True exhaustion: backend returned 0 posts + no more ──
        feedExhausted.value = true;
        debugPrint('[Explore] Feed exhausted — no posts, no more stages');
      } else {
        // ── Empty effective page (all duplicates or empty stage transition) ──
        _emptyDedupCount++;
        debugPrint('[Explore] Empty effective page '
            '(apiPosts=${feedData.posts.length}, newAfterDedup=0, '
            'consecutive=$_emptyDedupCount/$_maxConsecutiveEmptyDedup, '
            'hasMore=${feedData.hasMore}, '
            'cursor=${feedData.nextCursor != null})');

        if (_emptyDedupCount >= _maxConsecutiveEmptyDedup) {
          // Safety valve — but only if backend also says no more
          if (!backendHasMore) {
            feedExhausted.value = true;
            debugPrint('[Explore] Feed exhausted — $_maxConsecutiveEmptyDedup '
                'empty batches + backend done');
          } else {
            // Backend still has content — auto-retry with advanced cursor
            debugPrint('[Explore] Auto-retrying with advanced cursor '
                '(depth=${retryDepth + 1})');
            hasMorePosts.value = true;
            isLoadingMore.value = false;
            await Future.delayed(const Duration(milliseconds: 300));
            return _fetchCursorBased(retryDepth: retryDepth + 1);
          }
        } else if (backendHasMore) {
          // Auto-retry: transparent fetch with advanced cursor
          hasMorePosts.value = true;
          isLoadingMore.value = false;
          await Future.delayed(const Duration(milliseconds: 300));
          return _fetchCursorBased(retryDepth: retryDepth + 1);
        } else {
          feedExhausted.value = true;
          debugPrint('[Explore] Feed exhausted — backend done, '
              'all posts were duplicates');
        }
      }

      // Keep hasMore aligned with actual state
      if (!feedExhausted.value) {
        hasMorePosts.value = true;
      }

      debugPrint('[Explore] Loaded ${newPosts.length} new posts '
          '(total: ${postList.length}, hasMore: ${hasMorePosts.value}, '
          'exhausted: ${feedExhausted.value})');
    } else {
      throw Exception(response.message ?? 'Explore feed failed');
    }
  }

  /// Legacy offset-based fallback
  Future<void> _fetchLegacy({bool isInitial = false}) async {
    if (isInitial) _legacyPageNo = 1;

    final response = await explorePageRepository.getLegacyExplorePosts(
      pageNo: _legacyPageNo,
      pageSize: _legacyPageSize,
    );

    if (response.isSuccessful) {
      final posts = response.data as List<PostModel>;

      if (isInitial) {
        postList.clear();
      }

      postList.addAll(posts);
      hasMorePosts.value = posts.length >= _legacyPageSize;
      if (posts.isEmpty) feedExhausted.value = true;
      _legacyPageNo++;
    } else {
      throw Exception(response.message ?? 'Legacy explore failed');
    }
  }

  // For RefreshIndicator
  Future<void> refreshExplore() async {
    _nextCursor = null;
    _sessionSeed = DateTime.now().millisecondsSinceEpoch;
    _emptyDedupCount = 0;
    hasMorePosts.value = true;
    feedExhausted.value = false;
    _useLegacy = false;
    _legacyPageNo = 1;
    await _fetchExplorePosts(isInitial: true);
  }

  // ============================ React on A Post =============================
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required int index,
    required String key,
  }) async {
    applyOptimisticReaction(
      post: postModel,
      userId: userModel.id ?? '',
      reactionType: reaction,
    );

    postList[index] = postModel;

    final apiResponse = await postRepository.reactOnPost(
      postModel: postModel,
      reaction: reaction,
      key: key
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
      // Track engagement for explore algorithm
      explorePageRepository.trackEngagement('reaction', postId: postModel.id);
    }
  }

  // ============================ Update Single Post =============================
  Future<void> updatePostList(String postId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'view-single-main-post-with-comments/$postId',
      responseDataKey: 'post',
    );

    if (apiResponse.isSuccessful) {
      List<PostModel> postmodelList =
          (apiResponse.data as List).map((e) => PostModel.fromMap(e)).toList();
      postList[index] = postmodelList.first;
    }
  }

  // ============================ Comments Fetch =============================
  Future<List<CommentModel>> getSinglePostsComments(String postID) async {
    debugPrint(
        '==================get SinglePosts Comments=========Start==========================');

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-comments-direct-post/$postID',
    );

    if (apiResponse.isSuccessful) {
      final List<CommentModel> commentList =
        (((apiResponse.data as Map<String, dynamic>)['comments']) as List)
            .map((element) => CommentModel.fromMap(element))
            .toList();
      return commentList;
    } else {
      return [];
    }
  }

  // ============================ Comment on Post =============================
  Future commentOnPost(int index, PostModel postModel) async {
    debugPrint('Comment API Called============================');
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
        if (postList[index].comments != null) {
          updatePostList(postModel.id ?? '', index);
          commentController.clear();
          debugPrint('Hello');
          xfiles.value.clear();
        }
      } else {
        debugPrint('Failure');
      }
    } else {
      debugPrint('Can not do empty comment');
    }
  }

  // ============================ Comment Reply =============================
  void commentReply({
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
        updatePostList(post_id, postIndex);
        commentReplyController.text = '';
        processedFileData = '';
      }
    } else {
      debugPrint('Can not do empty replay comment');
    }
  }

  // ============================ Comment Reaction =============================
  void commentReaction({
    required int postIndex,
    required String reaction_type,
    required String post_id,
    required String comment_id,
  }) async {
    debugPrint('===================================reaction function  call');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-comment-reaction-of-direct-post',
      requestData: {
        'reaction_type': reaction_type,
        'post_id': post_id,
        'comment_id': comment_id
      },
    );

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      final updatedPost = postList[postIndex];
      updatedPost.comments = comments;
      postList[postIndex] = updatedPost;
    }
  }

  // ============================ Comment Reply Reaction =============================
  void commentReplyReaction(
    int postIndex,
    String reaction_type,
    String post_id,
    String comment_id,
    String comment_replies_id,
  ) async {
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
      final updatedPost = postList[postIndex];
      updatedPost.comments = comments;
      postList[postIndex] = updatedPost;
    }
  }

  // ============================ Comment Delete =============================
  void commentDelete(String comment_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-single-comment',
      requestData: {
        'comment_id': comment_id,
        'post_id': post_id,
        'type': 'main_comment'
      },
    );

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }

  // ============================ Reply Delete =============================
  void replyDelete(String reply_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-single-comment',
      requestData: {
        'comment_id': reply_id,
        'post_id': post_id,
        'type': 'reply_comment'
      },
    );

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }

  // ============================ Edit Post =============================
  void onTapEditPost(PostModel model) async {
    await Get.toNamed(Routes.EDIT_POST, arguments: model);
    await refreshExplore();
  }

  // ============================ Hide Post =============================
  Future<void> hidePost(int status, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'hide-unhide-post',
      requestData: {
        'status': status,
        'post_id': post_id,
      },
    );

    if (apiResponse.isSuccessful) {
      postList.removeAt(postIndex);
      Get.back();
      // Track hide for explore algorithm
      explorePageRepository.trackEngagement('hide', postId: post_id);
    }
  }

  // ============================ Bookmark Post =============================
  Future<void> bookmarkPost(
      String post_id, String postPrivacy, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post-bookmark',
      requestData: {
        'post_privacy': postPrivacy,
        'post_id': post_id,
      },
    );

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, index);
      Get.back();
      showSuccessSnackkbar(message: 'Post bookmark successfully');
    }
  }

  // ============================ Remove Bookmark =============================
  Future<void> removeBookmarkPost(
      String post_id, String bookMarkId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'remove-post-bookmark/$bookMarkId',
    );

    if (apiResponse.isSuccessful) {
      Get.back();
      updatePostList(post_id, index);
      showSuccessSnackkbar(message: 'remove bookmark');
    }
  }

  // ============================ Share Post =============================
  Future<void> shareUserPost(String sharePostId) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-share-post-with-caption',
      requestData: {
        'share_post_id': sharePostId,
        'description': descriptionController.text.toString(),
        'privacy': (getPostPrivacyValue(postPrivacy.value)),
      },
    );

    debugPrint(
        'Update model status code.............${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your post has been shared');
      await refreshExplore();
    }
  }

  // ============================ Launch URL =============================
  void launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url,
          mode: LaunchMode.inAppBrowserView,
          browserConfiguration: const BrowserConfiguration(showTitle: true));
    } else {
      throw 'Could not launch $urlString';
    }
  }

  // ============================ Pre-fetch Images =============================
  /// Pre-cache first image of each post for instant display on scroll.
  void _prefetchPostImages(List<PostModel> posts) {
    final context = Get.context;
    if (context == null) return;

    for (final post in posts) {
      final mediaList = post.media;
      if (mediaList == null || mediaList.isEmpty) continue;

      for (final media in mediaList) {
        final filename = media.media;
        if (filename == null || filename.isEmpty) continue;
        if (!isImageUrl(filename)) continue;

        final fullUrl = filename.formatedPostUrl;
        try {
          precacheImage(CachedNetworkImageProvider(fullUrl), context);
        } catch (_) {}
        break;
      }
    }
  }
}
