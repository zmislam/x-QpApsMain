import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/api_communication.dart';
import '../../marketplace/marketplace_products/models/all_product_model.dart';
import '../models/seller_order_data_model.dart';
import '../models/seller_order_list_model.dart';
import '../models/seller_payment_model.dart';

class SellerPanelDashboardController extends GetxController {
  late ApiCommunication _apiCommunication;
  RxBool isLoadingSellerDashboard = true.obs;
  RxBool isLoadingSellerOrderList = true.obs;
  RxBool isLoadingSellerProductList = true.obs;
  Rx<SellerOrderData?> sellerOrderData = Rx<SellerOrderData?>(null);

  Rx<List<SellerOrderModel>> sellerOrderList = Rx([]);
  RxList<AllProducts> productList = <AllProducts>[].obs;
  Rx<List<SellerDetailOrderList>> sellerDetailsOrderList = Rx([]);
  RxInt limitForOrder = 10.obs;
  RxInt skipForOrder = 0.obs;
  RxInt limitForProduct = 10.obs;
  RxInt skipForProduct = 0.obs;
  late ScrollController scrollControllerOrder;
  late ScrollController scrollControllerProduct;
  final RxBool isLoadingPayments = false.obs;
  final RxList<SellerOrderDataList> paymentList = <SellerOrderDataList>[].obs;
  final RxDouble pendingBalance = 0.0.obs;
  final RxDouble paidBalance = 0.0.obs;

//===========================Get Seller Dashboard Data==================================//
  Future<void> getSellerDashboardData() async {
    isLoadingSellerDashboard.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'data',
      apiEndPoint: 'market-place/order/seller-dashboard',
      // queryParameters: {'limit': 10};
    );

    isLoadingSellerDashboard.value = false;

    if (apiResponse.isSuccessful) {
      sellerOrderData.value =
          SellerOrderData.fromMap(apiResponse.data as Map<String, dynamic>);

      final ordersData = (apiResponse.data as Map<String, dynamic>)['orders'];
      if (ordersData is List) {
        sellerOrderList.value = ordersData
            .map((order) =>
                SellerOrderModel.fromMap(order as Map<String, dynamic>))
            .take(10)
            .toList();
      } else {
        sellerOrderList.value = [];
      }

      debugPrint(
          'Seller order data::::::::${sellerOrderData.value?.totalOrders.toString()}');
    } else {
      debugPrint('Error fetching seller dashboard data');
    }

    debugPrint(
        '-post-seller panel controller---------------------------$apiResponse');
  }

//===========================Get Seller Payments Data==================================//
  Future<void> fetchSellerPayments() async {
    isLoadingSellerDashboard.value = true;

    try {
      final response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'market-place/seller/payment-list',
      );

      if (response.isSuccessful && response.data is List<dynamic>) {
        final List<dynamic> responseData = response.data as List<dynamic>;

        final List<SellerOrderDataList> parsedData = responseData
            .map((item) =>
                SellerOrderDataList.fromMap(item as Map<String, dynamic>?))
            .toList();

        paymentList.assignAll(parsedData);
      } else {
        debugPrint(
            "Failed to fetch payments: ${response.message ?? 'Unknown error'}");
      }
    } catch (e) {
      debugPrint('Error fetching payments: $e');
    } finally {
      isLoadingSellerDashboard.value = false;
    }
  }

//===========================Get  Seller Order List==================================//
  Future<void> getSellerDetailsOrderListData({
    bool isLoadMoreOrder = false,
    String? status,
    String? fromDate,
    String? toDate,
  }) async {
    isLoadingSellerOrderList.value = true;

    try {
      if (!isLoadMoreOrder) {
        skipForOrder.value = 0;
      }

      // Build the query parameters
      String queryParams = '';
      if (status != null) {
        queryParams += '&status=$status';
      }
      if (fromDate != null) {
        queryParams += '&from_date=$fromDate';
      }
      if (toDate != null) {
        queryParams += '&to_date=$toDate';
      }

      final apiResponse = await _apiCommunication.doGetRequest(
        responseDataKey: 'results',
        apiEndPoint:
            'market-place/order/list-for-seller?limit=${limitForOrder.value}&skip=${skipForOrder.value * limitForOrder.value}$queryParams',
      );

      if (apiResponse.isSuccessful) {
        final responseData = apiResponse.data as List<dynamic>;
        List<SellerOrderList> parsedResults = responseData
            .map(
                (item) => SellerOrderList.fromMap(item as Map<String, dynamic>))
            .toList();

        if (isLoadMoreOrder) {
          sellerDetailsOrderList.value.addAll(parsedResults.isNotEmpty
              ? parsedResults.first.orderList ?? []
              : []);
        } else {
          sellerDetailsOrderList.value = parsedResults.isNotEmpty
              ? parsedResults.first.orderList ?? []
              : [];
        }

        if (parsedResults.isNotEmpty) {
          skipForOrder++;
        }
      } else {
        debugPrint('Error fetching seller dashboard data');
      }
    } catch (e) {
      debugPrint('Error parsing seller order list data: $e');
    } finally {
      isLoadingSellerOrderList.value = false;
    }
  }

//========================Seller  All Products List ============================================//

  Future<void> fetchSellerProducts({
    bool isLoadMoreProduct = false,
    String status = '',
    String keyword = '',
  }) async {
    isLoadingSellerProductList.value = true;

    try {
      if (!isLoadMoreProduct) {
        skipForProduct.value = 0;
      }

      String queryParams =
          'limit=$limitForProduct&skip=${skipForProduct.value * limitForProduct.value}';

      // Apply filters
      if (status.isNotEmpty) {
        queryParams += '&status=$status';
      }

      if (keyword.isNotEmpty) {
        queryParams += '&keyword=$keyword';
      }

      final response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'market-place/get-my-products?$queryParams',
        responseDataKey: 'data',
      );

      if (response.isSuccessful) {
        final fetchedData = response.data as List<dynamic>;
        final parsedData =
            fetchedData.map((item) => AllProducts.fromMap(item)).toList();

        if (isLoadMoreProduct) {
          if (parsedData.isNotEmpty) {
            productList.addAll(parsedData);
            skipForProduct.value++;
          } else {
            debugPrint('No more products to load.');
          }
        } else {
          productList.assignAll(parsedData);
          skipForProduct.value = parsedData.isNotEmpty ? 1 : 0;
        }

        if (parsedData.isNotEmpty) {
          skipForProduct++;
        }
      } else {
        debugPrint('Failed to fetch products: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      isLoadingSellerProductList.value = false;
    }
  }

//========================Seller  Order Date Picker  ============================================//

  Future<void> showDateRangePickerDialog(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 7)),
      ),
    );

    if (picked != null) {
      String fromDate = formatDate(picked.start);
      String toDate = formatDate(picked.end);

      _applyDateFilter(fromDate, toDate);
    }
  }

  void _applyDateFilter(String fromDate, String toDate) {
    getSellerDetailsOrderListData(fromDate: fromDate, toDate: toDate);
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
//====================================End===========================================//

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    scrollControllerOrder = ScrollController();
    scrollControllerProduct = ScrollController();
    getSellerDashboardData();
    getSellerDetailsOrderListData();
    fetchSellerProducts();
    fetchSellerPayments();
    scrollControllerOrder.addListener(() {
      if (scrollControllerOrder.position.pixels >=
          scrollControllerOrder.position.maxScrollExtent - 100) {
        getSellerDetailsOrderListData(isLoadMoreOrder: true);
      }
    });
    scrollControllerProduct.addListener(() {
      if (scrollControllerProduct.position.pixels >=
          scrollControllerProduct.position.maxScrollExtent - 100) {
        fetchSellerProducts(isLoadMoreProduct: true);
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollControllerOrder.dispose();
    scrollControllerProduct.dispose();
    super.onClose();
  }
}
