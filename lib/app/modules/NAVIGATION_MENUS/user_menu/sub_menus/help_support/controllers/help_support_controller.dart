import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/full_help_reply_model.dart';
import '../../../../../../models/help_model.dart';
import '../../../../../../models/help_reply_model.dart';
import '../../../../../../services/api_communication.dart';
import '../../../../../../utils/snackbar.dart';

class HelpSupportController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  TextEditingController messageInputController = TextEditingController();

  Rx<List<HelpModel>> helpSupportList = Rx([]);
  Rx<List<HelpReplyModel>> helpSupportMessageList = Rx([]);
  Rx<List<XFile>> xfiles = Rx([]);
  Rx<List<String>> complainList = Rx([]);
  var helpReplyModel = FullHelpReplyModel().obs;
  RxString filterStatus = ''.obs;
  RxString filterSearch = ''.obs;

  RxString complainerName = ''.obs;
  RxString complainDescription = ''.obs;
  RxString complainType = ''.obs;

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    XFile? mediaXFiles = await picker.pickMedia();
    xfiles.value.clear();
    xfiles.value.add(mediaXFiles!);
    xfiles.refresh();
  }

  Future<void> createTicket() async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'support/save-help',
      isFormData: true,
      enableLoading: true,
      fileKey: 'files',
      requestData: {
        'description': complainDescription.value,
        'topics': complainType.value,
        'name': complainerName.value,
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      xfiles.value.clear();
      Get.back();
      showSuccessSnackkbar(message: 'Ticket create successfully');
    } else {
      debugPrint('');
    }
  }

  Future<void> replyTicket(String id) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'support/save-help-reply',
      isFormData: true,
      enableLoading: true,
      fileKey: 'files',
      requestData: {
        'description': messageInputController.text,
        'help_id': id,
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      xfiles.value.clear();
      xfiles.refresh();
      messageInputController.clear();
    } else {
      debugPrint('');
    }
  }

  Future<void> getHelpSupportList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'support/my-help-list?status=$filterStatus&search=$filterSearch',
    );
    if (apiResponse.isSuccessful) {
      helpSupportList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => HelpModel.fromJson(element))
              .toList();
      helpSupportList.refresh();
    } else {}
  }

  Future<void> getHelpComplaintList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'support/get-help-center-topic-active-list',
    );

    if (apiResponse.isSuccessful) {
      List complainData =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List);
      for (int i = 0; i < complainData.length; i++) {
        complainList.value.add(complainData[i]['title']);
      }
    } else {}
  }

  Future<void> getHelpSupportMessageList(String ticketId) async {
    final apiResponse = await _apiCommunication.doGetRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'support/get-help-details-by-id/$ticketId',
        enableLoading: true);
    if (apiResponse.isSuccessful) {
      helpSupportMessageList.value.clear();

      helpSupportMessageList.value = (((apiResponse.data
              as Map<String, dynamic>)['results']['helpcenterreplies']) as List)
          .map((element) => HelpReplyModel.fromJson(element))
          .toList();

      helpSupportMessageList.refresh();

      helpReplyModel.value = FullHelpReplyModel.fromJson(
          ((apiResponse.data as Map<String, dynamic>)['results']));
    } else {}
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    getHelpSupportList();
    getHelpComplaintList();
    super.onInit();
  }
}
