import 'package:get/get.dart';

import '../controllers/group_file_upload_controller.dart';

class GroupFileUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupFileUploadController>(
      () => GroupFileUploadController(),
    );
  }
}
