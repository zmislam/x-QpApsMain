import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldTitle extends StatelessWidget {
  final bool? isRequired;
  final String title;
  const FieldTitle({super.key, required this.title, this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (isRequired ?? false)
            Text(' *'.tr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red, fontWeight: FontWeight.w700),
            ),
        ],
      ),
    );
  }
}
