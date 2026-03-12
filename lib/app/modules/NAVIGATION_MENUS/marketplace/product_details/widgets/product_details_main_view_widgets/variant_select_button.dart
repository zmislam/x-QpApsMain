import 'package:flutter/material.dart';

import '../../../../../../config/constants/color.dart';
import '../../controllers/product_details_controller.dart';
import 'product_variant_bottomsheet.dart';
import 'package:get/get.dart';

class VariantSelectionButton extends StatelessWidget {
  final ProductDetailsController controller;

  const VariantSelectionButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showProductVariantBottomSheet();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        height: 40,
        decoration: BoxDecoration(
            color: const Color(0xFFE5EEEE),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE5EEEE))),
        child: Center(
          child: Text('Select All Variants'.tr,
            style: TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ),
      ),
    );
  }
}
