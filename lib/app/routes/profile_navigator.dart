// // //_|_|                                                                          |_|
// // //_|_|                                                                          |_|
// // //_|_|   Navigate to Page-Profile                                               |_|
// // //_|_|                                                                          |_|
// // //_|_|                                                                          |_|

import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/repository/page_repository.dart';
import '../data/login_creadential.dart';
import '../models/api_response.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/model/page_profile_model.dart';
import 'app_pages.dart';

class ProfileNavigator {
  static void navigateToProfile(
      {required String username,
      String? isFromReels,
      String? isFromPageReels}) async {
    try {
      final response =
          await PageRepository().getPageDetailsByName(name: username);

      if (_isValidPageResponse(response)) {
        _navigateToPageProfile(response.data as Map<String, dynamic>, username,
            isFromPageReels ?? 'false');
      } else {
        navigateToIndividualProfile(
            userName: username, isFromReels: isFromReels ?? 'false');
      }
    } catch (e) {
      navigateToIndividualProfile(
          userName: username, isFromReels: isFromReels ?? 'false');
    }
  }

  static bool _isValidPageResponse(ApiResponse response) {
    return response.isSuccessful &&
        response.data != null &&
        response.data is Map<String, dynamic>;
  }

  static void _navigateToPageProfile(
      Map<String, dynamic> data, String pageUserName, String isFromPageReels) {
    final pageProfileModel = PageProfileModel.fromMap(data);
    final route = pageProfileModel.role == 'admin'
        ? Routes.ADMIN_PAGE
        : Routes.PAGE_PROFILE;

    Get.toNamed(route, arguments: {
      'pageUserName': pageUserName,
      'isFromPageReels': isFromPageReels
    });
  }

  static void navigateToIndividualProfile(
      {required String userName, required String isFromReels}) {
    final isSelfProfile =
        userName == LoginCredential().getUserData().username &&
            !LoginCredential().getProfileSwitch();

    Get.toNamed(
      isSelfProfile ? Routes.PROFILE : Routes.OTHERS_PROFILE,
      arguments: {'username': userName, 'isFromReels': isFromReels},
    );
  }
}
