import 'package:flutter/material.dart';

class UserPropertyCard extends StatelessWidget {
  final String asset;
  final String title;
  final IconData? icon;
  final double? iconSize;
  final VoidCallback onTap;
  final bool? isPageProfile;

  const UserPropertyCard({
    super.key,
    required this.asset,
    required this.title,
    required this.onTap,
    this.isPageProfile = false,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return isPageProfile == false
        ? InkWell(
            onTap: onTap,
            child: Card(
              // color: Colors.white,
              child: Row(
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        icon,
                        // ? DEFAULT IS 34 GIVEN ...
                        size: iconSize ?? 34,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  if (icon == null)
                    Image(
                      height: 64,
                      width: 64,
                      image: AssetImage(
                        asset,
                      ),
                    ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
