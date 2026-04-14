import 'package:flutter/material.dart';

/// Dismissible yellow/orange warning banner for earning dashboard.
/// Shows when risk level is medium/high.
/// Message and CTA are dynamic — not hardcoded.
class AccountWarningBanner extends StatefulWidget {
  final String message;
  final VoidCallback? onViewDetails;

  const AccountWarningBanner({
    super.key,
    required this.message,
    this.onViewDetails,
  });

  @override
  State<AccountWarningBanner> createState() => _AccountWarningBannerState();
}

class _AccountWarningBannerState extends State<AccountWarningBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orange.shade700, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                if (widget.onViewDetails != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: widget.onViewDetails,
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(() => _dismissed = true),
            child: Icon(Icons.close,
                size: 16, color: Colors.orange.shade400),
          ),
        ],
      ),
    );
  }
}
