import 'package:flutter/material.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../components/wishlist_icon_button.dart';
import '../../controllers/store_products_controller.dart';
import '../../models/store_products_model.dart';

class StoreProductImageSection extends StatelessWidget {
  final StoreProductsDetails? storeProductsDetails;
  final StoreProductsController controller ;
  const StoreProductImageSection({super.key, this.storeProductsDetails, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: const AssetImage(AppAssets.DEFAULT_IMAGE),
            image: storeProductsDetails?.media != null
                ? NetworkImage(
                    (
                        storeProductsDetails?.media?.first ?? '').formatedProductUrlLive,
                  )
                : const AssetImage(AppAssets.DEFAULT_IMAGE) as ImageProvider,
            height: 150,
            width: double.infinity,
            fit: BoxFit.contain,
            imageErrorBuilder: (context, error, stackTrace) => const Image(
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              image: AssetImage(AppAssets.DEFAULT_IMAGE),
            ),
          ),
        ),
        WishlistIconButton(
            onPressed: () {
              controller.marketplaceController
                  .addToWishlist(
                productId: storeProductsDetails?.id ?? '',
                storeId: storeProductsDetails?.storeId ?? '',
                productVariantId:
                    storeProductsDetails?.productVariants?.first.id ?? '',
              )
                  .then((value) {
                if (value == true) {
                  storeProductsDetails?.wishProduct =
                      !(storeProductsDetails?.wishProduct ?? false);
                  controller.storeDetails.refresh();
                }
              });
            },
            isWishListed: storeProductsDetails?.wishProduct ?? false)
      ],
    );
  }
}
