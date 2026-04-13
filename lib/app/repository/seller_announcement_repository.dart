import '../config/constants/api_constant.dart';
import '../models/seller_announcement_model.dart';
import '../models/api_response.dart';
import '../services/api_communication.dart';

class SellerAnnouncementRepository {
  final ApiCommunication _api = ApiCommunication();

  Future<({List<SellerAnnouncementModel> announcements, int total})>
      getAnnouncements({int page = 1, int limit = 10}) async {
    final ApiResponse res = await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/announcements',
      queryParameters: {'page': page, 'limit': limit},
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (res.isSuccessful && res.data != null) {
      final fullData = res.data as Map<String, dynamic>? ?? {};
      final dataSection = fullData['data'] as Map<String, dynamic>? ?? {};
      final list = (dataSection['announcements'] as List?)
              ?.map((e) =>
                  SellerAnnouncementModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [];
      final pagination =
          dataSection['pagination'] as Map<String, dynamic>? ?? {};
      return (announcements: list, total: pagination['total'] as int? ?? 0);
    }
    return (announcements: <SellerAnnouncementModel>[], total: 0);
  }
}
