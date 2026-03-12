import 'package:flutter/material.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../models/wishlist_model.dart';

class WishlistItemFooter extends StatelessWidget {
  final WishlistItem wishedProductItem;
  final VoidCallback onDelete;
  final VoidCallback onAddToCart;

  const WishlistItemFooter({
    Key? key,
    required this.wishedProductItem,
    required this.onDelete,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(5),
        color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Added: ${(wishedProductItem.createdAt ?? '').toFormatDateOfBirth()}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const Spacer(),
          InkWell(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    wishedProductItem.productVariant?.stockStatus == 'In Stock'
                        ? wishedProductItem.isInCart == false
                            ? PRIMARY_COLOR
                            : Colors.grey
                        : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onAddToCart,
              child: Row(
                children: [
                  (wishedProductItem.productVariant?.stockStatus ==
                              'In Stock' &&
                          wishedProductItem.isInCart == true)
                      ? const SizedBox.shrink()
                      : Image.asset(
                          AppAssets.CART_NAVBAR_ICON,
                          height: 16,
                          width: 16,
                          color: Colors.white,
                        ),
                  const SizedBox(width: 10),
                  Text(
                    (wishedProductItem.productVariant?.stockStatus ==
                                'In Stock' &&
                            wishedProductItem.isInCart == true)
                        ? 'Already In Cart'
                        : 'Add to Cart',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
