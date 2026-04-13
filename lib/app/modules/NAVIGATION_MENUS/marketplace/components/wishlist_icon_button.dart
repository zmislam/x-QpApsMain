import 'package:flutter/material.dart';
import '../../../../config/constants/color.dart';

class WishlistIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isWishListed;
  final double iconSize;
  final double padding;
  final double topPosition;
  final double rightPosition;

  const WishlistIconButton({
    Key? key,
    required this.onPressed,
    required this.isWishListed,
    this.iconSize = 16,
    this.padding = 5,
    this.topPosition = 5,
    this.rightPosition = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: rightPosition,
      top: topPosition,
      child: Semantics(
        button: true,
        label: isWishListed ? 'Remove from wishlist' : 'Add to wishlist',
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              border: Border.all(color: PRIMARY_COLOR, width: 1),
              borderRadius: BorderRadius.circular(20),
              color: PRIMARY_COLOR_LIGHT,
            ),
            child: Icon(
              isWishListed ? Icons.favorite : Icons.favorite_border_outlined,
              color: PRIMARY_COLOR,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
