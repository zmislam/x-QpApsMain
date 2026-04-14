import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Status badge widget for boost campaigns.
/// Displays the current status with appropriate color coding.
/// States: Draft, Pending, Active, Paused, Completed.
class BoostStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const BoostStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configForStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.capitalize ?? status,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _configForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return _StatusConfig(
          bgColor: Colors.grey.withOpacity(0.12),
          textColor: Colors.grey[700]!,
          dotColor: Colors.grey[500]!,
        );
      case 'pending':
        return _StatusConfig(
          bgColor: Colors.blue.withOpacity(0.12),
          textColor: Colors.blue[700]!,
          dotColor: Colors.blue[500]!,
        );
      case 'active':
        return _StatusConfig(
          bgColor: Colors.green.withOpacity(0.12),
          textColor: Colors.green[700]!,
          dotColor: Colors.green[500]!,
        );
      case 'paused':
        return _StatusConfig(
          bgColor: Colors.orange.withOpacity(0.12),
          textColor: Colors.orange[700]!,
          dotColor: Colors.orange[500]!,
        );
      case 'completed':
        return _StatusConfig(
          bgColor: Colors.purple.withOpacity(0.12),
          textColor: Colors.purple[700]!,
          dotColor: Colors.purple[500]!,
        );
      default:
        return _StatusConfig(
          bgColor: Colors.grey.withOpacity(0.12),
          textColor: Colors.grey[700]!,
          dotColor: Colors.grey[500]!,
        );
    }
  }
}

class _StatusConfig {
  final Color bgColor;
  final Color textColor;
  final Color dotColor;
  const _StatusConfig({
    required this.bgColor,
    required this.textColor,
    required this.dotColor,
  });
}
