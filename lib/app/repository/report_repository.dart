import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../services/api_communication.dart';

class ReportRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  GET ALL REPORTS                                                      ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllReports() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-report-type',
      responseDataKey: 'results',
    );

    return apiResponse.copyWith(
        data: (apiResponse.data as List)
            .map(
              (e) => PageReportModel.fromMap(e),
            )
            .toList());
  }

// ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ?┃  ACTION --> REPORT A POST                                             ┃
// ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reportAPost(
      {required String post_id,
      required String report_type,
      required String description,
      required String report_type_id,
      required String id_key}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'save-post-report',
      enableLoading: true,
      requestData: {
        id_key: post_id,
        // post_id: post_id,
        'report_type': report_type,
        'report_type_id': report_type_id,
        'description': description,
      },
    );

    return apiResponse.copyWith(
        data:
            PageReportModel.fromMap(apiResponse.data as Map<String, dynamic>));
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION --> REPORT A REEL                                             ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reportAReelById({required String reelId, required String key}) async {
    final apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'reels/save-reels-re-post', requestData: {
      'reelsId': reelId,
      'key': key,
    });

    return apiResponse;
  }
}
