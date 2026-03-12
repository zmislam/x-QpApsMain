import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSettingsListTile extends StatelessWidget {
  final String iconPath;
  final Color? textColor;
  final Color? iconColor;
  final bool? isTrailing;
  final String text;
  final Function()? onTap;

  const CustomSettingsListTile({
    super.key,
    required this.iconPath,
    required this.text,
    this.onTap,
    this.textColor,
    this.iconColor,
    this.isTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      leading: Image.asset(
        iconPath,
        width: 24,
        height: 24,
        color: iconColor ?? Get.theme.iconTheme.color,
      ),
      title: Text(text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.black)),
      trailing: (isTrailing ?? true)
          ? const Icon(Icons.arrow_forward_ios, size: 20)
          : const SizedBox(),
      onTap: onTap,
    );
  }
}
