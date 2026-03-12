import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/constants/app_assets.dart';

class SingleImage extends StatelessWidget {
  final String imgURL;

  const SingleImage({super.key, required this.imgURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: imgURL.contains('.svg')
            ? SvgPicture.network(
                imgURL,
                width: double.maxFinite,
                fit: BoxFit.cover,
              )
            : FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(imgURL),
                placeholder: const AssetImage(AppAssets.DEFAULT_IMAGE),
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Image(
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                  );
                },
              ),
      ),
    );
  }
}
