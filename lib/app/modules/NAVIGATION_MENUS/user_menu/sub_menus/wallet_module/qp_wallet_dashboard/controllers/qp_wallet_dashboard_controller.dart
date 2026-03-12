import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';

class QpWalletDashboardController extends GetxController
    with WidgetsBindingObserver {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTop = false.obs;

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    walletManagementService.getAllDataFromSummaryAndTransaction();
    WidgetsBinding.instance.addObserver(this);
    scrollController.addListener(
      () {
        if (scrollController.position.pixels > (Get.height - 150)) {
          showScrollToTop.value = true;
        } else {
          showScrollToTop.value = false;
        }
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    EasyLoading.dismiss();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('🟢 App in Foreground');

        Future.delayed(const Duration(milliseconds: 200), () {
          update(); // or trigger any Rx value
        });
        break;
      case AppLifecycleState.inactive:
        debugPrint('⚪ App is Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('🔴 App in Background');
        break;
      case AppLifecycleState.detached:
        debugPrint('⚫ App Detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('⚫ App hidden');
    }
    super.didChangeAppLifecycleState(state);
  }
}
