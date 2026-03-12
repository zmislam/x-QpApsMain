import 'package:flutter/material.dart';

class LiveTopWidget extends StatelessWidget {
  /// how many user joined in live just pass the value
  final String? joinUserCount;

  const LiveTopWidget({this.joinUserCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // =========================== right section ===========================
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 4, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    joinUserCount ?? '0',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
