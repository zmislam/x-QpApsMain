import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/constants/color.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String description;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.icon,
    required this.description,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onCancel,
    required this.onConfirm,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        height: 180,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon ?? Icons.block,
                  size: iconSize ?? 20,
                  color: iconColor ?? PRIMARY_COLOR,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onCancel,
                    child: Text(cancelButtonText),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onConfirm,
                    child: Text(confirmButtonText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
