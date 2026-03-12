import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'remove_button.dart';

class AttachmentThumbnail extends StatelessWidget {
  final XFile xFile;
  final VoidCallback onRemove;

  const AttachmentThumbnail({
    super.key,
    required this.xFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Image(
            fit: BoxFit.cover,
            height: 100,
            width: 100,
            image: FileImage(File(xFile.path)),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: InkWell(
            onTap: onRemove,
            child: const RemoveButton(),
          ),
        ),
      ],
    );
  }
}
