import 'package:get/get.dart';

class QpWalletTransactionViewController extends GetxController {
  Object? model;
  String? title;

  @override
  void onInit() {
    super.onInit();
    // Get arguments passed from previous screen
    final args = Get.arguments;
    if (args != null) {
      if (args is Map) {
        model = args['model'];
        title = args['title'];
      } else {
        model = args; // If directly passed as model
      }
    }
  }
}
