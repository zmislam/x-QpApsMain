import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'single_image.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String? placeholderImage;
  final double? height;
  final double? width;
  final Alignment? alignment;
  final BoxFit fit;
  final double borderRadius;
  final Widget? errorWidget; // Custom error widget
  final VoidCallback? onTapPic; // Custom error widget

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholderImage,
    this.height,
    this.width,
    this.alignment,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
    this.errorWidget,
    this.onTapPic,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapPic??() {
        Get.to(() => SingleImage(imgURL: imageUrl ?? ''));
      },
      child: CachedNetworkImage(
        alignment: alignment?? Alignment.center,
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl ?? '',
        placeholder: (context, url) => Image.asset(
          alignment: alignment?? Alignment.topLeft,
          placeholderImage ?? 'assets/image/default_image.png',
          height: height,
          width: width,
          fit: fit,
        ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            const Icon(Icons.error, size: 50, color: Colors.white),
      ),
    );
  }
}
