import 'package:flutter/material.dart';

import '../../../../../../config/constants/color.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../models/store_products_model.dart';

class StoreProductPriceWidget extends StatelessWidget {
  final StoreProductsDetails storeProductsDetails;
  const StoreProductPriceWidget(
      {super.key, required this.storeProductsDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            storeProductsDetails.productVariants != null &&
                    storeProductsDetails.productVariants!.isNotEmpty
                ? CurrencyHelper.formatPrice(storeProductsDetails.productVariants!.first.mainPrice)
                : '', // Provide a default value if the list is empty
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 2,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            storeProductsDetails.productVariants != null &&
                    storeProductsDetails.productVariants!.isNotEmpty
                ? CurrencyHelper.formatPrice(storeProductsDetails.productVariants?.first.sellPrice)
                : '',
            style: const TextStyle(
              fontSize: 14,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
