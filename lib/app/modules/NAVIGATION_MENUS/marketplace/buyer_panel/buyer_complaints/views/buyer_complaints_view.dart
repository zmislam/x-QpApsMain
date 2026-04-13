import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../extension/date_time_extension.dart';
import '../../../../../NAVIGATION_MENUS/buyer_panel/buyer_dashboard/models/buyer_complaint_model.dart';
import '../controllers/buyer_complaints_controller.dart';

class BuyerComplaintsView extends GetView<BuyerComplaintsController> {
  const BuyerComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Search ──
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: TextField(
            onChanged: (v) => controller.searchQuery.value = v,
            decoration: InputDecoration(
              hintText: 'Search complaints...',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3)),
              ),
            ),
          ),
        ),

        // ── List ──
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredComplaints.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: controller.fetchComplaints,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.filteredComplaints.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: MarketplaceDesignTokens.spacingSm),
                itemBuilder: (context, index) {
                  final complaint = controller.filteredComplaints[index];
                  return _ComplaintCard(
                    complaint: complaint,
                    onTap: () => _showComplaintDetail(context, complaint),
                    onDelete: () =>
                        _confirmDelete(context, complaint.id ?? ''),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_outlined,
              size: 64,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text(
            'No complaints',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your submitted complaints will appear here',
            style: TextStyle(
              fontSize: 14,
              color: MarketplaceDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintDetail(
      BuildContext context, BuyerComplaintModel complaint) {
    controller.fetchComplaintDetails(complaint.id ?? '');
    Get.bottomSheet(
      _ComplaintDetailSheet(),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String complaintId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Complaint'),
        content:
            const Text('Are you sure you want to delete this complaint?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteComplaint(complaintId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final BuyerComplaintModel complaint;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ComplaintCard({
    required this.complaint,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = complaint.status == 'pending';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        child: Padding(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      complaint.issueType ?? 'Complaint',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPending
                          ? Colors.amber.withOpacity(0.1)
                          : MarketplaceDesignTokens.primary
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isPending ? 'Pending' : 'Solved',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPending
                            ? Colors.amber.shade700
                            : MarketplaceDesignTokens.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Details preview
              if (complaint.details != null)
                Text(
                  complaint.details!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
              const SizedBox(height: 8),

              // Footer
              Row(
                children: [
                  if (complaint.store?.name != null) ...[
                    Icon(Icons.store_outlined,
                        size: 14,
                        color: MarketplaceDesignTokens.textSecondary(
                            context)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        complaint.store!.name!,
                        style: TextStyle(
                          fontSize: 12,
                          color: MarketplaceDesignTokens.textSecondary(
                              context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (complaint.createdAt != null)
                    Text(
                      complaint.createdAt.toString().toFormatDateOfBirth(),
                      style: TextStyle(
                        fontSize: 11,
                        color: MarketplaceDesignTokens.textSecondary(
                            context),
                      ),
                    ),
                  const Spacer(),
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.delete_outline,
                          size: 18, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComplaintDetailSheet extends GetView<BuyerComplaintsController> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Obx(() {
          if (controller.isLoadingDetail.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final c = controller.selectedComplaint.value;
          if (c == null) {
            return const Center(child: Text('Could not load details'));
          }

          return ListView(
            controller: scrollController,
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text('Complaint Details',
                  style: MarketplaceDesignTokens.heading(context)),
              const SizedBox(height: 16),

              _detailRow(context, 'Issue Type', c.issueType ?? '-'),
              _detailRow(
                  context, 'Status', (c.status ?? 'Pending').capitalizeFirst ?? 'Pending'),
              _detailRow(context, 'Store', c.store?.name ?? '-'),
              if (c.order?.invoiceNumber != null)
                _detailRow(
                    context, 'Order', '#${c.order!.invoiceNumber}'),
              _detailRow(context, 'Details', c.details ?? '-'),

              if (c.adminNote != null && c.adminNote!.isNotEmpty) ...[
                const Divider(height: 24),
                Text('Admin Response',
                    style: MarketplaceDesignTokens.sectionTitle(context)),
                const SizedBox(height: 8),
                Text(c.adminNote!,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          MarketplaceDesignTokens.textPrimary(context),
                    )),
              ],

              // Media
              if (c.media != null && c.media!.isNotEmpty) ...[
                const Divider(height: 24),
                Text('Attachments',
                    style: MarketplaceDesignTokens.sectionTitle(context)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: c.media!.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '${ApiConstant.SERVER_IP_PORT}/uploads/complaints/${c.media![index]}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Products
              if (c.products != null && c.products!.isNotEmpty) ...[
                const Divider(height: 24),
                Text('Products',
                    style: MarketplaceDesignTokens.sectionTitle(context)),
                const SizedBox(height: 8),
                ...c.products!.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${p.productName ?? 'Product'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: MarketplaceDesignTokens.textPrimary(
                              context),
                        ),
                      ),
                    )),
              ],

              const SizedBox(height: 24),
            ],
          );
        });
      },
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: MarketplaceDesignTokens.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
