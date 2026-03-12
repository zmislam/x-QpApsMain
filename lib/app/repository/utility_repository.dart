import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../models/location_model.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_cart/models/address_book_model.dart';
import '../services/api_communication.dart';

class UtilityRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL ADDRESS POINTS                                               ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllAddressesInList() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/order/address-list',
      enableCache: true,
      timeToLiveInSeconds: 3600 * 24 * 10,
    );
    return apiResponse.copyWith(
      data: (apiResponse.data as List).map((e) => MyAddressData.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  LOCATION SEARCH                                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getTargetLocationWithSearch({required String? locationName}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'global-search-location?search=$locationName',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    return apiResponse.copyWith(
      data: apiResponse.data != null ? (((apiResponse.data as Map<String, dynamic>)['results']) as List).map((element) => AllLocation.fromJson(element)).toList() : [],
    );
  }
}
