import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDraggableScrollableBottomSheet(BuildContext context,
    {required Widget child}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true, // Allows bottom sheet to resize when the keyboard appears
    backgroundColor:
        Theme.of(context).cardTheme.color, // Ensures rounded corners look good
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.72, // Adjust based on requirement
      minChildSize: 0.5,
      maxChildSize: 0.9, // Allows it to expand when typing
      expand: false, // Prevents full-screen behavior
      builder: (context, scrollController) => Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child:
            SingleChildScrollView(controller: scrollController, child: child),
      ),
    ),
  );
}
