import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.close, color: Colors.white),
    );
  }
}
