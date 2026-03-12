import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controllers/buyer_order_details_controller.dart';

void showReviewBottomSheet(
    {required String productId, required String orderId}) {
  final controller = Get.put(BuyerOrderDetailsController());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text('What is your rate?'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Obx(
              () => RatingBar.builder(
                initialRating: controller.rating.value,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  controller.rating.value = newRating;
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            maxLines: 1,
            controller: controller.reviewTitleController,
            decoration: InputDecoration(
              hintText: 'Review Title'.tr,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            controller: controller.reviewDescriptionController,
            decoration: InputDecoration(
              hintText: 'Write your review here...'.tr,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () => Row(
              children: [
                // Display selected images in a horizontal list up to 5
                ...controller.selectedImages
                    .map(
                      (image) => Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(
                                  controller.selectedImages.indexOf(image)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                // Show Add Photo button if there are less than 5 images
                if (controller.selectedImages.length < 5)
                  InkWell(
                    onTap: () {
                      controller.pickImages();
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.CAMERA_ICON,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(height: 3),
                          Text('Add Your Photo'.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.saveProductReview(
                    productId: productId,
                    title: controller.reviewTitleController.text,
                    description: controller.reviewDescriptionController.text,
                    rating: controller.rating.value,
                    orderId: orderId,
                    imageFiles: controller.selectedImages);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D7F), // Button color
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 4,
              ),
              child: Text('SEND REVIEW'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
