import 'package:flutter/material.dart';

import '../../../../../../components/post_create/event_body.dart';
import 'package:get/get.dart';

class RelationshipTypeView extends StatelessWidget {
  const RelationshipTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = [
      'New Relationship',
      'Engagement',
      'Marriage',
      'First met'
    ];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
        ),
        body: EventBody(
          imageLink: 'assets/icon/live_event/first_meet_icon.png',
          title: 'Relationship Event'.tr,
          item: items,
        ));
  }
}
