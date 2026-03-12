import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../../repository/report_repository.dart';

import '../../data/login_creadential.dart';
import '../../models/api_response.dart';
import '../../models/chat/chat_model.dart';
import '../../models/user.dart';
import '../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../services/api_communication.dart';
import '../../utils/chat_utils/chat_utils.dart';
import '../../utils/snackbar.dart';

class ShareController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final UserModel currentUserModel;
  late final TextEditingController shareDescriptionController;
  Rx<List<ChatModel>> messengerUserList = Rx([]);
  Rx<List<ChatModel>> messengerUserSearchList = Rx([]);
  Rx<bool> isSend = false.obs;

  ReportRepository reportRepository = ReportRepository();

  //* ================================================================= Global =================================================================

  void searchChats(String query) {
    debugPrint('======= search: $query =======');
    messengerUserSearchList.value = messengerUserList.value
        .where((chatModel) =>
            (getRequiredInfoFromChat(chatModel, currentUserModel.id ?? '')
                        .username ??
                    '')
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()))
        .toList();
    messengerUserSearchList.refresh();
  }

  // =============================== fetch messenger user list data =================================
  Future<void> getMessengerUserData() async {
    ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'chats/for-app?chat_type=friends',
    );

    if (response.isSuccessful) {
      messengerUserList.value =
          (response.data as List).map((e) => ChatModel.fromMap(e)).toList();
      messengerUserList.refresh();
    } else {}
  }

  Future<void> sendMessage(String chatId, String url) async {
    ApiResponse response = await _apiCommunication.doPostRequest(
      isFormData: true,
      apiEndPoint: 'messages/$chatId',
      requestData: {
        'app_name': 'apps',
        'content': url,
      },
    );
    if (response.isSuccessful) {
      Get.back();
    }
  }

  Future<void> sendMutipleMessage(String url) async {
    isSend.value = true;

    for (ChatModel chatModel in messengerUserList.value) {
      if (chatModel.isSelected == true) {
        ApiResponse response = await _apiCommunication.doPostRequest(
          isFormData: true,
          apiEndPoint: 'messages/${chatModel.id ?? ''}',
          requestData: {
            'app_name': 'apps',
            'content': url,
          },
        );
        if (response.isSuccessful) {
          chatModel.isSelected = false;
          Get.back();
        }
      }
    }

    isSend.value = false;
  }
//=================================Report==================================//

  //--------------------------------------- Report ----------------------------//
  //===================================Fetch All Report List===========================//
  RxBool isLoadingReport = false.obs;
  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  late TextEditingController reportDescription;

  Future<void> getReports() async {
    isLoadingReport.value = true;
    ApiResponse apiResponse = await reportRepository.getAllReports();

    if (apiResponse.isSuccessful) {
      pageReportList.value =
          List.from(apiResponse.data as List<PageReportModel>);
    }
    isLoadingReport.value = false;
  }
//=======================================Report A Post ============================================//

  Future<void> reportAPost(
      {String? post_id,
      String? id_key,
      String? chat_id,
      String? to_user_id,
      String? reels_id,
      required String report_type,
      required String description,
      required String report_type_id}) async {
    debugPrint('=================Report Start==========================');

    final apiResponse = await reportRepository.reportAPost(
        id_key: id_key ?? 'post_id',
        post_id: post_id ?? '',
        report_type: report_type,
        description: description,
        report_type_id: report_type_id);

    debugPrint(
        '=================Report Api call end==========================');
    debugPrint(
        '=================Report Api status Code ${apiResponse.message}==========================');
    debugPrint(
        '=================Report Api success ${apiResponse.isSuccessful}==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '=================Report Successful==========================');

      Get.back();
      Get.back();
      showSuccessSnackkbar(message: apiResponse.message ?? '');
    } else {
      showErrorSnackkbar(message: apiResponse.message ?? '');
    }
  }
  //========================================Repost================================//

  //* ================================================================= Reels Specific =================================================================

  Future<void> repostReels(String reelId, String key) async {
    ApiResponse apiResponse =
        await reportRepository.reportAReelById(reelId: reelId, key: key);

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: apiResponse.message ?? '');
    } else {
      showErrorSnackkbar(message: apiResponse.message ?? '');
    }
  }

  Future<void> shareReelsOnNewsFeed(String reelsId, String key) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'reels/save-share-reels', requestData: {
      'description': shareDescriptionController.text,
      'reels_privacy': 'public',
      'share_reels_id': reelsId,
      'key' : key,
    });

    if (apiResponse.isSuccessful) {
      shareDescriptionController.clear();
      Get.back();
      showSuccessSnackkbar(message: 'Your Reels has been shared');
    }
  }

  //* ================================================================= Post Specific =================================================================

  Future<void> shareUserPost(String sharePostId, {String? desciption}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-share-post-with-caption',
        requestData: {
          'share_post_id': sharePostId,
          'description': desciption,
          'privacy': 'public',
        });

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Your post has been shared');
      shareDescriptionController.clear();
      Get.find<HomeController>().refreshEdgeRankFeed();
    } else {}
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    shareDescriptionController = TextEditingController();
    reportDescription = TextEditingController();
    currentUserModel = LoginCredential().getUserData();
    getMessengerUserData();
    super.onInit();
  }

  @override
  void dispose() {
    _apiCommunication.endConnection();
    shareDescriptionController.dispose();
    super.dispose();
  }
}
