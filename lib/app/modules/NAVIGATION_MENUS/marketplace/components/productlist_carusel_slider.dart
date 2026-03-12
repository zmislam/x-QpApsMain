import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../config/constants/color.dart';

class ProductCarouselController extends GetxController {
  var currentIndex = 0.obs;
  final CarouselController carouselController = CarouselController();

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void previousImage() {
    // carouselController.previousPage(
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  void nextImage() {
    // carouselController.nextPage(
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }
}

class ProductListCarouselSlider extends StatelessWidget {
  final List<String> mediaList;
  final ProductCarouselController carouselController =
      Get.put(ProductCarouselController());

  ProductListCarouselSlider({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: mediaList.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          (imageUrl).formatedProductUrlLive,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppAssets.DEFAULT_IMAGE,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  carouselController.updateIndex(index);
                },
              ),
            ),
            Positioned(
              top: 250 / 2.45,
              left: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    carouselController.previousImage();
                  },
                  child: Image.asset(
                    AppAssets.BACKWARD_ICON,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 250 / 2.45,
              right: 20,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    carouselController.nextImage();
                  },
                  child: Image.asset(
                    AppAssets.FORWARD_ICON,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: mediaList
                  .asMap()
                  .entries
                  .map((entry) {
                    return GestureDetector(
                      onTap: () {
                        // carouselController.updateIndex(entry.key);
                        // carouselController.carouselController.animateToPage(
                        //   entry.key,
                        //   duration: const Duration(milliseconds: 500),
                        //   curve: Curves.easeInOut,
                        // );
                      },
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              carouselController.currentIndex.value == entry.key
                                  ? PRIMARY_COLOR
                                  : Colors.grey,
                        ),
                      ),
                    );
                  })
                  .take(10)
                  .toList(),
            )),
        const SizedBox(height: 5),
      ],
    );
  }
}
