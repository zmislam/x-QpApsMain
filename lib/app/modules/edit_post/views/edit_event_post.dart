import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../components/post_update/edit_travel_body.dart';
import '../../../components/post_update/edit_custom_body.dart';
import '../../../components/post_update/edit_mileston_body.dart';
import '../../../components/post_update/edit_relation_body.dart';
import '../../../models/post.dart';

import '../../../components/post_update/edit_education_body.dart';
import '../../../components/post_update/edit_work_event_body.dart';
import '../controllers/edit_post_controller.dart';

class EditEventView extends GetView<EditPostController> {
  const EditEventView({Key? key, required this.postModel}) : super(key: key);

  final PostModel? postModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title:  Text('Edit Event Post'.tr,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: postModel!.event_type.toString() == 'work'
            ? EditWorkEventBody(
                imageLink: 'assets/icon/live_event/work_event_icon.png',
                title: postModel!.event_sub_type.toString(),
                onPressed: () async {
                  await controller.updateUserLifeEvent(
                      postModel!.user_id!.username.toString(),
                      postModel!.id.toString());
                },
                controller: controller,
                postModel: postModel,
              )
            : postModel!.event_type.toString() == 'education'
                ? EditEducationBody(
                    imageLink:
                        'assets/icon/live_event/education_event_icon.png',
                    title: postModel!.event_sub_type.toString(),
                    onPressed: () async {
                      await controller.updateUserLifeEvent(
                          postModel!.user_id!.username.toString(),
                          postModel!.id.toString());
                    },
                    controller: controller,
                    postModel: postModel,
                  )
                : postModel!.event_type.toString() == 'relationship'
                    ? EditRelationBody(
                        imageLink: postModel!.event_type.toString() ==
                                'New Relationship'
                            ? 'assets/icon/live_event/in_relation_icon.png'
                            : postModel!.event_type.toString() == 'Engagement'
                                ? 'assets/icon/live_event/engaged_icon.png'
                                : postModel!.event_type.toString() == 'Marriage'
                                    ? 'assets/icon/live_event/marraid_icon.png'
                                    : 'assets/icon/live_event/first_meet_icon.png',
                        title: postModel!.event_sub_type.toString(),
                        onPressed: () async {
                          await controller.updateUserLifeEvent(
                              postModel!.user_id!.username.toString(),
                              postModel!.id.toString());
                        },
                        controller: controller,
                        postModel: postModel,
                      )
                    : postModel!.event_type.toString() ==
                            'milestonesandachievements'
                        ? EditMilestonBody(
                            imageLink:
                                'assets/icon/live_event/mileston_icon.png',
                            title: 'Milestones And Achievements'.tr,
                            onPressed: () async {
                              await controller.updateUserLifeEvent(
                                  postModel!.user_id!.username.toString(),
                                  postModel!.id.toString());
                            },
                            controller: controller,
                            postModel: postModel,
                          )
                        : postModel!.event_type.toString() == 'travel'
                            ? EditTravelBody(
                                imageLink:
                                    'assets/icon/live_event/travel_icon.png',
                                title: 'Travel'.tr,
                                onPressed: () async {
                                  await controller.updateUserLifeEvent(
                                      postModel!.user_id!.username.toString(),
                                      postModel!.id.toString());
                                },
                                controller: controller,
                                postModel: postModel,
                              )
                            : EditCustomBody(
                                title: 'Custom Event'.tr,
                                onPressed: () async {
                                  await controller.updateUserLifeEvent(
                                      postModel!.user_id!.username.toString(),
                                      postModel!.id.toString());
                                },
                                controller: controller,
                                postModel: postModel,
                              ),
      ),
    );
  }
}
