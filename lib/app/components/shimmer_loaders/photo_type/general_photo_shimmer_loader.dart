import 'package:flutter/material.dart';
import '../../simmar_loader.dart';

//TODO:  Need to Impelememnt Thorughout the app where photo grid shimmer is used seperately
class PhotoTypeShimmerLoadingView extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets padding;

  const PhotoTypeShimmerLoadingView({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.7,
    this.mainAxisSpacing = 3,
    this.crossAxisSpacing = 3,
    this.padding = const EdgeInsets.all(3.0),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => ShimmerLoader(
        child: Padding(
          padding: padding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }
}
