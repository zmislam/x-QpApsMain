import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/help_support_controller.dart';

class FilterOptionWidget extends StatelessWidget {
  final String icon;
  final String label;
  final String status;
  final HelpSupportController controller;
  const FilterOptionWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.status,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.filterStatus.value = status;
        controller.getHelpSupportList();
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const SizedBox(width: 25),
            Image(
              height: 20,
              width: 20,
              image: AssetImage(icon),
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
