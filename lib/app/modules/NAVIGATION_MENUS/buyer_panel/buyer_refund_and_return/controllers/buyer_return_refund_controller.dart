import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../buyer_order_details/models/buyer_order_details_model.dart';
import '../models/refund_details.dart';
import '../buyer_refund_and_return_details/models/refund_details_model.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../utils/snackbar.dart';

class BuyerReturnRefundController extends GetxController {
  late ApiCommunication _apiCommunication;

  late TextEditingController orderNumberController;
  TextEditingController returnProductController = TextEditingController();
  TextEditingController returnQuantityController = TextEditingController();
  List<TextEditingController> detailsController = [];
  RxString orderSuDetailsId = ''.obs;
  String? storeId;
  String? orderId;
  String? refundId;
  Rx<List<OrderDetails>> orderDetails = Rx([]);
  List<TextEditingController> productControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<int> initialQuantities =
      []; // Stores the initial quantity for each product

  var selectedImages = <File>[].obs;

  final ImagePicker _picker = ImagePicker();

  RxList<String> selectedProducts = <String>[].obs;

  List<String> reasons = ['Wrong item received', 'Damaged product', 'Other'];
  RxString selectedReason = ''.obs;

  RxBool isConfirmed = false.obs;
  RxBool isLoadingBuyerRefund = true.obs;
  Rx<BuyerOrderResultDetailModel?> buyerOrderDetailsData =
      Rx<BuyerOrderResultDetailModel?>(null);
  Rx<RefundResponse?> refundDetailsData = Rx<RefundResponse?>(null);
  //===========================Get Order Details =========================//

  Future<void> getBuyerOrderDetailsData() async {
    isLoadingBuyerRefund.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'results',
      apiEndPoint: 'market-place/order/show-for-buyer/$orderId/$storeId',
    );

    isLoadingBuyerRefund.value = false;

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
        debugPrint('Unexpected data format Buyer Data');
      }
    } else {
      debugPrint('Error fetching buyer  data');
    }

    buyerOrderDetailsData.refresh();
    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  void onProductSelected(String? selectedProductId) {
    if (selectedProductId != null &&
        !selectedProducts.contains(selectedProductId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add a new TextEditingController for the product name
        productControllers.add(TextEditingController(
          text: orderDetails.value
                  .firstWhere(
                      (product) => product.productId == selectedProductId)
                  .product
                  ?.productName ??
              '',
        ));

        // Get the initial quantity for the selected product
        final initialQuantity = orderDetails.value
                .firstWhere((product) => product.productId == selectedProductId)
                .quantity ??
            1; // Default to 1 if quantity is null

        // Add a new TextEditingController for quantity with the initial value
        final quantityController =
            TextEditingController(text: initialQuantity.toString());

        // Add a listener to restrict the input value to the initial quantity or less
        quantityController.addListener(() {
          final inputText = quantityController.text;
          if (inputText.isNotEmpty) {
            final inputValue = int.tryParse(inputText) ?? initialQuantity;

            if (inputValue > initialQuantity) {
              // Reset the value to the initial quantity if input exceeds it
              quantityController.text = initialQuantity.toString();
              quantityController.selection = TextSelection.fromPosition(
                TextPosition(offset: quantityController.text.length),
              );
              showErrorSnackkbar(
                  message:
                      'Quantity cannot exceed the available amount of $initialQuantity');
            }
          }
        });

        // Add the quantity controller to the list
        quantityControllers.add(quantityController);

        // Add a new TextEditingController for additional details for the new product
        detailsController.add(TextEditingController());
        selectedProducts.add(selectedProductId);
      });
    }
  }

  void removeSelectedProduct(String productId) {
    int index = selectedProducts.indexOf(productId);
    if (index != -1) {
      selectedProducts.removeAt(index);

      // Remove the corresponding controllers
      productControllers[index].dispose();
      quantityControllers[index].dispose();
      detailsController[index].dispose();

      productControllers.removeAt(index);
      quantityControllers.removeAt(index);
      detailsController.removeAt(index);
    }
  }

  void updateProductControllers() {
    productControllers.clear();
    quantityControllers.clear();
    initialQuantities.clear();

    for (String productId in selectedProducts) {
      final selectedProduct = orderDetails.value
          .firstWhere((product) => product.productId == productId);

      // Store the initial quantity
      final initialQuantity = selectedProduct.quantity ?? 1;
      initialQuantities.add(initialQuantity);

      // Create the quantity controller with the initial value
      final quantityController =
          TextEditingController(text: initialQuantity.toString());

      // Add a listener to restrict the user from inputting more than the initial quantity
      quantityController.addListener(() {
        final inputText = quantityController.text;
        if (inputText.isNotEmpty) {
          final inputValue = int.tryParse(inputText) ?? initialQuantity;

          if (inputValue > initialQuantity) {
            // Reset the value to the initial quantity if input exceeds it
            quantityController.text = initialQuantity.toString();
            quantityController.selection = TextSelection.fromPosition(
              TextPosition(offset: quantityController.text.length),
            );
            showErrorSnackkbar(
                message:
                    'Quantity cannot exceed the available amount of $initialQuantity');
          }
        }
      });

      productControllers.add(TextEditingController(
          text: selectedProduct.product?.productName ?? ''));
      quantityControllers.add(quantityController);
    }
  }

  //=========================== Pick Refund Images=========================//

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    selectedImages.addAll(images.map((image) => File(image.path)).toList());

    if (selectedImages.length > 5) {
      selectedImages.value = selectedImages.take(5).toList();
    }
  }
  //=========================== Remove Refund Images=========================//

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  List<Map<String, dynamic>> refundDetails = [];
  //=========================== Submit Refund Request =========================//

  Future<void> submitRefundRequestAPI({
    required List<RefundDetails> refundDetailsList,
    List<File>? imageFiles,
  }) async {
    debugPrint('Calling saveProductReview API...');

    final List<Map<String, dynamic>> refundDetailsJsonList =
        refundDetailsList.map((item) => item.toJson()).toList();

    final requestData = {
      'order_sub_details_id': orderSuDetailsId.value,
      'delivery_charge': 50,
      'note': 'd',
      'refund_details': jsonEncode(refundDetailsJsonList),
    };

    debugPrint('Request Data Before Sending: $requestData');

    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/order/save-refund',
      isFormData: true,
      fileKey: 'files',
      mediaFiles: imageFiles,
      requestData: requestData,
    );

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: '${apiResponse.message}');
      debugPrint('Refund Request Sent successfully.');
    } else {
      debugPrint('API Error Response: ${apiResponse.data}');
      showErrorSnackkbar(message: 'Already Applied for Refund');
      debugPrint('Failed to send refund request:::: ${apiResponse.data}');
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

  @override
  void onInit() {
    super.onInit();
    _apiCommunication = ApiCommunication();

    orderSuDetailsId.value = Get.arguments['orderSubDetailsId'];
    orderId = Get.arguments['orderId'];
    storeId = Get.arguments['storeId'];
    refundId = Get.arguments['refund_id'];
    orderDetails.value = Get.arguments['orderDetails'];
    orderNumberController = TextEditingController(text: orderId);
    getBuyerOrderDetailsData();
    getBuyerRefundDetailsData();
  }

  @override
  void onClose() {
    orderNumberController.dispose();
    super.onClose();
  }
}
