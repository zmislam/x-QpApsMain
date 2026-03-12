import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletAmountCardWithTitle extends StatelessWidget {
  final String title;
  final String amount;
  final IconData? iconData;
  final String? assetPath;
  final Color? iconColor;

  const WalletAmountCardWithTitle(
      {super.key,
      required this.title,
      required this.amount,
      this.iconData,
      this.assetPath,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconData == null
              ? CircleAvatar(
                  backgroundImage: AssetImage(assetPath!),
                  backgroundColor: iconColor != null
                      ? iconColor!.withValues(alpha: 0.1)
                      : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  radius: 30,
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundColor: iconColor != null
                      ? iconColor!.withValues(alpha: 0.1)
                      : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    iconData,
                    size: 30,
                    color: iconColor ?? Theme.of(context).primaryColor,
                  ),
                ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text('\$$amount'.tr,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 19, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
