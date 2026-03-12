import 'package:flutter/material.dart';
import 'dart:math';

import '../../config/constants/app_assets.dart';

class ReactionWidget extends StatefulWidget {
  final VoidCallback onComplete;
  final String selectedReaction;

  const ReactionWidget(
      {Key? key, required this.selectedReaction, required this.onComplete})
      : super(key: key);

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  double _top = 1000; // Starting position (bottom of the screen)
  final double _left =
      Random().nextDouble() * 200 + 100; // Random horizontal position
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Start the floating animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _top = 0; // Move to the top
        _opacity = 0; // Fade out
      });
    });

    // Remove the widget after the animation ends
    Future.delayed(const Duration(seconds: 3), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 3),
      curve: Curves.easeOut,
      top: _top,
      left: _left,
      child: AnimatedOpacity(
        duration: const Duration(seconds: 3),
        opacity: _opacity,
        child: reaction(widget.selectedReaction),
      ),
    );
  }

  Widget reaction(String reaction) {
    switch (reaction) {
      case 'like':
        return Image.asset(AppAssets.LIKE_ICON, height: 40, width: 40);
      case 'love':
        return Image.asset(AppAssets.LOVE_ICON, height: 40, width: 40);
      case 'haha':
        return Image.asset(AppAssets.HAHA_ICON, height: 40, width: 40);
      case 'wow':
        return Image.asset(AppAssets.WOW_ICON, height: 40, width: 40);
      case 'angry':
        return Image.asset(AppAssets.ANGRY_ICON, height: 40, width: 40);
      case 'sad':
        return Image.asset(AppAssets.SAD_ICON, height: 40, width: 40);
      case 'dislike':
        return Image.asset(AppAssets.UNLIKE_ICON, height: 40, width: 40);
      default:
        return Image.asset(AppAssets.LIKE_ACTION_ICON, height: 40, width: 40);
    }
  }
}
