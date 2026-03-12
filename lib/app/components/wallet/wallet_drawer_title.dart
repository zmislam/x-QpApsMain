import 'package:flutter/material.dart';

class WalletDrawerTitle extends StatelessWidget {
  const WalletDrawerTitle({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 15,
          ),
          Image(
            height: 18,
            width: 18,
            image: AssetImage(
              iconPath,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          )
        ],
      ),
    );
  }
}
