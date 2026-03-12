import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final Widget child;
  const ShimmerLoader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withValues(alpha: .3),
        highlightColor: Colors.grey.withValues(alpha: .1),
        enabled: true,
        child: child,
      ),
    );
  }
}
