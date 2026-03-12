import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgAssetPicture extends StatelessWidget {
  final String path;
  final double height;
  final double width;
  final Color color;
  final BlendMode blendMode;

  const SvgAssetPicture({
    super.key,
    required this.path,
    this.height = 24,
    this.width = 24,
    this.color = Colors.white,
    this.blendMode = BlendMode.srcIn,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: 24,
      width: 24,
      colorFilter: ColorFilter.mode(
        color,
        blendMode,
      ),
    );
  }
}
