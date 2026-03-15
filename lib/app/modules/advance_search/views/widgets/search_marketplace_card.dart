// =============================================================================
// Search Marketplace Card — Product listing card for marketplace search
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../config/constants/api_constant.dart';
import '../../models/search_result_models.dart';

class SearchMarketplaceCard extends StatelessWidget {
  final SearchMarketplaceResult product;
  final VoidCallback onTap;

  const SearchMarketplaceCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasImage = product.images.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: hasImage
                    ? Image.network(
                        product.images.first.startsWith('http')
                            ? product.images.first
                            : '${ApiConstant.SERVER_IP_PORT}/${product.images.first}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(isDark),
                      )
                    : _placeholder(isDark),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    '${product.currency} ${product.price.toStringAsFixed(product.price == product.price.roundToDouble() ? 0 : 2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Title
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Location
                  if (product.locationCity != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.locationCity!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      child: const Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.grey),
    );
  }
}
