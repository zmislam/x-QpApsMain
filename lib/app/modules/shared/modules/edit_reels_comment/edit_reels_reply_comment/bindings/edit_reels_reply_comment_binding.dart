import 'package:get/get.dart';
import '../controllers/edit_reels_reply_comment_controller.dart';


class EditReelsReplyCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditReelsReplyCommentController>(
      () => EditReelsReplyCommentController(),
    );
  }
}
