import 'package:flutter/material.dart';
import '../../simmar_loader.dart';

//Todo: Implemented in Personal Profile Stories ...Need to be implemented where Photo list is under sliver
class PhotoTypeSliverShimmerLoadingView extends StatelessWidget {
  final int childCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets padding;

  const PhotoTypeSliverShimmerLoadingView({
    super.key,
    this.childCount = 6,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.7,
    this.mainAxisSpacing = 3,
    this.crossAxisSpacing = 3,
    this.padding = const EdgeInsets.all(3.0),
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ShimmerLoader(
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
        childCount: childCount,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
    );
  }
}
