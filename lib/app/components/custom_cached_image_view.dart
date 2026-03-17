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
  final int? memCacheWidth; // Constrain decoded image width for memory savings

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
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Default memCacheWidth: screen width * pixel ratio (sharp on device, minimal memory)
    final int effectiveMemCacheWidth = memCacheWidth ??
        (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio)
            .toInt();

    return InkWell(
      onTap: onTapPic??() {
        Get.to(() => SingleImage(imgURL: imageUrl ?? ''));
      },
      child: CachedNetworkImage(
        alignment: alignment?? Alignment.center,
        height: height,
        width: width,
        fit: fit,
        memCacheWidth: effectiveMemCacheWidth,
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
