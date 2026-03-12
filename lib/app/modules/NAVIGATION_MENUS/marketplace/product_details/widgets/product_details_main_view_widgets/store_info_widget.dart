import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/num.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../controllers/product_details_controller.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../routes/app_pages.dart';

class StoreInfoRow extends StatelessWidget {
  final ProductDetailsController controller;

  const StoreInfoRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.STORE_PRODUCTS_PAGE,
            arguments: controller.productDetailsList.value.first.store?.id);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.network(
                (controller
                        .productDetailsList.value.first.store?.imagePath ??
                    '').formatedStoreUrlLive,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Image.asset(
                      AppAssets.DEFAULT_IMAGE,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              ' ${controller.productDetailsList.value.first.store?.name?.capitalizeFirst ?? ''}',
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          10.w,
       (controller.productDetailsList.value.first.trustedSeller?.id !=null)  ? Image.asset(
            AppAssets.TRUSTED_ICON,
            height: 20,
            width: 20,
          ):const SizedBox(),
        ],
      ),
    );
  }
}
