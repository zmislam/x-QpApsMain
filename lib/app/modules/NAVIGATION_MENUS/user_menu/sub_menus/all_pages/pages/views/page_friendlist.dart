import 'package:flutter/material.dart';
import '../../../../../../../extension/string/string_image_path.dart';

class PageFriendlist extends StatelessWidget {
  const PageFriendlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        child: ClipOval(
          child: Image(
            image: NetworkImage(('').formatedProfileUrl),
          ),
        ),
      ),
    );
  }
}
