import 'package:flutter/material.dart';

import '../config/constants/color.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.verticalPadding = 20,
    this.backgroundColor = PRIMARY_COLOR,
    this.textColor = Colors.white,
    this.horizontalPadding = 50,
    this.fontSize = 20,
    this.borderRadius,
    this.fontWeight = FontWeight.bold,
  });
  final VoidCallback onPressed;
  final String text;
  final double verticalPadding;
  final Color backgroundColor;
  final Color textColor;
  final double horizontalPadding;
  final double fontSize;
  final BorderRadius? borderRadius;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10)),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        textStyle: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: 'SfProDisplay',
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class PrimaryIconButton extends StatelessWidget {
  final String? text;
  final Color textColor;
  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final FontWeight fontWeight;
  final Widget iconWidget;
  final VoidCallback onPressed;

  const PrimaryIconButton({
    super.key,
    required this.onPressed,
    required this.iconWidget,
    this.text,
    this.verticalPadding = 20,
    this.backgroundColor = PRIMARY_COLOR,
    this.textColor = Colors.white,
    this.horizontalPadding = 50,
    this.fontSize = 20,
    this.borderRadius,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(10)),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
        ),
        onPressed: onPressed,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(width: text != null ? 8 : 0),
            text != null
                ? Text(
                    text ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: fontWeight,
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }
}

class PrimaryOutlinedButton extends StatelessWidget {
  const PrimaryOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.horizontalPadding = 50,
    this.verticalPadding = 16,
    this.color = PRIMARY_COLOR,
  });
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final double horizontalPadding;
  final double verticalPadding;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: color),
      ),
    );
  }
}

class PostActionButton extends StatelessWidget {
  const PostActionButton({
    super.key,
    required this.assetName,
    required this.text,
    required this.onPressed,
  });

  final String assetName;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
              height: 20,
              image: AssetImage(assetName),
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ));
  }
}

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    required this.text,
    required this.horizontalPadding,
    required this.verticalPadding,
    this.bgColor = PRIMARY_COLOR,
    required this.onPressed,
    this.borderRadius,
    this.textSize,
    this.imageColor,
    this.textColor,
    this.imagePath,
  });

  final VoidCallback onPressed;
  final String text;
  final Color bgColor;
  final Color? textColor;
  final Color? imageColor;
  final String? imagePath;
  final double horizontalPadding;
  final double? textSize;
  final double verticalPadding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ??
                BorderRadius.circular(
                  10,
                ),
          ),
          minimumSize: Size(horizontalPadding, verticalPadding), //////// HERE
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              color: imageColor,
              height: 20,
              image: AssetImage(imagePath ?? ''),
            ),
            const SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                text,
                style: TextStyle(
                    color: textColor ?? PRIMARY_LIGHT_COLOR,
                    fontSize: textSize ?? 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ));
  }
}

class PrimaryImageButton extends StatelessWidget {
  const PrimaryImageButton({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.size = 28,
  });
  final String imagePath;
  final void Function() onTap;
  final double size;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image(
        height: size,
        width: size,
        image: AssetImage(imagePath),
      ),
    );
  }
}
