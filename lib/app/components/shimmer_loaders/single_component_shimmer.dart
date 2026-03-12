import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SingleComponentShimmer extends StatelessWidget {
  final double? height;
  final EdgeInsets? padding;

  const SingleComponentShimmer({super.key, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(colors: [
        Theme.of(context).primaryColorLight,
        Theme.of(context).secondaryHeaderColor,
      ]),
      direction: ShimmerDirection.ltr,
      child: Container(
        height: height ?? 60,
        width: double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
