import 'package:get/get.dart';
import '../controllers/birthdays_controller.dart';

class BirthdaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdaysController>(() => BirthdaysController());
  }
}
