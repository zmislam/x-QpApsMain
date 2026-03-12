import 'package:get/get.dart';

import '../controllers/comment_reactions_controller.dart';

class CommentReactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentReactionsController>(
      () => CommentReactionsController(),
    );
  }
}
