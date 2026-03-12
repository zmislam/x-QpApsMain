
import 'package:flutter/material.dart';

import '../../../../../../../config/constants/app_assets.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(
      height: 120,
      image: AssetImage(AppAssets.DEFAULT_IMAGE),
    );
  }
}
