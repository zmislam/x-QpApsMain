import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/api_constant.dart';
import '../../../models/api_response.dart';
import '../../../models/profile_model.dart';
import '../../../services/api_communication.dart';
import '../../../services/init_service.dart';
import '../../../services/socket_service.dart';

import '../../../components/share/share_controller.dart';
import '../../../data/login_creadential.dart';
import '../../../services/wallet_management_service.dart';
import '../../../utils/dialog.dart';
import '../../NAVIGATION_MENUS/friend/controllers/friend_controller.dart';
import '../../NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../NAVIGATION_MENUS/marketplace/marketplace_cart/controllers/cart_controller.dart';
import '../../NAVIGATION_MENUS/marketplace/marketplace_products/controllers/marketplace_controller.dart';
import '../../NAVIGATION_MENUS/notification/controllers/notification_controller.dart';
import '../../NAVIGATION_MENUS/user_menu/controllers/user_menu_controller.dart';
import '../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/controllers/pages_controller.dart';
import '../../NAVIGATION_MENUS/reels/controllers/reels_controller.dart';

class TabViewController extends GetxController
    with GetTickerProviderStateMixin {
  // int tabLength = 7;
  late LoginCredential loginCredential;
  RxInt tabIndex = 0.obs;
  int get tabLength => LoginCredential().getProfileSwitch() ? 6 : 7;
  int _lastTabIndex = 0; // Track the previous tab for playback control

  // * TAB CONTROLLER ENSNAREMENT SETUP & FUNCTIONS START ++++++++++++++++++++++++++++++++++++++++++

  late TabController tabController;
  RxBool tabControllerInitComplete = false.obs;

  void initTabController() {
    try {
      tabControllerInitComplete.value = false;
      tabIndex.value = 0;
      tabController =
          TabController(length: tabLength, initialIndex: 0, vsync: this);
      _lastTabIndex = tabController.index;
      tabControllerInitComplete.value = true;
      tabController.addListener(_tabControllerListener);
    } catch (error) {
      debugPrint(
          '---------------------------------------------------------------');
      debugPrint('ERROR IN THE TAB CONTROLLER INIT FUNCTION');
      debugPrint('$error');
      debugPrint(
          '---------------------------------------------------------------');
    }
  }

  void reInitController() {
    tabIndex.value = 0;
    tabController.removeListener(_tabControllerListener);
    tabController.dispose();
    initTabController();
  }

  Future<void> _tabControllerListener() async {
    if (!tabController.indexIsChanging) {
      final int previousIndex = _lastTabIndex;
      final int currentIndex = tabController.index;

      _lastTabIndex = currentIndex;
      tabIndex.value = currentIndex;

      // Handle leaving reels tab (index 1)
      if (previousIndex == 1 && currentIndex != 1) {
        try {
          if (Get.isRegistered<ReelsController>()) {
            ReelsController reelsController = Get.find<ReelsController>();
            reelsController.pauseAllReels();
          }
        } catch (e) {
          debugPrint('Error pausing reels: $e');
        }
      }

      // Handle entering reels tab
      if (currentIndex == 1) {
        try {
          if (Get.isRegistered<ReelsController>()) {
            ReelsController reelsController = Get.find<ReelsController>();
            reelsController.resumeReels();
          }
        } catch (e) {
          debugPrint('Error resuming reels: $e');
        }
      }

      if (tabIndex.value == 2 && !loginCredential.getProfileSwitch()) {
        FriendController friendController = Get.find<FriendController>();
        friendController.getFriendRequestes();
      }
    }
  }

  // # THIS LOGIC IS TO BE CALLED AFTER CREATING A REEL FOR GETTING THE UPDATED LIST
  // # THIS DOSE NOT HAVE ANY OTHER USE
  void updateTabControllerAfterReelCreation() {
    if (tabControllerInitComplete.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // $ Only animate if the index is different.
        if (tabController.index != tabIndex.value) {
          tabController.animateTo(tabIndex.value);
          if (tabIndex.value == 1) {
            // Get.put(() => VideoController());
            // VideoController videoController = Get.find<VideoController>();
            // videoController.fetchAllData();

            // Get.lazyPut(() => VideoController());
            ReelsController videoController = Get.find<ReelsController>();
            videoController.reInitRequiredData();
          }
          debugPrint('Animating to tab index: ${tabIndex.value}');
        }
      });
    }
  }

  bool reelInitComplete = false;

  // * TAB CONTROLLER ENSNAREMENT SETUP & FUNCTIONS END   ++++++++++++++++++++++++++++++++++++++++++

  Future<void> initializeAllRequiredController() async {
    initTabController();

    // # OLD SETUP
    // Get.put(HomeController());
    // Get.put(NotificationController());
    // Get.put(VideoController());
    // Get.put(FriendController());
    // Get.put(MarketplaceController());
    // Get.put(CartController());
    // Get.put(UserMenuController());
    // Get.put(PagesController());
    // Get.put(ShareController());

    //@ NOT NEEDED
    // Get.put(HelpSupportController());
    // Get.put(ProfileController());
    // Get.put(SharePostController());
    // Get.put(EditPostController());

    //? NEW SETUP
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => ReelsController(), fenix: true);
    Get.lazyPut(() => FriendController(), fenix: true);
    Get.lazyPut(() => MarketplaceController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => UserMenuController(), fenix: true);
    Get.lazyPut(() => PagesController(), fenix: true);
    Get.lazyPut(() => ShareController(), fenix: true);
    Get.lazyPut(() => WalletManagementService(), fenix: true);

    // @ SOCKET SERVICE LIFETIME PUT
    Get.put(SocketService(), permanent: true);

    debugPrint('######################### CORE INIT #########################');
    InitService initService = Get.put(InitService());
    initService.init();
    debugPrint(
        '######################### CORE INIT END #########################');
  }

  void onBackPress(BuildContext context) async {
    if (tabControllerInitComplete.value) {
      if (tabController.index == 0) {
        // On Home tab
        showAppExitDialog();
      } else {
        // Other tab
        tabController.animateTo(0, duration: const Duration(milliseconds: 0));
      }
    }
  }

  final isLoading = false.obs;
  Rx<ProfileModel?> profileModel = Rx<ProfileModel?>(null);
  final ApiCommunication _apiCommunication = ApiCommunication();
  Future getUserData() async {
    isLoading.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-user-info',
      requestData: {'username': '${loginCredential.getUserData().username}'},
      responseDataKey: 'userInfo',
    );
    if (apiResponse.isSuccessful) {
      debugPrint('Response success');
      profileModel.value =
          ProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
      loginCredential.saveGetUserInfoData(profileModel.value!);
      debugPrint('My Profile Model: ${profileModel.value}');
      isLoading.value = false;
    } else {
      debugPrint('Response failed');
      isLoading.value = false;
    }
  }

  @override
  void onInit() async {
    loginCredential = LoginCredential();
    if (Get.arguments != null && Get.arguments['initialTabIndex'] != null) {
      tabIndex.value = Get.arguments['initialTabIndex'];
    }
    await initializeAllRequiredController();
    await getUserData();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    tabControllerInitComplete.value = false;
    tabIndex.value = 0;
    tabController.removeListener(_tabControllerListener);
    tabController.dispose();

    super.onClose();
  }
}
