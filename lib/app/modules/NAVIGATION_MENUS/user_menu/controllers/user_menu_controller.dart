import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/utils/logger/logger.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/api_response.dart';
import '../../../../models/user.dart';
import '../../../../models/user_all_pages_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/session_tracker.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';

class UserMenuController extends GetxController {
  late final LoginCredential loginCredential;
  Rx<UserModel?> userModel = Rx(null);

  void onTapSignOut() async{
    final bool = await SessionTracker().sendAndResetNow();
    Log.i('Session data sent successfully: $bool');
    loginCredential.clearLoginCredential();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onInit() {
    loginCredential = LoginCredential();
    userModel.value = loginCredential.getUserData();
    profileImage.value = LoginCredential().getUserData().profile_pic ?? '';
    profileName.value =
        '${LoginCredential().getUserData().first_name ?? ''} ${LoginCredential().getUserData().last_name ?? ''}';

    // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // !┃  THIS LINE BELLOW WAS ADDED DUE TO SOME REASON BY HANIF VI             ┃
    // !┃  BUT AT THIS POINT WE ARE NOT SURE WHY AND IT SEEMS WE DON'T NEED IT   ┃
    // !┃  SO ON HANIF VI's CALL I AM COMMENTING THIS OUT                        ┃
    // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    // Get.lazyPut(()=>TabViewController());
    super.onInit();
  }

  // User Profile switch segment ==========================================================================

  final ApiCommunication _apiCommunication = ApiCommunication();
  RxBool loading = true.obs;
  RxList<PageProfileInfo> listOfProfiles = <PageProfileInfo>[].obs;
  RxString profileImage = ''.obs;
  RxString profileName = ''.obs;
  Future<void> getAllPages() async {
    listOfProfiles.clear();
    loading.value = true;
    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'pages/list-for-page-switching',
      enableLoading: false,
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (response.isSuccessful) {
      loading.value = false;

      UserAllPagesModel userAllPagesModel =
          UserAllPagesModel.fromJson(response.data as Map<String, dynamic>);
      listOfProfiles.addAll(userAllPagesModel.myPages!);

      for (var element in listOfProfiles) {
        if (element.id!.compareTo(userModel.value!.id!) == 0) {
          element.isSelected = true;
        }
      }
      update();
    } else {
      debugPrint('Error updating personal details');
    }
  }

  Future<void> profileSwitch({String? id}) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'pages/login',
      enableLoading: true,
      responseDataKey: ApiConstant.FULL_RESPONSE,
      requestData: {'page_id': id},
    );

    if (response.isSuccessful) {
      //Setup profile switch mode
      // id == null --> original profile || id != null --> page account
      TabViewController tabViewController = Get.find<TabViewController>();
      tabViewController.tabControllerInitComplete.value = false;
      loginCredential.saveProfileSwitch(id == null ? false : true);

      tabViewController.reInitController();

      // Added this segment due to api response sending gender ID instead of gender model
      // as changing the model may effect multiple segments of the code.
      // Thus making the received user -> gender ---> null
      Map<String, dynamic> data = response.data as Map<String, dynamic>;
      data['user']['gender'] = null;
      debugPrint(
          'ACCESSSS TOKEN _______________________________ \n${data['accessToken']}');

      loginCredential.handleLoginCredential(data);
      userModel.value = loginCredential.getUserData();
      for (var element in listOfProfiles) {
        if (element.id!.compareTo(userModel.value!.id!) == 0) {
          element.isSelected = true;
        }
      }
      update();

      // showSuccessSnackkbar(message: 'Profile Switched Successful');
    } else {
      debugPrint('Error updating personal details');
    }
  }

// User Profile switch segment ==========================================================================
}
