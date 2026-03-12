import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EventTile extends StatelessWidget {
  final String name;
  final String imageURL;
  final VoidCallback onPressed;

  const EventTile(
      {super.key,
      required this.name,
      required this.imageURL,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imageURL,
              width: 32,
              height: 26,
              color: Get.theme.iconTheme.color,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(name)
          ],
        ),
      ),
    );
  }
}
