import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/post_repository.dart';
import '../../../routes/app_pages.dart';
import '../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../NAVIGATION_MENUS/notification/controllers/notification_controller.dart';

import '../../../config/constants/api_constant.dart';
import '../../../data/login_creadential.dart';
import '../../../models/api_response.dart';
import '../../../models/comment_model.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../utils/post_utlis.dart';
import '../../../services/api_communication.dart';

class NotificationPostController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  RxBool isLoadingNewsFeed = true.obs;
  String? postId;
  String? commentId;
  Rx<List<PostModel>> postList = Rx([]);
  late TextEditingController commentController;
  NotificationController notificationController = Get.find();
  final PostRepository postRepository = PostRepository();

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    userModel = _loginCredential.getUserData();
    postId = Get.arguments['postId'];
    commentId = Get.arguments['commentId'];

    await getPosts(postId ?? '');
    if (commentId != null) {
      openCommentComponent(Get.context!);
    }
//  commentOnPost(postModel)
    commentController = TextEditingController();
    super.onInit();
  }

// Function to open the PostCommentPageView
  void openCommentComponent(BuildContext context) {
    Get.to(
      () => PostCommentPageView(
        postId: postList.value[0].id ?? '',
        initialPostModel: postList.value[0],
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 250),
    );
  }

  // Future<void> reactOnPost({
  //   required PostModel postModel,
  //   required String reaction,
  //   required int index,
  // }) async {
  //   final apiResponse = await postRepository.reactOnPost(
  //       postModel: postModel, reaction: reaction);

  //   if (apiResponse.isSuccessful) {
  //     debugPrint(apiResponse.message);
  //     updatePostList(postModel.id ?? '', index);
  //   } else {
  //     debugPrint(apiResponse.message);
  //   }
  // }
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

  //============================= Update Posts =========================================//
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

  Future<void> getPosts(String postId) async {
    isLoadingNewsFeed.value = true;

    debugPrint('ivalid user code$postId');

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'view-single-main-post-with-comments/$postId',
    );
    isLoadingNewsFeed.value = false;

    debugPrint('ivalid user code$apiResponse');

    debugPrint(
        '=================Single Post Api==========================${apiResponse.data}');

    if (apiResponse.isSuccessful) {
      postList.value.clear();
      postList.value.addAll(
          (((apiResponse.data as Map<String, dynamic>)['post']) as List)
              .map((element) => PostModel.fromMap(element))
              .toList());
    }
  }

  Future commentOnPost(PostModel postModel) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-comment-by-post',
      isFormData: true,
      requestData: {
        'user_id': postModel.user_id?.id,
        'post_id': postModel.id,
        'comment_name': commentController.text,
        'image_or_video': null,
        'link': null,
        'link_title': null,
        'link_description': null,
        'link_image': null,
        'key' : postModel.key
      },
    );

    if (apiResponse.isSuccessful) {
      if (postList.value[0].comments != null) {
        postList.value[0].comments!.add(
            CommentModel.fromMap(apiResponse.data as Map<String, dynamic>));
        postList.refresh();
        commentController.clear();
        debugPrint('Hello');
      }
    } else {
      debugPrint('Failure');
    }
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
