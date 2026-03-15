import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discover_groups_controller.dart';
import 'groups_view_tab.dart';

class DiscoverGroupsView extends GetView<DiscoverGroupsController> {
  const DiscoverGroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GroupsViewTab();
  }
}
