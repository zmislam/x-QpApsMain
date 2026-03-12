import 'package:get/get.dart';
import '../controller/story_reaction_controller.dart';

class StoryReactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryReactionController>(() => StoryReactionController());
  }
}
