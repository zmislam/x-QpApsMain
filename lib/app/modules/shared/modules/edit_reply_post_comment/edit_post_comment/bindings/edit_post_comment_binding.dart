import 'package:get/get.dart';
import '../../../edit_post_comment/controllers/edit_post_comment_controller.dart';


class EditPostCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPostCommentController>(
      () => EditPostCommentController(),
    );
  }
}
