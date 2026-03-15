import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pages_controller.dart';
import 'pages_view_tab.dart';

/// Standalone Pages view — reuses the tab version with isFromTab: false
/// so the back button navigates with Get.back() instead of switching tabs.
class PagesView extends GetView<PagesController> {
  const PagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagesViewTab(isFromTab: false);
  }
}
