import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/buyer_complaint_model.dart';
import '../models/buyer_dashboard_card_model.dart';
import '../models/buyer_order_model.dart';
import '../models/buyer_refund_list_model.dart';
import '../models/buyer_review_model.dart';
import '../../../../../services/api_communication.dart';

class BuyerPanelDashboardController extends GetxController {
  late ApiCommunication _apiCommunication;
  RxBool isLoadingBuyerDashboard = true.obs;
  Rx<BuyerOrderData?> buyerOrderData = Rx<BuyerOrderData?>(null);

  Rx<List<BuyerOrderResult>> buyerOrderList = Rx([]);
  Rx<List<BuyerComplaintModel>> complaintList = Rx([]);
  Rx<List<RefundDetailsModel>> refundList = Rx([]);
  Rx<List<BuyerReviewModel>> reviewList = Rx([]);


//===========================Get Buyer Dashboard Data==================================//

Future<void> getBuyerDashboardData() async {
  isLoadingBuyerDashboard.value = true;

  final apiResponse = await _apiCommunication.doGetRequest(
    responseDataKey: 'data',
    apiEndPoint: 'market-place/order/buyer-dashboard',
    // queryParameters: {'limit': 10});
  );

  isLoadingBuyerDashboard.value = false;

  if (apiResponse.isSuccessful) {
    buyerOrderData.value = BuyerOrderData.fromMap(apiResponse.data as Map<String, dynamic>);
    buyerOrderData.refresh();
  } else {
    debugPrint('Error fetching buyer dashboard data');
  }

  debugPrint('-post-home controller---------------------------$apiResponse');
}
//===========================Get Buyer Review Data==================================//

Future<void> getBuyerReviewData() async {
  isLoadingBuyerDashboard.value = true;

  final apiResponse = await _apiCommunication.doGetRequest(
    responseDataKey: 'data',
    apiEndPoint: 'market-place/buyer/all-review?skip=0&limit=1000',
  );

  isLoadingBuyerDashboard.value = false;

  if (apiResponse.isSuccessful) {
    // Check if apiResponse.data is a list and parse it
    if (apiResponse.data is List) {
      reviewList.value = (apiResponse.data as List)
          .map((review) => BuyerReviewModel.fromMap(review as Map<String, dynamic>))
          .toList();
      reviewList.refresh();
    } else {
      debugPrint('Unexpected data format');
    }
  } else {
    debugPrint('Error fetching buyer Review data');
  }

  debugPrint('-Buyer Dashboard controller---------------------------$apiResponse');
}
//===========================Get Buyer Complaint Data==================================//

Future<void> getBuyerComplaintData() async {
  isLoadingBuyerDashboard.value = true;

  final apiResponse = await _apiCommunication.doGetRequest(
    responseDataKey: 'data',
    apiEndPoint: 'market-place/buyer/complaint-list',
  );

  isLoadingBuyerDashboard.value = false;

  if (apiResponse.isSuccessful) {
    // Check if apiResponse.data is a list and parse it
    if (apiResponse.data is List) {
      complaintList.value = (apiResponse.data as List)
          .map((review) => BuyerComplaintModel.fromMap(review as Map<String, dynamic>))
          .toList();
      complaintList.refresh();
    } else {
      debugPrint('Unexpected data format');
    }
  } else {
    debugPrint('Error fetching buyer Complaint data');
  }

  debugPrint('-Buyer Dashboard controller---------------------------$apiResponse');
}
//===========================Get Buyer Refund Data==================================//

Future<void> getBuyerRefundData() async {
  isLoadingBuyerDashboard.value = true;

  final apiResponse = await _apiCommunication.doGetRequest(
    responseDataKey: 'results',
    apiEndPoint: 'market-place/order/refund-list-for-buyer?skip=0&limit=1000',
  );

  isLoadingBuyerDashboard.value = false;

  if (apiResponse.isSuccessful) {
    // Check if apiResponse.data is a list and parse it
    if (apiResponse.data is List) {
      refundList.value = (apiResponse.data as List)
          .map((review) => RefundDetailsModel.fromMap(review as Map<String, dynamic>))
          .toList();
      refundList.refresh();
    } else {
      debugPrint('Unexpected data format');
    }
  } else {
    debugPrint('Error fetching buyer Refund List data');
  }

  debugPrint('-Buyer Dashboard controller---------------------------$apiResponse');
}

//===========================Get Buyer Buyer Order List==================================//

Future<void> getBuyerOrderData() async {
  isLoadingBuyerDashboard.value = true;

  final apiResponse = await _apiCommunication.doGetRequest(
    responseDataKey: 'results',
    apiEndPoint: 'market-place/order/list-for-buyer?limit=1000&skip=0',
  );

  isLoadingBuyerDashboard.value = false;

  if (apiResponse.isSuccessful) {
    buyerOrderList.value = (apiResponse.data as List<dynamic>)
        .map((item) => BuyerOrderResult.fromMap(item as Map<String, dynamic>))
        .toList();
  } else {
    debugPrint('Error fetching buyer dashboard data');
  }

  debugPrint('-post-home controller---------------------------$apiResponse');
}


 

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
     getBuyerDashboardData();
     getBuyerOrderData();
     getBuyerReviewData();
     getBuyerComplaintData();
     getBuyerRefundData();
    super.onInit();
  }
}
