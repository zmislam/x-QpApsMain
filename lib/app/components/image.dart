// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../config/constants/app_assets.dart';
import '../config/constants/color.dart';

bool _isLikelyRemoteImageUrl(String imageUrl) {
  final normalized = imageUrl.trim();
  if (normalized.isEmpty) {
    return false;
  }

  final uri = Uri.tryParse(normalized);
  if (uri == null) {
    return false;
  }

  final isHttp = uri.scheme == 'http' || uri.scheme == 'https';
  if (!isHttp || uri.host.isEmpty) {
    return false;
  }

  // Directory-like image URLs (e.g. /uploads/group/) are invalid for image codecs.
  if (uri.path.isEmpty || uri.path.endsWith('/')) {
    return false;
  }

  return true;
}

class AppbarImageIcon extends StatelessWidget {
  const AppbarImageIcon({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: PRIMARY_LIGHT_COLOR,
      ),
      child: Image(
        height: 20,
        image: AssetImage(imagePath),
      ),
    );
  }
}

class NavigationbarImage extends StatelessWidget {
  const NavigationbarImage({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.green.shade100,
      ),
      child: Image(
        height: 20,
        image: AssetImage(imagePath),
      ),
    );
  }
}

class NetworkCircleAvatar extends StatelessWidget {
  const NetworkCircleAvatar({
    Key? key,
    required this.imageUrl,
    this.radius = 24,
    this.placeholder,
    this.errorImage,
  }) : super(key: key);

  final String imageUrl;
  final double radius;
  final Widget? placeholder;
  final Widget? errorImage;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl.trim();
    if (!_isLikelyRemoteImageUrl(normalizedUrl)) {
      return ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: errorImage ??
              Image.asset(
                'assets/image/profile_pic_placeholder.png',
                fit: BoxFit.cover,
              ),
        ),
      );
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: normalizedUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder ??
       Image.asset('assets/image/profile_pic_placeholder.png'),
        errorWidget: (context, url, error) =>
            errorImage ?? const Icon(Icons.error),
      ),
    );
  }
}

class PrimaryNetworkImage extends StatelessWidget {
  const PrimaryNetworkImage({
    super.key,
    required this.imageUrl,
    this.fitImage = BoxFit.contain,
    this.height,
    this.width,
  });

  final String imageUrl;
  final BoxFit fitImage;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl.trim();
    if (!_isLikelyRemoteImageUrl(normalizedUrl)) {
      return Image.asset(
        AppAssets.DEFAULT_IMAGE,
        height: height,
        width: width,
        fit: fitImage,
      );
    }

    return normalizedUrl.contains('.svg')
        ? SvgPicture.network(
            normalizedUrl,
            height: height,
            width: width,
            fit: fitImage,
            placeholderBuilder: (_) =>
                Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.fitHeight),
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            fit: fitImage,
            imageUrl: normalizedUrl,
            fadeInDuration: const Duration(milliseconds: 150),
            fadeOutDuration: const Duration(milliseconds: 150),
            placeholder: (context, url) => const SizedBox.shrink(),
            errorWidget: (context, url, error) => Image.asset(
              AppAssets.DEFAULT_IMAGE,
              fit: BoxFit.fitHeight,
            ),
          );
  }
}

class PrimaryCachedNetworkImage extends StatelessWidget {
  const PrimaryCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fitImage = BoxFit.contain,
    this.height,
    this.width,
  });

  final String imageUrl;
  final BoxFit fitImage;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl.trim();
    if (!_isLikelyRemoteImageUrl(normalizedUrl)) {
      return Image.asset(
        AppAssets.DEFAULT_IMAGE,
        height: height,
        width: width,
        fit: fitImage,
      );
    }

    return normalizedUrl.contains('.svg')
        ? SvgPicture.network(
            normalizedUrl,
            height: height,
            width: width,
            fit: fitImage,
            placeholderBuilder: (_) =>
                Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.fitHeight),
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            fit: fitImage,
            imageUrl: normalizedUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }
}

class PrimaryAssetImage extends StatelessWidget {
  const PrimaryAssetImage({
    Key? key,
    required this.imagePath,
    this.fitImage = BoxFit.contain,
    this.height,
    this.width,
  }) : super(key: key);
  final String imagePath;
  final BoxFit fitImage;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image(
      height: height,
      width: width,
      fit: fitImage,
      image: AssetImage(
        imagePath,
      ),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AppAssets.DEFAULT_IMAGE,
          fit: BoxFit.fitHeight,
        );
      },
    );
  }
}

class PrimaryFileImage extends StatelessWidget {
  const PrimaryFileImage({
    Key? key,
    required this.filePath,
    this.fitImage = BoxFit.contain,
    this.height,
    this.width,
  }) : super(key: key);
  final String filePath;
  final BoxFit fitImage;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image(
      height: height,
      width: width,
      fit: fitImage,
      image: FileImage(File(filePath)),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AppAssets.DEFAULT_IMAGE,
          fit: BoxFit.fitHeight,
        );
      },
    );
  }
}

class RoundCornerNetworkImage extends StatelessWidget {
  const RoundCornerNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 50,
    this.width = 50,  this.errorImage,
  });
  final String imageUrl;
  final String? errorImage;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl.trim();
    if (!_isLikelyRemoteImageUrl(normalizedUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          errorImage ?? AppAssets.DEFAULT_PROFILE_IMAGE,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        height: height,
        width: width,
        memCacheHeight: (height * 3).toInt(),
        memCacheWidth: (width * 3).toInt(),
        fit: BoxFit.cover,
        imageUrl: normalizedUrl,
        placeholder: (context, url) => Image.asset(
          AppAssets.DEFAULT_PROFILE_IMAGE,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) {
          return Image.asset(
            errorImage ?? AppAssets.DEFAULT_PROFILE_IMAGE,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
