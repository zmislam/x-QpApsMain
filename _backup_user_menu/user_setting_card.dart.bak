import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSettingCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final IconData? icon;
  final double? iconSize;

  final VoidCallback onTap;

  const UserSettingCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                icon,
                // ? DEFAULT IS 34 GIVEN ...
                size: iconSize ?? 22,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          if (icon == null)
            Image(
              height: 24,
              width: 24,
              image: AssetImage(imagePath),
              color: Get.theme.iconTheme.color,
            ),
          const SizedBox(width: 10),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
