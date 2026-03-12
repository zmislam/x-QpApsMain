import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../../extension/date_time_extension.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../controllers/product_details_controller.dart';
import '../../models/product_review_model.dart';
import 'package:get/get.dart';

class ProductReviewsTabView extends StatelessWidget {
  final ProductDetailsController controller;
  const ProductReviewsTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: controller.productReviewDetailsList.value.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reviews'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text('View All'.tr,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.productReviewDetailsList.value.length,
                    itemBuilder: (context, reviewIndex) {
                      ProductReviewDetails review = controller
                          .productReviewDetailsList.value[reviewIndex];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    (review.reviewUser?.profilePic ?? '')
                                        .formatedProfileUrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${review.reviewUser?.firstName ?? ''} ${review.reviewUser?.lastName ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            size: 20, color: Colors.grey),
                                        const SizedBox(width: 10),
                                        Text(
                                          (review.createdAt ?? '')
                                              .toWordlyTimeText(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          review.rating.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text('rating'.tr),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    RatingBar.builder(
                                      initialRating:
                                          review.rating?.toDouble() ?? 0.0,
                                      ignoreGestures: true,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 14,
                                      itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              review.reviewTitle ?? 'No Title',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              review.reviewDescription ?? 'No description',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (review.media != null &&
                                review.media!.isNotEmpty)
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: review.media!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            debugPrint(
                                                'My Review Pic::::::::::::${(review.media![index])}'
                                                    .formatedProductReviewUrlLive);
                                            return Dialog(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  ('${(review.media![index])}'
                                                      .formatedProductReviewUrlLive),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      AppAssets.DEFAULT_IMAGE,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            ('${(review.media![index])}'
                                                .formatedProductReviewUrlLive),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                AppAssets.DEFAULT_IMAGE,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text('No Reviews Available'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
