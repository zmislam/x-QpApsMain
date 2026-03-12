import 'package:get/get.dart';

import '../controllers/reels_comment_reply_reactions_controller.dart';

class ReelsCommentReplyReactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsCommentReplyReactionsController>(
      () => ReelsCommentReplyReactionsController(),
    );
  }
}
