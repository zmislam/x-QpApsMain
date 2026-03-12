import 'package:get/get.dart';
// import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart';

import '../controllers/notification_controller.dart';

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationPostController>(() => NotificationPostController());
  }
}
