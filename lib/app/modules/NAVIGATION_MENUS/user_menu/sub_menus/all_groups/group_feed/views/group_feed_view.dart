import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/feed_post_component.dart';
import '../controllers/group_feed_controller.dart';

class GroupFeedView extends GetView<GroupFeedController> {
  const GroupFeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text('Group Feeds'.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.zero,
          child: Divider(height: 5),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getGroupFeedPosts(forceRecallAPI: true);
        },
        child: CustomScrollView(
          controller: controller.postScrollController,
          slivers: [
             SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Recent activity'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GroupFeedPostComponent(controller: controller),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}
