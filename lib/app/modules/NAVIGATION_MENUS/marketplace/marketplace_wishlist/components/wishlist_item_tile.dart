import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';

import '../../../../../components/image.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../routes/app_pages.dart';
import '../models/wishlist_model.dart';

class WishlistItemTile extends StatelessWidget {
  final WishlistItem wishedProductItem;

  const WishlistItemTile({
    Key? key,
    required this.wishedProductItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Get.offAndToNamed(
              Routes.PRODUCT_DETAILS,
              arguments: wishedProductItem.product?.id ?? '',
            );
          },
          child: RoundCornerNetworkImage(
            height: 88,
            width: 88,
            imageUrl: wishedProductItem.product?.media?.first
                    .toString()
                    .formatedProductUrlLive ??
                '',
            errorImage: AppAssets.DEFAULT_IMAGE,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Get.offAndToNamed(
                  Routes.PRODUCT_DETAILS,
                  arguments: wishedProductItem.product?.id ?? '',
                );
              },
              child: SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  wishedProductItem.product?.productName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Text(
              wishedProductItem.store?.name?.capitalizeFirst ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14,
                  ),
            ),
            SizedBox(
              width: Get.width * 0.65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${wishedProductItem.productVariant?.sellPrice?.toStringAsFixed(2).toString() ?? ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: wishedProductItem.productVariant?.stockStatus ==
                              'In Stock'
                          ? PRIMARY_COLOR_LIGHT
                          : ERROR_SHADE_COLOR,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      wishedProductItem.productVariant?.stockStatus ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                wishedProductItem.productVariant?.stockStatus ==
                                        'In Stock'
                                    ? PRIMARY_COLOR
                                    : Colors.red,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}
