import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageMoreMeidaCoutHover extends StatelessWidget {
  const PageMoreMeidaCoutHover({
    Key? key,
    required this.child,
    required this.moreCount,
    this.fontSize = 20,
  }) : super(key: key);

  final Widget child;
  final int moreCount;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: child,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            child: Center(
              child: Text('+ $moreCount'.tr,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
