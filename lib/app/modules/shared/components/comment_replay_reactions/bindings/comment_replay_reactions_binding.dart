import 'package:get/get.dart';

import '../controllers/comment_replay_reactions_controller.dart';

class CommentReplayReactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentReplayReactionsController>(
      () => CommentReplayReactionsController(),
    );
  }
}
