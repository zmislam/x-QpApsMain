import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/buyer_order_details_model.dart';
import '../models/buyer_order_tracking_model.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../utils/snackbar.dart';

class BuyerOrderDetailsController extends GetxController {
  late ApiCommunication _apiCommunication;
  RxBool isLoadingBuyerDashboard = true.obs;
  Rx<BuyerOrderResultDetailModel?> buyerOrderDetailsData =
      Rx<BuyerOrderResultDetailModel?>(null);
  //  Rx<OrderTrackingDetails?> buyerOrderTrackingData = Rx<OrderTrackingDetails?>(null);
  var orderTrackingDetails = OrderTrackingDetails().obs;
  String? storeId;
  String? orderId;
  RxBool isDeliverd = false.obs;
  RxDouble rating = 4.0.obs;
  RxString orderSubDetailsId = ''.obs;
  TextEditingController reviewTitleController = TextEditingController();
  TextEditingController reviewDescriptionController = TextEditingController();
  var selectedImages = <File>[].obs;
  RxList<OrderDetails> orderDetails = <OrderDetails>[].obs;

  final ImagePicker _picker = ImagePicker();
  //===========================Get Order Details =========================//

  Future<void> getBuyerOrderDetailsData() async {
    isLoadingBuyerDashboard.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'results',
      apiEndPoint: 'market-place/order/show-for-buyer/$orderId/$storeId',
    );

    isLoadingBuyerDashboard.value = false;

    if (apiResponse.isSuccessful) {
      if (apiResponse.data is List) {
        final dataList = apiResponse.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          buyerOrderDetailsData.value = BuyerOrderResultDetailModel.fromMap(
              dataList.first as Map<String, dynamic>);
        }
      } else if (apiResponse.data is Map<String, dynamic>) {
        buyerOrderDetailsData.value = BuyerOrderResultDetailModel.fromMap(
            apiResponse.data as Map<String, dynamic>);
      } else {
        debugPrint('Unexpected data format Order Tracking');
      }
    } else {
      debugPrint('Error fetching buyer  data');
    }

    buyerOrderDetailsData.refresh();
    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  //=========================== Pick Review Images=========================//

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    selectedImages.addAll(images.map((image) => File(image.path)).toList());

    if (selectedImages.length > 5) {
      selectedImages.value = selectedImages.take(5).toList();
    }
  }
  //=========================== Remove Review Images=========================//

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  //=========================== Submit Product Review =========================//
  Future<void> saveProductReview({
    required String productId,
    required String title,
    required String description,
    required double rating,
    required String orderId,
    List<File>? imageFiles,
  }) async {
    debugPrint('Calling saveProductReview API...');

    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/buyer/save-product-review',
      isFormData: true,
      fileKey: 'files',
      mediaFiles: imageFiles,
      requestData: {
        'product_id': productId,
        'title': title,
        'description': description,
        'rating': rating,
        'order_id': orderId,
      },
    );

    debugPrint('API Response status code: ${apiResponse.statusCode}');
    debugPrint('API Response success: ${apiResponse.isSuccessful}');
    debugPrint('API Response message: ${apiResponse.message}');

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: '${apiResponse.message}');
      debugPrint('Review saved successfully.');
    } else {
      showErrorSnackkbar(message: 'apiResponse.message');
      debugPrint('Failed to save review.');
    }
  }

  //=========================== Order Activity/ Tracking =========================//
  Future<void> fetchOrderTrackingData() async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/order/tracking-details',
      requestData: {
        'store_id': storeId,
        'order_id': orderId,
      },
    );

    if (apiResponse.isSuccessful) {
      if (apiResponse.data is List) {
        orderTrackingDetails.value = OrderTrackingDetails(
          data: (apiResponse.data as List<dynamic>)
              .map((item) =>
                  OrderTrackingData.fromMap(item as Map<String, dynamic>))
              .toList(),
        );
      } else if (apiResponse.data is Map<String, dynamic>) {
        orderTrackingDetails.value = OrderTrackingDetails.fromMap(
            apiResponse.data as Map<String, dynamic>);
      } else {
        debugPrint('Unexpected Order Tracking format');
      }
    } else {
      debugPrint('Unexpected Order Tracking format');
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    orderId = Get.arguments['orderId'];
    storeId = Get.arguments['storeId'];
    getBuyerOrderDetailsData();
    fetchOrderTrackingData();
    super.onInit();
  }

  @override
  void onClose() {
    // Clear data when bottom sheet is disposed
    rating.value = 0.0;
    reviewTitleController.clear();
    reviewDescriptionController.clear();
    selectedImages.clear();
    super.onClose();
  }
}
