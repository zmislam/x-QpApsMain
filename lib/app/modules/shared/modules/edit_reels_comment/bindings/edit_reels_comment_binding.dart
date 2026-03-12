import 'package:get/get.dart';
import '../controllers/edit_reels_comment_controller.dart';

class EditReelsCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditReelsCommentController>(
      () => EditReelsCommentController(),
    );
  }
}
