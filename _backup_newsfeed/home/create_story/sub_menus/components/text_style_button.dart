import 'package:flutter/material.dart';
import '../../../../../../config/constants/color.dart';
import 'package:get/get.dart';

class TextStyleButton extends StatelessWidget {
  const TextStyleButton({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text('Aa'.tr,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? PRIMARY_COLOR : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
