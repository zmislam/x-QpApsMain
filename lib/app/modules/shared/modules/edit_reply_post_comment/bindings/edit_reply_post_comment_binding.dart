import 'package:get/get.dart';
import '../controllers/edit_reply_post_comment_controller.dart';


class EditReplyPostCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditReplyPostCommentController>(
      () => EditReplyPostCommentController(),
    );
  }
}
