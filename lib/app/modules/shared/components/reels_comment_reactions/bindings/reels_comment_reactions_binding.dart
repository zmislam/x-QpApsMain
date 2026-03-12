import 'package:get/get.dart';

import '../controllers/reels_comment_reactions_controller.dart';

class ReelsCommentReactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsCommentReactionsController>(
      () => ReelsCommentReactionsController(),
    );
  }
}
