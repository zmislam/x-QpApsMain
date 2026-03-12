import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../data/login_creadential.dart';
import '../models/refund_chat_model.dart';
import '../models/refund_details_model.dart';
import '../../../../../../services/api_communication.dart';
import '../../../../../../utils/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class BuyerReturnRefundDetailsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredentials;

  String? refundId;

  final TextEditingController messageController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  final ImagePicker picker = ImagePicker();

  RxBool isLoadingBuyerRefund = true.obs;

  Rx<RefundResponse?> refundDetailsData = Rx<RefundResponse?>(null);
  RxList<RefundChatResult?> chatMessages = RxList<RefundChatResult?>([]);

  final List<File> selectedImages = [];
//=======================Pick Image==================================//
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(File(pickedFile.path));
      debugPrint('Image selected: ${pickedFile.path}');
    } else {
      debugPrint('No image selected');
    }
  }

//============================== Save The QR===================================//
  Future<void> saveQrCode() async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isGranted) {
        // Capture the screenshot as a Uint8List
        final Uint8List? image = await screenshotController.capture();

        if (image != null) {
          // Get directory to save the image
          final Directory directory = await getExternalStorageDirectory() ??
              await getTemporaryDirectory();
          final String path =
              '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';

          // Save the file
          final File file = File(path);
          await file.writeAsBytes(image);

          Get.snackbar('Success', 'QR code saved to $path!',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', 'Failed to capture QR code!',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Permission Denied',
            'Storage permission is required to save the QR code.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving the QR code!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
//===========================Get Refund Details =========================//

  Future<void> getBuyerRefundDetailsData() async {
    isLoadingBuyerRefund.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'results',
      apiEndPoint: 'market-place/order/refund-details/$refundId',
    );

    isLoadingBuyerRefund.value = false;

    if (apiResponse.isSuccessful) {
      if (apiResponse.data is List) {
        final dataList = apiResponse.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          refundDetailsData.value =
              RefundResponse.fromMap(dataList.first as Map<String, dynamic>);
        }
      } else if (apiResponse.data is Map<String, dynamic>) {
        refundDetailsData.value =
            RefundResponse.fromMap(apiResponse.data as Map<String, dynamic>);
      } else {
        debugPrint('Unexpected data format Buyer Refund Data');
      }
    } else {
      debugPrint('Error fetching buyer  Refund data');
    }

    // buyerOrderDetailsData.refresh();
    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  var selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

//===========================Get Refund Chat Messeges =========================//

  Future<void> getBuyerRefundChatData(String refundId) async {
    isLoadingBuyerRefund.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'results',
      apiEndPoint: 'market-place/order/get-refund-chat/$refundId',
    );

    isLoadingBuyerRefund.value = false;

    if (apiResponse.isSuccessful) {
      if (apiResponse.data is List) {
        final dataList = apiResponse.data as List<dynamic>;
        chatMessages.value = dataList
            .map((data) =>
                RefundChatResult.fromMap(data as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('Unexpected data format for chat data');
      }
    } else {
      debugPrint('Error fetching chat data');
    }
  }

//=========================== Send Refund Message =============================//
  Future<void> sendRefundChatMessages({
    required String refundId,
    required String messageText,
    List<File>? imageFiles,
  }) async {
    debugPrint('Submitting refund chat message...');

    final requestData = {
      'refund_id': refundId,
      'text': messageText,
    };

    debugPrint('Request Data Before Sending: $requestData');

    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/order/refund-chat',
      isFormData: true,
      fileKey: 'files',
      mediaFiles: imageFiles,
      requestData: requestData,
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: '${apiResponse.message}');
      getBuyerRefundChatData(refundDetailsData.value?.id ?? '');
      debugPrint('Refund chat message sent successfully.');
    } else {
      debugPrint('API Error Response: ${apiResponse.data}');
      showErrorSnackkbar(message: 'Failed to send chat message');
      debugPrint('Failed to send refund chat message: ${apiResponse.data}');
    }
  }

  void sendChatMessage() async {
    String messageText = messageController.text.trim();
    List<File> selectedImages = [];

    if (messageText.isEmpty && selectedImages.isEmpty) {
      showErrorSnackkbar(message: 'Please enter a message or select an image');
      return;
    }

    await sendRefundChatMessages(
      refundId: refundId ?? '',
      messageText: messageText,
      imageFiles: selectedImages,
    );

    messageController.clear();
    // Refresh or update chat messages here if needed
  }

  @override
  void onInit() {
    super.onInit();
    _apiCommunication = ApiCommunication();
    loginCredentials = LoginCredential();

    refundId = Get.arguments['refund_id'];

    getBuyerRefundDetailsData();
    getBuyerRefundChatData(refundId ?? '');
  }
}
