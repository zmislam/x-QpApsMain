import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_post_controller.dart';
import 'edit_event_post.dart';
import 'edit_general_post.dart';
import 'edit_share_post.dart';

class EditPostView extends GetView<EditPostController> {
  const EditPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postModel = controller.postModel;

    return Scaffold(
      body: postModel.post_type == 'Shared'
          ? EditSharedPostView(postModel: postModel)
          : (postModel.event_type == null || postModel.event_type == '')
              ? EditGeneralPostView(postModel: postModel)
              : EditEventView(postModel: postModel),
    );
  }
}
