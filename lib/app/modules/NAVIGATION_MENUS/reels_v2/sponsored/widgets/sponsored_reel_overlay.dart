import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/sponsored_reel_model.dart';
import '../controllers/reels_sponsored_controller.dart';
import 'sponsored_cta_button.dart';
import 'ad_feedback_menu.dart';
import 'why_this_ad_sheet.dart';

/// Full-screen overlay for a sponsored reel in the V2 feed.
/// Shows "Sponsored" label, author info, CTA button, and ad controls.
class SponsoredReelOverlay extends StatefulWidget {
  final SponsoredReelModel ad;
  final VoidCallback? onDismiss;

  const SponsoredReelOverlay({
    super.key,
    required this.ad,
    this.onDismiss,
  });

  @override
  State<SponsoredReelOverlay> createState() => _SponsoredReelOverlayState();
}

class _SponsoredReelOverlayState extends State<SponsoredReelOverlay> {
  late final ReelsSponsoredController _controller;
  bool _impressionTracked = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ReelsSponsoredController>();
    // Track impression after 1 second of view
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_impressionTracked) {
        _impressionTracked = true;
        _controller.onSponsoredReelViewed(widget.ad);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─── Bottom-left: Author info + Sponsored label + Caption ───
        Positioned(
          left: 16,
          right: 80,
          bottom: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sponsored label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Sponsored',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Author row
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: widget.ad.advertiserAvatar != null
                        ? NetworkImage(widget.ad.advertiserAvatar!)
                        : null,
                    child: widget.ad.advertiserAvatar == null
                        ? const Icon(Icons.business, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.ad.advertiserName ?? 'Advertiser',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.ad.isVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.verified, color: Colors.blue, size: 14),
                    ),
                ],
              ),
              if (widget.ad.caption != null && widget.ad.caption!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.ad.caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),

        // ─── Bottom: CTA Button ───
        Positioned(
          left: 16,
          right: 16,
          bottom: 40,
          child: SponsoredCtaButton(
            label: widget.ad.ctaLabel ?? 'Learn More',
            onTap: () => _controller.onCtaTapped(widget.ad),
          ),
        ),

        // ─── Top-right: Ad feedback menu ───
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 8,
          child: AdFeedbackMenu(
            onHideAd: () {
              _controller.hideAd(widget.ad);
              widget.onDismiss?.call();
            },
            onNotInterested: () {
              _controller.markNotInterested(widget.ad);
              widget.onDismiss?.call();
            },
            onReportAd: () {
              _controller.reportAd(widget.ad);
              widget.onDismiss?.call();
            },
            onWhyThisAd: () {
              _showWhyThisAd(context);
            },
          ),
        ),
      ],
    );
  }

  void _showWhyThisAd(BuildContext context) async {
    final reason = await _controller.getTargetingReason(widget.ad.id ?? '');
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => WhyThisAdSheet(
        advertiserName: widget.ad.advertiserName ?? 'Advertiser',
        reason: reason ?? 'This ad is shown based on your interests and activity.',
        categories: widget.ad.targetingCategories,
      ),
    );
  }
}
