import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import 'package:quantum_possibilities_flutter/app/modules/earnDashboard/controllers/earn_dashboard_controller.dart';
import '../../../../../shared/modules/create_post/models/fileCheckState.dart';
import '../../../../../shared/modules/create_post/models/imageCheckerModel.dart';
import '../../../../../shared/modules/create_post/service/imageCheckerService.dart';
import '../sub_menus/videos_gallery/model/video_model.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../data/post_local_data.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../models/comment_model.dart';
import '../../../../../../models/follower_user_model.dart';
import '../../../../../../models/following_user_model.dart';
import '../../../../../../models/friend.dart';
import '../../../../../../models/post.dart';
import '../../../../../../models/profile_model.dart';
import '../../../../../../models/user.dart';
import '../../../../../../repository/post_repository.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../services/api_communication.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../utils/image_utils.dart';
import '../../../../../../utils/post_utlis.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/album_model.dart';
import '../models/personal_reels_model.dart';
import '../models/photos_model.dart';
import '../models/profile_cover_albums_model.dart';
import '../models/story_model.dart';
import '../models/user_profile_model.dart';
import '../provider/profile_provider.dart';
import '../../../../reels/model/reels_model.dart';
import '../../../../../../repository/reels_repository.dart';

class ProfileController extends GetxController {
  // Global Usecases
  late final ApiCommunication _apiCommunication;
  final ReelsRepository _reelsRepository = ReelsRepository();

  // Post Related Variables
  final PostRepository postRepository = PostRepository();
  int totalPageCount = 0;
  int pageNo = 1;
  final int pageSize = 10;
  RxBool isLoadingNewsFeed = true.obs;
  late ScrollController postScrollController;
  String? isFromReels = 'false';
  //Friend
  Rx<List<FriendModel>> friendList = Rx([]);
  RxInt friendCount = 0.obs;

  // Profile tab selector: 0=All, 1=Photos, 2=Reels
  RxInt selectedProfileTab = 0.obs;

  RxBool isLoadingRefresh = false.obs;

  var profileUserData = ProfileUserData().obs;

  ProfileProvider profileProvider = ProfileProvider();

  RxBool profilepicLoader = false.obs;
  RxBool coverpicLoader = false.obs;

  RxInt viewNumber = 0.obs;
  RxInt viewReelsTabNumber = 0.obs;
  RxString selectedPrivacyOption = 'public'.obs;

  RxBool isLoadingFriendList = true.obs;
  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingUserRepost = false.obs;
  RxBool isLoadingUserStory = false.obs;
  RxBool isLoadingUserReels = false.obs;
  RxBool isLoadingUserSharedReels = false.obs;
  RxBool isLoadingSavedReels = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  Rx<List<PostModel>> postList = Rx([]);
  Rx<List<PostModel>> pinnedPostList = Rx([]);
  late final LoginCredential loginCredential;
  late UserModel userModel;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  Rx<ProfileModel?> profileModel = Rx(null);
  Rx<PhotoModel?> photoModel = Rx(null);
  Rx<List<PhotoModel>> photoList = Rx([]);
  Rx<List<ProfilrStoryModel>> storyList = Rx([]);
  Rx<List<VideoReel>> reelsList = Rx([]);
  Rx<List<ReelsModel>> savedReelsList = Rx([]);
  // Rx<List<SharedReelDetails>> sharedReelsList = Rx([]);

  late TextEditingController descriptionController;
  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;

  Rx<List<XFile>> xfiles = Rx([]);

  RxString commentsID = ''.obs;
  RxString postID = ''.obs;

  RxBool isCommentReactionLoading = true.obs;
  RxBool isReplyReactionLoading = true.obs;
  var websiteUrl = ''.obs;

  var followingController = ''.obs;
  Rx<List<FollowingUserModel>> followingList = Rx([]);
  Rx<List<FollowingUserModel>> searchFollowingList = Rx([]);
  RxBool isLoadingFollowingList = true.obs;

  var followerController = ''.obs;
  Rx<List<FollowerUserModel>> followerList = Rx([]);
  Rx<List<FollowerUserModel>> searchFollowerList = Rx([]);
  Rx<List<AlbumModel>> albumsList = Rx([]);
  Rx<List<VideoReel>> repostList = Rx([]);
  Rx<List<ProfilPicturesemodel>> profilePicturesList = Rx([]);
  RxBool isLoadingFollowerList = true.obs;

  RxString buttonview = 'Photos of you'.obs;

  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;
  final isLoading = false.obs;
  //Filters

  Rx<List<String>> postFilterYearList = Rx([]);
  RxString filterYear = ''.obs;
  RxString filterPostBy = ''.obs;
  RxString filterPrivacy = 'public'.obs;
  RxString filterTagBy = ''.obs;
  final turnOnMonitaization = false.obs;
  //======================================================== Profile Related Functions ===============================================//
/*============================================ Get User Data=================================*/
  Future getUserData() async {
    isLoading.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-user-info',
      requestData: {'username': '${loginCredential.getUserData().username}'},
      responseDataKey: 'userInfo',
    );
    if (apiResponse.isSuccessful) {
      debugPrint('Response success');
      profileModel.value =
          ProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
      turnOnMonitaization.value =
          profileModel.value!.turn_on_earning_dashboard!;
      debugPrint('My Profile Model: ${profileModel.value}');
      debugPrint('TURN ON MONI: ${turnOnMonitaization.value}');
      isLoading.value = false;
    } else {
      debugPrint('Response failed');
      isLoading.value = false;
    }
  }
/*============================================ Get User Profile Pictures=================================*/

//========================= Payment Indent =========================//

  final clientSecretKey = ''.obs;
  final isProcessingPayment = false.obs;
  final paymentIntentId = ''.obs;

  Future<Map<String, dynamic>?> createPaymentIntent() async {
    try {
      final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'profile/create-payment-intent',
        responseDataKey: ApiConstant.FULL_RESPONSE,
        requestData: {
          'amount': 11,
        },
        enableLoading: true,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final data = apiResponse.data as Map<String, dynamic>;

        clientSecretKey.value = data['clientSecret'] ?? '';

        if (paymentIntentId.value.isEmpty && clientSecretKey.value.isNotEmpty) {
          paymentIntentId.value = clientSecretKey.value.split('_secret_')[0];
        }

        if (!clientSecretKey.value.contains('_secret_')) {
          showErrorSnackbar(
            message:
                'Invalid payment session from server. Please contact support.',
          );
          return null;
        }

        return data;
      } else {
        showErrorSnackbar(message: 'Failed to create payment intent');
        return null;
      }
    } catch (e) {
      showErrorSnackbar(message: 'Failed to initialize payment');
      return null;
    }
  }

  Future<void> makePayment() async {
    try {
      isProcessingPayment.value = true;

      if (clientSecretKey.value.isEmpty) {
        showErrorSnackbar(message: 'Payment session not initialized');
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecretKey.value,
          allowsDelayedPaymentMethods: true,
          merchantDisplayName: 'Quantum Possibility',
          style: ThemeMode.system,
          googlePay: const PaymentSheetGooglePay(
            testEnv: true,
            currencyCode: 'USD',
            merchantCountryCode: 'US',
          ),
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          returnURL:
              '${ApiConstant.SERVER_IP_PORT}/api/profile/verification-by-stripe',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      final intent = await Stripe.instance.retrievePaymentIntent(
        clientSecretKey.value,
      );
      print('✅ Payment sheet completed - card details collected');
      ApiResponse summarizeResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'wallet/summarize-payment',
        requestData: {
          'confirmation_token_id': intent.id,
        },
      );

      if (!summarizeResponse.isSuccessful) {
        showErrorSnackbar(
          message:
              'Payment summary failed: ${summarizeResponse.message ?? "Unknown error"}',
        );
        return;
      }

      ApiResponse verificationResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'profile/verification-by-stripe',
        queryParameters: {
          'payment_intent': intent.id,
          'redirect_status': 'succeeded',
          'payment_intent_client_secret': clientSecretKey.value,
          'is_app': 'true',
        },
      );

      if (verificationResponse.isSuccessful) {
        Get.back();
        showSuccessSnackkbar(
          message: 'Payment successful!'.tr,
        );
        await getUserData();
        clientSecretKey.value = '';
        paymentIntentId.value = '';
      } else {
        showErrorSnackbar(
          message: verificationResponse.message ??
              'Payment completed but verification failed. Please contact support.',
        );
      }
    } on StripeException catch (e) {
      print('❌ StripeException: ${e.error.message}');
      String message = 'Payment failed';

      if (e.error.code == FailureCode.Canceled) {
        message = 'Payment was cancelled';
      } else if (e.error.code == FailureCode.Failed) {
        if (e.error.message?.contains('No such payment_intent') ?? false) {
          message = 'Payment session expired or invalid. Please try again.';
          clientSecretKey.value = '';
          this.paymentIntentId.value = '';
        } else {
          message = 'Payment failed: ${e.error.message ?? 'Unknown error'}';
        }
      } else if (e.error.code == FailureCode.Timeout) {
        message = 'Payment timed out. Please try again.';
      }

      showErrorSnackbar(message: message);
    } catch (e) {
      print('❌ Error: $e');
      showErrorSnackbar(message: 'An unexpected error occurred: $e');
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void showSuccessSnackkbar({required String message}) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void showErrorSnackbar({required String message}) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

//========================= Payment Indent =========================//
//========================= Get Profile Pictures with Pagination =========================//
  int profilePageNo = 1;
  int totalProfilePages = 1;
  int profilePageSize = 20;
  RxBool isFetchingProfilePhotos = false.obs;

  Future<void> getProfilePictures() async {
    if (isFetchingProfilePhotos.value || profilePageNo > totalProfilePages) {
      return;
    }

    isFetchingProfilePhotos.value = true;
    isLoadingProfilePhoto.value = true;

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint:
          'get-users-albums-images?page_no=$profilePageNo&page_size=$profilePageSize',
      requestData: {
        'username': userModel.username,
        'albums_id': 'profile_picture',
      },
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    isLoadingProfilePhoto.value = false;
    isFetchingProfilePhotos.value = false;

    if (apiResponse.isSuccessful) {
      final Map<String, dynamic> data =
          apiResponse.data as Map<String, dynamic>;

      totalProfilePages = data['profilePicCount'] ?? 1;

      List<ProfilPicturesemodel> fetchedPhotos = (data['data'] as List)
          .map((e) => ProfilPicturesemodel.fromMap(e))
          .toList();

      profilePicturesList.value.addAll(fetchedPhotos);
      // profilePicturesList.refresh(); // only if needed
    } else {
      // Handle API error here
    }
  }

/*============================================Upload User Profile Picture=================================*/

  Future<void> uploadUserProfilePicture() async {
    await pickFiles();
   if(processedFileData.isNotEmpty){
     final image = processedFileData[0];
     final ApiResponse response = await _apiCommunication.doPostRequestNew(
         apiEndPoint: 'change-only-profile-pic',
         enableLoading: true,
         fileKey: 'profile_pic',
         requestData: {
           'profile_pic': processedFileData[0].toString(),
         },

     );
     if (response.isSuccessful) {
       showSuccessSnackkbar(message: 'Post submitted successfully');

       UserModel model =
       UserModel.fromMap(response.data as Map<String, dynamic>);

       loginCredential.saveUserData(model);
     } else {
       debugPrint('');
     }
   } else {
      debugPrint('file data empty');
   }
  }
/*============================================ Upload User Cover Picture=================================*/

  Future<void> uploadUserCoverPicture() async {
    final XFile? xFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (xFile != null) {
      File? file = await cropImage(File(xFile.path));
      if (file != null) {
        final ApiResponse response = await _apiCommunication.doPostRequest(
          apiEndPoint: 'change-only-cover-pic',
          enableLoading: true,
          mediaFiles: [file],
          fileKey: 'cover_pic',
          isFormData: true,
        );
        if (response.isSuccessful) {
          showSuccessSnackkbar(message: 'Post submitted successfully');
        } else {
          debugPrint('');
        }
      }
    } else {
      debugPrint('');
    }
  }
/*============================================ Remove Cover Picture================================*/

  Future<void> removeCoverPhoto() async {
    final ApiResponse response =
        await _apiCommunication.doGetRequest(apiEndPoint: 'remove-cover-pic');
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Cover photo removed successfully');
      Get.back();
      getUserData();
    } else {
      debugPrint('');
    }
  }
/*============================================ Remove Profile Picture================================*/

  Future<void> removeProfilePhoto() async {
    final ApiResponse response =
        await _apiCommunication.doGetRequest(apiEndPoint: 'remove-profile-pic');
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Profile photo removed successfully');
      Get.back();
      getUserData();
    } else {
      debugPrint('');
    }
  }

//======================================================== Post Related Functions ===============================================//
/*============================================ Get Posts================================*/

  Future<void> getPosts() async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getIndividualPosts(
      pageNo: pageNo,
      pageSize: pageSize,
      userName: userModel.username ?? '',
    );
    isLoadingNewsFeed.value = false;
    if (apiResponse.isSuccessful) {
      totalPageCount = apiResponse.pageCount ?? 1;
      List<PostModel> postListResponse = apiResponse.data as List<PostModel>;

      for (PostModel postModel in postListResponse) {
        if (postModel.pinPost == true) {
          pinnedPostList.value.add(postModel);
        } else {
          postList.value.add(postModel);
        }
      }
      pinnedPostList.refresh();
      postList.refresh();
    } else {
      //Error Response
    }
  }
/*============================================ Get Filtered Posts================================*/

  Future<void> getFilterPosts() async {
    isLoadingNewsFeed.value = true;

    postList.value.clear();
    pinnedPostList.value.clear();

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'search-post?year=${filterYear.value}&privacy=${filterPrivacy.value}&posted_by=${filterPostBy.value}&isTagged=${filterTagBy.value}&timeline_username=${loginCredential.getUserData().username}',
    );

    isLoadingNewsFeed.value = false;
    if (apiResponse.isSuccessful) {
      List<PostModel> postListResponse =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => PostModel.fromMap(element))
              .toList();

      for (PostModel postModel in postListResponse) {
        if (postModel.pinPost == true) {
          pinnedPostList.value.add(postModel);
        } else {
          postList.value.add(postModel);
        }
      }
      pinnedPostList.refresh();
      postList.refresh();
    } else {
      //Error Response
    }
  }
/*============================================ Delete Posts================================*/

  Future<void> deletePost(String postId) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'delete-post-by-id',
      requestData: {
        'postId': postId,
        // 'key' :
      },
      fileKey: ''
    );
    isLoadingNewsFeed.value = false;

    debugPrint('api delete response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Post Has Been Deleted');
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }
/*============================================ Update Posts================================*/

  Future<void> updatePost(String postId, String description, String key) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'edit-post',
      requestData: {
        'description': description,
        'post_Id': postId,
        'key': key,
      },
    );
    isLoadingNewsFeed.value = false;

    debugPrint('api update response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Post Has Been Deleted');
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }
/*============================================ Update Posts Privacy================================*/

  Future<void> updatePostPrivacy(String postId, String key) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'edit-post',
        requestData: {
          'post_privacy': selectedPrivacyOption,
          'post_id': postId,
          'key': key,
        },
        isFormData: true);
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Post Privacy Has Been Changed');
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }
/*============================================ Hide Posts================================*/

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
/*============================================ Pin/Unpin Posts================================*/

  Future<void> pinAndUnpinPost(int status, String post_id, int index) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'change-pin-post-status', requestData: {
      'post_id': post_id,
      'pin_post': status,
    });

    if (apiResponse.isSuccessful) {
      // if (status == 0) {
      //   pinnedPostList.value.removeAt(index);
      //   pinnedPostList.refresh();
      // }
      pinnedPostList.value.clear();
      postList.value.clear();
      totalPageCount = 0;
      pageNo = 1;
      Get.back();
      getPosts();
      showSuccessSnackkbar(message: apiResponse.message.toString());
    }
  }
/*============================================ BookMark Posts================================*/

  Future<void> bookmarkPost(String post_id, String postPrivacy) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-post-bookmark', requestData: {
      'post_privacy': postPrivacy,
      'post_id': post_id,
    });

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Post bookmark successfully');
    }
  }

/*============================================ React On Posts================================*/
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
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
      key: postModel.key ?? '',
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
    }
  }
  // Future<void> reactOnPost({
  //   required PostModel postModel,
  //   required String reaction,
  //   required int index,
  // }) async {
  //   final apiResponse = await _apiCommunication.doPostRequest(
  //     responseDataKey: ApiConstant.FULL_RESPONSE,
  //     apiEndPoint: 'save-reaction-main-post',
  //     requestData: {
  //       'reaction_type': reaction,
  //       'post_id': postModel.id,
  //       'post_single_item_id': null,
  //     },
  //   );

  //   if (apiResponse.isSuccessful) {
  //     updatePostList(postModel.id ?? '', index);
  //   }
  // }
/*============================================ Update Post List================================*/

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
/*============================================ Share User Posts================================*/

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
      getPosts();
    } else {}
  }

/*============================================ Create Posts================================*/
  RxBool isLoadingCreatePost = false.obs;

  void onTapCreatePost() async {
    await Get.toNamed(Routes.CREAT_POST, arguments: {
      // 'group_id': allGroupModel.value,
      'media_files': xfiles.value,
      'processed_file_data': processedFileData.value,
    });
    isLoadingCreatePost.value = true;
    pageNo = 1;
    totalPageCount = 0;
    postList.value.clear();
    getPosts();
    isLoadingCreatePost.value = false;
  }

//======================================================== Comment Related Functions ===============================================//
/*============================================ Get Single Comments================================*/

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
/*============================================ Comment on Post================================*/

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
/*============================================Reply Comment on Post================================*/

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
        fileKey: 'image_or_video');

    if (apiResponse.isSuccessful) {
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      updatePostList(post_id, postIndex);

      commentReplyController.text = '';

      xfiles.value.clear();
    }
  }
/*============================================ Comment Reaction on Post================================*/

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
/*============================================Reply Comment Reaction on Post================================*/

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
/*============================================ Comment Delete================================*/

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
/*============================================ Reply Delete================================*/

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
/*============================================ End of Comment Relate Funcs ================================*/

/*============================================ Pick File================================*/

  Future<void> pickFiles() async {
    debugPrint('=================X file Value start====================');

    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();

    await checkFilesForVulgarity(xfiles.value.toList());

  }

  Future<void> pickMediaFiles() async {
    isLoading.value = true;
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();
    processedFileData.clear();
    if (mediaXFiles.isNotEmpty) {
      processedFileData.clear();
      xfiles.value.clear();

      await checkFilesForVulgarity(mediaXFiles);
    }
    onTapCreatePost();
  }

  Future<void> checkFilesForVulgarity(List<XFile> newFiles) async {
    isCheckingFiles.value = true;
    checkingStatus.value = 'Checking files for inappropriate content...';

    // Initialize checking states for all files - they will show with loading
    fileCheckingStates.value = newFiles
        .map((file) => FileCheckingState(
              fileName: file.name,
              filePath: file.path,
              isChecking: true,
            ))
        .toList();

    List<String> removedFiles = [];

    for (int i = 0; i < newFiles.length; i++) {
      XFile file = newFiles[i];
      String filePath = file.path.toLowerCase();

      try {
        checkingStatus.value =
            'Checking ${i + 1}/${newFiles.length}: ${file.name}';

        ImageCheckerModel? checkerResponse;

        if (filePath.endsWithAny(['.jpg', '.jpeg', '.png', '.gif', '.webp'])) {
          checkerResponse =
              await ImageCheckerService.checkImageForVulgarity(file);
        } else if (filePath
            .endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
          checkerResponse =
              await ImageCheckerService.checkVideoForVulgarity(file);
        }

        if (checkerResponse != null) {
          debugPrint(
              'API Response for ${file.name}: sexual=${checkerResponse.sexual}, data=${checkerResponse.data}');

          if (checkerResponse.sexual == true) {
            // Mark as failed and will be removed
            removedFiles.add(file.name);
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isFailed = true;
            fileCheckingStates.refresh();
            debugPrint('Removed file for vulgarity: ${file.name}');
          } else {
            // File passed - add to main list and mark as passed
            xfiles.value.add(file);
            if (checkerResponse.data != null) {
              processedFileData.value.add(checkerResponse.data!);
            }
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isPassed = true;
            fileCheckingStates.refresh();
            xfiles.refresh();
            processedFileData.refresh();
            debugPrint('File passed checker: ${file.name}');
          }
        } else {
          // API failed, include as safe
          xfiles.value.add(file);
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isPassed = true;
          fileCheckingStates.refresh();
          xfiles.refresh();
          debugPrint('API failed for ${file.name}, including file as safe');
        }
      } catch (e) {
        // Error, include as safe
        xfiles.value.add(file);
        fileCheckingStates[i].isChecking = false;
        fileCheckingStates[i].isPassed = true;
        fileCheckingStates.refresh();
        xfiles.refresh();
        debugPrint('Error checking file ${file.name}: $e');
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (removedFiles.isNotEmpty) {
      showRemovedFilesSnackbar(removedFiles);
    }

    debugPrint('Processed file data: ${processedFileData.value}');

    // Clear checking states after showing results briefly
    await Future.delayed(const Duration(milliseconds: 800));
    fileCheckingStates.clear();

    isCheckingFiles.value = false;
    checkingStatus.value = '';
  }

  void showRemovedFilesSnackbar(List<String> removedFiles) {
    String message;
    if (removedFiles.length == 1) {
      message =
          '${removedFiles.first} was removed due to inappropriate content';
    } else {
      message =
          '${removedFiles.length} files were removed due to inappropriate content';
    }

    Get.snackbar(
      'Content Removed',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
    );
  }

  void clearProcessedData() {
    processedFileData.clear();
  }

  Future<void> onTapCreatePhotoComment(String userId, String postId, String key) async {
    debugPrint('===================Photo comment Start=====================');

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-comment-by-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'user_id': userId, //postModel.user_id?.id,
        'post_id': postId, //postModel.id,
        'comment_name': commentController.text,
        'image_or_video': null,
        'link': null,
        'link_title': null,
        'link_description': null,
        'link_image': null,
        'key' : key,
      },
      mediaXFiles: xfiles.value,
    );

    if (response.isSuccessful) {
      debugPrint(
          '===================Photo comment ${response.statusCode}=====================');
    } else {
      debugPrint('');
    }
  }

//======================================================== Photos Related Functions ===============================================//

  Future getAlbums() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-users-album/${userModel.username}',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      albumsList.value = (apiResponse.data as List)
          .map(
            (e) => AlbumModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPhoto.value = false;
  }

//===================================Get Photos===================================//
  int photoPageNo = 1;
  int totalPhotoPages = 1;
  int photoPageSize = 20; // or any desired page size
  RxBool isFetchingPhotos = false.obs;
  Future<void> getPhotos() async {
    if (isFetchingPhotos.value) return;

    isFetchingPhotos.value = true;
    isLoadingUserPhoto.value = true;

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint:
          'get-users-latest-image?page_no=$photoPageNo&page_size=$photoPageSize',
      requestData: {
        'username': '${loginCredential.getUserData().username}',
      },
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    isLoadingUserPhoto.value = false;
    isFetchingPhotos.value = false;

    if (apiResponse.isSuccessful) {
      final Map<String, dynamic> data =
          apiResponse.data as Map<String, dynamic>;
      totalPhotoPages = data['imageCount'] ?? 1;

      List<PhotoModel> photos =
          (data['images'] as List).map((e) => PhotoModel.fromMap(e)).toList();

      photoList.value.addAll(photos);
      // photoList.refresh();
    } else {
      // Handle error case
    }
  }

//==================================Fetch Profile user video list==================================//
  RxBool isLoadingUserVideo = false.obs;
  Rx<List<VideoModel>> videoList = Rx([]);

  Future getVideos() async {
    isLoadingUserVideo.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-latest-video-thumbnails',
      requestData: {
        'username': loginCredential.getUserData().username,
      },
      responseDataKey: 'videos',
    );

    if (apiResponse.isSuccessful) {
      videoList.value = (apiResponse.data as List)
          .map(
            (e) => VideoModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserVideo.value = false;
  }

/*=============== Edit About  API=====================*/
  Future<void> onTapEditBioPatch() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'update-user-bio',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'user_bio': '',
        'privacy': 'public',
      },
    );
    if (response.isSuccessful) {
      Get.back();
      getUserData();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }
//======================================================== Stories Related Functions ===============================================//

  Future getStories() async {
    isLoadingUserStory.value = true;
    debugPrint('==========================get Story Start');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'get-users-latest-story',
        requestData: {'username': '${loginCredential.getUserData().username}'},
        responseDataKey: 'storylist');

    debugPrint('==========================get Story After api call');
    if (apiResponse.isSuccessful) {
      debugPrint('==========================get Story Before Model');
      debugPrint('Response success');
      storyList.value = (apiResponse.data as List)
          .map((e) => ProfilrStoryModel.fromMap(e))
          .toList();
      debugPrint('Response success');
      debugPrint('==========================get Story After model');
    }
    isLoadingUserStory.value = false;
  }
//======================================================== Reels Related Functions ===============================================//
// int skip = 0;
// int limit = 10;
  // Future getPersonalReels({int? skip}) async {
  //   isLoadingUserReels.value = true;
  //   debugPrint('==========================get Reels Start');

  //   ApiResponse apiResponse = await _apiCommunication.doGetRequest(
  //       apiEndPoint: 'profile/reels/${loginCredential.getUserData().username}?skip=$skip&limit=$limit',
  //       // requestData: {'username': '${loginCredential.getUserData().username}'},
  //       responseDataKey: 'results');

  //   debugPrint('==========================get Reels After api call');
  //   if (apiResponse.isSuccessful) {
  //     debugPrint('==========================get Reels Before Model');
  //     debugPrint('Response success');
  //     reelsList.value =
  //         (apiResponse.data as List).map((e) => VideoReel.fromMap(e)).toList();
  //     debugPrint('Response success');
  //     debugPrint('==========================get Reels After model');
  //   }
  //   isLoadingUserReels.value = false;
  // }

  // In your controller
  final RxInt currentSkip = 0.obs;
  final int limit = 10;
  final RxBool hasMoreReels = true.obs;

  Future<void> getPersonalReels() async {
    if (isLoadingUserReels.value || !hasMoreReels.value) return;

    isLoadingUserReels.value = true;

    try {
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'profile/reels/${loginCredential.getUserData().username}?skip=${currentSkip.value}&limit=$limit',
        responseDataKey: 'results',
      );

      if (apiResponse.isSuccessful) {
        List<VideoReel> newReels = (apiResponse.data as List)
            .map((e) => VideoReel.fromMap(e))
            .toList();
        reelsList.value
            .addAll(newReels); // Append new items instead of replacing

        // Check if there are more items to load
        if (newReels.length < limit) {
          hasMoreReels.value = false;
        } else {
          currentSkip.value += limit; // Increment skip for next call
        }
      }
    } catch (e) {
      debugPrint('Error loading reels: $e');
    } finally {
      isLoadingUserReels.value = false;
    }
  }

//======================================================== Repost Related Functions ===============================================//
  final RxInt currentRepostSkip = 0.obs;
  final int repostLimit = 10;
  final RxBool hasMoreRepostedReels = true.obs;
  Future getRepostVideo() async {
    if (isLoadingUserRepost.value || !hasMoreRepostedReels.value) return;
    isLoadingUserRepost.value = true;
    try {
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'get-reels-re-post-list/${userModel.username}?skip=$currentRepostSkip&limit=$repostLimit',
        responseDataKey: 'results',
      );

      if (apiResponse.isSuccessful) {
        List<VideoReel> newRepostedReels = (apiResponse.data as List)
            .map((e) => VideoReel.fromMap(e))
            .toList();
        repostList.value.addAll(newRepostedReels);
        // Check if there are more items to load
        if (newRepostedReels.length < repostLimit) {
          hasMoreRepostedReels.value = false;
        } else {
          currentRepostSkip.value +=
              repostLimit; // Increment skip for next call
        }
      }
    } catch (e) {
      debugPrint('Error loading reposted reels: $e');
    } finally {
      isLoadingUserRepost.value = false;
    }
  }
  //--------------------------------------- DELETE REPOST REELS ----------------------------//

  Future<void> deleteRepostReels(String mediaId) async {
    final ApiResponse response = await _apiCommunication.doDeleteRequest(
        apiEndPoint: 'delete-reels-re-post/$mediaId');
    if (response.isSuccessful) {
      getRepostVideo();
      Get.back();

      showSuccessSnackkbar(message: response.message ?? '');
    } else {
      showErrorSnackkbar(message: response.message ?? '');
    }
  }

//======================================================== Saved Reels Functions ===============================================//
  final RxInt currentSavedSkip = 0.obs;
  final int savedLimit = 10;
  final RxBool hasMoreSavedReels = true.obs;

  Future getSavedReels() async {
    if (isLoadingSavedReels.value || !hasMoreSavedReels.value) return;
    isLoadingSavedReels.value = true;
    try {
      ApiResponse apiResponse = await _reelsRepository.getMyBookmarkedReels(
        limit: savedLimit,
        skip: currentSavedSkip.value,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        List<ReelsModel> newSavedReels = apiResponse.data as List<ReelsModel>;
        savedReelsList.value.addAll(newSavedReels);
        savedReelsList.refresh();
        // Check if there are more items to load
        if (newSavedReels.length < savedLimit) {
          hasMoreSavedReels.value = false;
        } else {
          currentSavedSkip.value += savedLimit;
        }
      }
    } catch (e) {
      debugPrint('Error loading saved reels: $e');
    } finally {
      isLoadingSavedReels.value = false;
    }
  }

  //============================================= Get Shared Reels ==================================================//
// Future getSharedReels() async {
//   isLoadingUserSharedReels.value = true;
//   debugPrint('==========================get Reels Start');

//   // Adjusted API request
//   ApiResponse apiResponse = await _apiCommunication.doGetRequest(
//     apiEndPoint: 'profile/share-reels-list/${loginCredential.getUserData().username}',
//     responseDataKey: 'data', // Ensure this matches the key where `reels` resides in your API response
//   );

//   debugPrint('==========================get Reels After api call');
//   if (apiResponse.isSuccessful) {
//     debugPrint('==========================get Reels Before Model');
//     debugPrint('Response success');

//     // Map the response to SharedReelsModel
//     sharedReelsList.value = (apiResponse.data as List)
//     .map((e) => SharedReelsModel.fromMap(e as Map<String, dynamic>?)?.reels)
//     .whereType<SharedReelDetails>()
//     .toList();

//     debugPrint('Mapped Shared Reels List: ${sharedReelsList.value}');
//     debugPrint('==========================get Reels After model');
//   } else {
//     debugPrint('API call failed with error: ${apiResponse.message}');
//   }

//   isLoadingUserSharedReels.value = false;
// }

  //======================================================== Friend, Follower, Following Related Functions ===============================================//

  Future<void> getFriends() async {
    isLoadingFriendList.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-friend',
    );
    isLoadingFriendList.value = false;

    if (apiResponse.isSuccessful) {
      final data = apiResponse.data as Map<String, dynamic>;
      friendList.value =
          ((data['result']) as List)
              .map((element) => FriendModel.fromJson(element))
              .toList();
      // Update friend count from response if available
      if (data['friendCount'] != null) {
        friendCount.value = data['friendCount'] as int;
      } else {
        friendCount.value = friendList.value.length;
      }
      debugPrint(friendList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> blockFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'settings-privacy/block-user',
        requestData: {
          'block_user_id': userId,
        },
        enableLoading: true,
        errorMessage: 'block failed');

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      getFriends();
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> unfollowFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfollow-user',
      requestData: {
        'requestId': userId,
      },
      enableLoading: true,
      errorMessage: 'Unfriend failed',
    );

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      getFriends();
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> reportFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfriend-user',
      requestData: {
        'requestId': userId,
      },
      enableLoading: true,
      errorMessage: 'Unfriend failed',
    );

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      getFriends();
      // friendList.refresh();

      Get.snackbar('Success', 'Successfully Unfriend',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> getFollowingUserList() async {
    isLoadingFollowingList.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'following-list',
      requestData: {'username': '${loginCredential.getUserData().username}'},
    );
    isLoadingFollowingList.value = false;

    if (apiResponse.isSuccessful) {
      followingList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => FollowingUserModel.fromJson(element))
              .toList();
      debugPrint(followingList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> getFollowerUserList() async {
    isLoadingFollowerList.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'follower-list',
      requestData: {'username': '${loginCredential.getUserData().username}'},
    );
    isLoadingFollowerList.value = false;

    if (apiResponse.isSuccessful) {
      followerList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => FollowerUserModel.fromJson(element))
              .toList();
      debugPrint(followingList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    if (Get.arguments != null) {
      isFromReels = Get.arguments['isFromReels'];
      if (Get.arguments['isFromReels'] == 'true') {
        viewNumber.value = 3;
        viewReelsTabNumber.value = 0;
        userModel = loginCredential.getUserData();
        getPersonalReels();
        // getSharedReels();
        getRepostVideo();
      } else {
        userModel = loginCredential.getUserData();
        viewNumber.value = 0;
      }
    } else {
      userModel = loginCredential.getUserData();
    }

    postScrollController = ScrollController();
    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();
    initPostFilterList();
    getUserData();
    getPosts();
    getFriends();
    super.onInit();
  }

  void _scrollListener() async {
    if (postScrollController.position.pixels >=
        postScrollController.position.maxScrollExtent - 150) {
      // Determine which tab is active
      switch (viewNumber.value) {
        case 0: // Posts
          if (pageNo <= totalPageCount) {
            pageNo += 1;
            await getPosts();
          }
          break;

        case 1: // Photos
          if (photoPageNo <= totalPhotoPages) {
            photoPageNo += 1;
            await getPhotos();
          }
          break;

        // case 2: // Videos
        //   if (videoPageNo <= totalVideoPages) {
        //     videoPageNo += 1;
        //     await getUserVideos();
        //   }
        //   break;
      }
    }
  }

  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }

  void onTapEditPost(PostModel model) async {
    await Get.toNamed(Routes.EDIT_POST, arguments: model);
    postList.value.clear();
    getPosts();
  }

  void initPostFilterList() {
    postFilterYearList.value.clear();

    for (int index = DateTime.now().year; index >= 1980; index--) {
      postFilterYearList.value.add(index.toString());
    }
  }
}

extension on Object {
  operator [](String other) {}
}
