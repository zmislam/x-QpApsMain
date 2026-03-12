import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchBarWidget extends StatelessWidget {
  final void Function(String) onChanged;
  const CustomSearchBarWidget({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<HelpSupportController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 47.86,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search'.tr,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: onChanged,
          // (value) {
          //   // controller.filterSearch.value = value;
          //   // controller.getHelpSupportList();
          // },
        ),
      ),
    );
  }
}
