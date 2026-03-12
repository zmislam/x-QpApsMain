import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../repository/post_repository.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../data/post_local_data.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../models/comment_model.dart';
import '../../../../../../models/post.dart';
import '../../../../../../models/user.dart';
import '../../../../../../services/api_communication.dart';
import '../../../../../../utils/post_utlis.dart';
import '../../../../../../utils/snackbar.dart';

class BookmarksController extends GetxController {
  late ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  Rx<List<PostModel>> postList = Rx([]);
  RxBool isLoadingNewsFeed = true.obs;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  late TextEditingController descriptionController;
  late UserModel userModel;
  Rx<List<XFile>> xfiles = Rx([]);
  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    getBookMarkPosts();
    super.onInit();
  }

  Future<void> getBookMarkPosts() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'bookmark-list',
    );

    if (apiResponse.isSuccessful) {
      postList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => PostModel.fromMap(element))
              .toList();
    } else {}
  }

  Future<void> removeBookmarkPost(String bookMarkId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'remove-post-bookmark/$bookMarkId',
    );

    if (apiResponse.isSuccessful) {
      Get.back();
      postList.value.removeAt(index);
      postList.refresh();
      showSuccessSnackkbar(message: 'remove bookmark');
    }
  }

  PostRepository postRepository = PostRepository();
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required String key,
    required int index,
  }) async {
    applyOptimisticReaction(
      post: postModel,
      userId: userModel.id ?? '',
      reactionType: reaction,
      userDetails: {
        '_id': userModel.id,
        'first_name': userModel.first_name,
        'last_name': userModel.last_name,
        'username': userModel.username,
        'profile_pic': userModel.profile_pic,
      },
    );
    postList.refresh();
    final apiResponse = await postRepository.reactOnPost(
      postModel: postModel,
      reaction: reaction,
      key: key,
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
    }
  }

  Future<void> updatePostList(String postId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'view-single-main-post-with-comments/$postId',
      responseDataKey: 'post',
    );
    if (apiResponse.isSuccessful) {
      List<PostModel> postmodelList =
          (apiResponse.data as List).map((e) => PostModel.fromMap(e)).toList();
      postList.value[index] = postmodelList.first;
      postList.refresh();
    }
  }

  void commentDelete(String comment_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment'
        });

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

  void replyDelete(String reply_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': reply_id,
          'post_id': post_id,
          'type': 'reply_comment'
        });

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }

  Future<List<CommentModel>> getSinglePostsComments(String postID) async {
    isLoadingNewsFeed.value = true;

    Rx<List<CommentModel>> commentList = Rx([]);
    debugPrint(
        '==================get SinglePosts Comments=========Start==========================');

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-comments-direct-post/$postID',
    );
    isLoadingNewsFeed.value = false;

    debugPrint('ivalid user code$apiResponse');

    debugPrint(
        '==================get SinglePosts Comments=========Api Call done==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '==================get SinglePosts Comments=========${apiResponse.data}==========================');

      commentList.value.addAll(
          (((apiResponse.data as Map<String, dynamic>)['comments']) as List)
              .map((element) => CommentModel.fromMap(element))
              .toList());

      debugPrint(
          '===================get SinglePosts Commentsn=================${commentList.value}===');

      commentList.refresh();
      return commentList.value;
    } else {
      return [];
    }
  }

  void commentReply({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required int postIndex,
    required String file,
  }) async {
    debugPrint('reply function call');

    ApiResponse apiResponse = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'reply-comment-by-direct-post',
        enableLoading: true,
        requestData: {
          'comment_id': comment_id, //"663a15f5001ab86d881e81e7",
          'replies_user_id': userModel.id, //"6545c99d858780bf50dfc1eb",
          'replies_comment_name': replies_comment_name, //"123123",
          'post_id': post_id, //"6639e808a45d87b49746a3f0"
          'image_or_video': file,
        },
        fileKey: 'image_or_video',);

    if (apiResponse.isSuccessful) {
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      updatePostList(post_id, postIndex);

      commentReplyController.text = '';

      xfiles.value.clear();
    }
  }

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
        });

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

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
        });

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

  Future commentOnPost(int index, PostModel postModel) async {
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
          'key' : postModel.key,
        },
        fileKey: 'image_or_video',
        mediaXFiles: xfiles.value);

    if (apiResponse.isSuccessful) {
      if (postList.value[index].comments != null) {
        // postList.value[index].comments!.add(
        //     CommentModel.fromMap(apiResponse.data as Map<String, dynamic>));
        // postList.refresh();
        updatePostList(postModel.id ?? '', index);
        commentController.clear();
        debugPrint('Hello');
        xfiles.value.clear();
      }
    } else {
      debugPrint('Failure');
    }
  }

  Future<void> pickFiles() async {
    debugPrint('=================X file Value start====================');

    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();

    debugPrint(
        '=================X file Value====================${xfiles.value}');
  }

  Future<void> shareUserPost(String sharePostId) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-share-post-with-caption',
        requestData: {
          'share_post_id': sharePostId,
          'description': descriptionController.text.toString(),
          'privacy': (getPostPrivacyValue(postPrivacy.value)),
        });

    debugPrint(
        'Update model status code.............${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your post has been shared');
      postList.value.clear();
      getBookMarkPosts();
    } else {}
  }

  Future<void> hidePost(int status, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'hide-unhide-post', requestData: {
      'status': status,
      'post_id': post_id,
    });

    if (apiResponse.isSuccessful) {
      postList.value.removeAt(postIndex);
      postList.refresh();
      Get.back();
    }
  }
}
