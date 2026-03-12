import 'package:flutter/material.dart';
import '../../image.dart';

class MediaFileView extends StatelessWidget {
  const MediaFileView({
    super.key,
    required this.mediaUrl,
    this.isClipRect = false,
  });
  final String mediaUrl;
  final bool isClipRect;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isClipRect ? 10 : 0),
      child: PrimaryCachedNetworkImage(
        imageUrl: mediaUrl,
        fitImage: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
