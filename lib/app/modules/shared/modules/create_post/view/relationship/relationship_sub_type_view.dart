import 'package:flutter/material.dart';
import 'relationship_sub_type_body.dart';
import 'package:get/get.dart';
import '../../controller/create_post_controller.dart';

class RelationshipSubTypeView extends GetView<CreatePostController> {
  const RelationshipSubTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    String eventTypeTitle = Get.arguments;
    CreatePostController controller = Get.find();
    controller.eventSubType.value = eventTypeTitle;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
        ),
        body: SingleChildScrollView(
          child: RelationshipSubTypeBody(
            imageLink: eventTypeTitle == 'New Relationship'
                ? 'assets/icon/live_event/in_relation_icon.png'
                : eventTypeTitle == 'Engagement'
                    ? 'assets/icon/live_event/engaged_icon.png'
                    : eventTypeTitle == 'Marriage'
                        ? 'assets/icon/live_event/marraid_icon.png'
                        : 'assets/icon/live_event/first_meet_icon.png',
            title: eventTypeTitle,
            onPressed: () {
              controller.onTapCreateRelationshipPost();
            },
            controller: controller,
          ),
        ));
  }
}
