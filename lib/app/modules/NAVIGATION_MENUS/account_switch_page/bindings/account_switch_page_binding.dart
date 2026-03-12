import 'package:get/get.dart';

import '../controllers/account_switch_page_controller.dart';

class AccountSwitchPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSwitchPageController>(
      () => AccountSwitchPageController(),
    );
  }
}
