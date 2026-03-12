import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/api_constant.dart';
import 'package:quantum_possibilities_flutter/app/modules/earnDashboard/model/earningPointsModel.dart';
import 'package:quantum_possibilities_flutter/app/services/api_communication.dart';
import '../../../data/login_creadential.dart';
import '../model/earningSummaryModel.dart';
import '../model/earningTop3SummaryModel.dart';

class EarnDashboardController extends GetxController {
  late final ApiCommunication _apiCommunication;
  final earningPoints = Rxn<EarningPointsResult>();
  final earningSummary = Rxn<EarningSummaryResult>();
  final earningTop3Summary = Rxn<EarningTop3Summary>();

  final dio = Dio(BaseOptions(
    baseUrl: ApiConstant.BASE_URL,
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchEarningData();
    await fetchEarningSummaryData();
    await fetchEarningTop3SummaryData();
  }

  final LoginCredential _loginCredential = LoginCredential();

  // Get token method
  String? getToken() {
    return _loginCredential.getAccessToken();
  }

  // Fetch data from API
  Future<void> fetchEarningData() async {
    try {
      isLoading.value = true;
      final token = getToken();
      final response = await dio.get(
        'post/earning-points',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final model = EarningPointsModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (model.result != null && model.result!.isNotEmpty) {
          earningPoints.value = model.result!.first;
        } else {
          debugPrint('❌ Result is null or empty');
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch data: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Redirect to login
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch earning data: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      Get.snackbar(
        'Error',
        'Failed to fetch earning data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEarningSummaryData() async {
    try {
      isLoading.value = true;
      final token = getToken();
      final response = await dio.get(
        'post/earning-summary',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final model = EarningSummaryModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (model.results != null && model.results!.isNotEmpty) {
          earningSummary.value = model.results!.first;
        } else {
          debugPrint('❌ Result is null or empty');
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch data: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Redirect to login
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch earning data: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      Get.snackbar(
        'Error',
        'Failed to fetch earning data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEarningTop3SummaryData() async {
    try {
      isLoading.value = true;
      final token = getToken();
      final response = await dio.get(
        'post/earning-top-three-summary',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final model = EarningTop3SummaryModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (model.results != null) {
          earningTop3Summary.value = model.results!;
        } else {
          debugPrint('❌ Result is null or empty');
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch data: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Redirect to login
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch earning data: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      Get.snackbar(
        'Error',
        'Failed to fetch earning data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  // Refresh data
  Future<void> refreshData() async {
    await fetchEarningData();
  }
}
