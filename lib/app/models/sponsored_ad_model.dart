/// Model for a sponsored ad placement from the EdgeRank feed API.
///
/// The API returns: `{ position: int, type: "sponsored", data: {...} }`
/// where `data` contains either a boosted page post or a campaign ad object.
class SponsoredAdModel {
  /// Position index within the batch of posts (used for anchoring).
  final int position;

  /// Always "sponsored".
  final String type;

  /// The ad/post data — either a boosted page post or campaign ad.
  final Map<String, dynamic> data;

  /// Whether this is a boosted page post (renders as a PostCard with "Sponsored" label).
  final bool isBoostedPagePost;

  /// Post ID this ad is anchored after (set client-side after matching with posts).
  String? anchorPostId;

  SponsoredAdModel({
    required this.position,
    required this.type,
    required this.data,
    this.isBoostedPagePost = false,
    this.anchorPostId,
  });

  factory SponsoredAdModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? {};
    return SponsoredAdModel(
      position: map['position'] as int? ?? 0,
      type: map['type'] as String? ?? 'sponsored',
      data: data,
      isBoostedPagePost: data['is_boosted_page_post'] == true,
    );
  }

  /// Campaign name from ad data.
  String? get campaignName => data['campaignName'] ?? data['campaign_name'] as String?;

  /// Campaign description.
  String? get description => data['description'] as String?;

  /// Website URL for the ad CTA - check multiple possible field names.
  String? get websiteUrl => 
    data['website_url'] as String? ?? 
    data['websiteUrl'] as String? ??
    (data['creative'] as Map?)?['website_url'] as String? ??
    (data['creative'] as Map?)?['websiteUrl'] as String?;
  
  /// CTA button label (e.g., "Learn More", "Shop Now").
  String get ctaLabel => 
    data['cta_label'] as String? ?? 
    data['ctaLabel'] as String? ?? 
    'Learn More';

  /// Campaign cover images/media.
  /// Supports both V1 (campaignCoverPic) and V2 (media array with media_type).
  List<String> get coverMedia {
    // V2 format: media: [{media: "filename", media_type: "image"|"video"}]
    final v2Media = data['media'] as List?;
    if (v2Media != null && v2Media.isNotEmpty) {
      return v2Media
          .map((e) {
            if (e is Map) return (e['media'] ?? '').toString();
            return e.toString();
          })
          .where((s) => s.isNotEmpty)
          .toList();
    }
    // V1 format: campaignCoverPic: ["filename1", "filename2"]
    final raw = data['campaignCoverPic'] as List?;
    if (raw == null) return [];
    return raw.map((e) => e.toString()).toList();
  }

  /// Media type of the first cover media item ("image" or "video").
  String get coverMediaType {
    final v2Media = data['media'] as List?;
    if (v2Media != null && v2Media.isNotEmpty) {
      final first = v2Media.first;
      if (first is Map) {
        return (first['media_type'] ?? 'image').toString();
      }
    }
    return 'image';
  }

  /// Whether the cover media is a video.
  bool get isVideo {
    if (coverMediaType == 'video') return true;
    final media = coverMedia;
    if (media.isEmpty) return false;
    final ext = media.first.split('.').last.toLowerCase();
    return ['mp4', 'webm', 'mov', 'avi', 'm4v'].contains(ext);
  }

  /// Ad/campaign ID.
  String? get adId => data['_id'] as String?;

  /// Ad set ID required by /api/campaigns-v2/beacon and /ad-impression.
  String? get adSetId =>
      data['ad_set_id']?.toString() ?? data['adSetId']?.toString();

  /// Reservation ticket ID used for confirmed impression flow.
  String? get reservationId =>
      data['reservation_id']?.toString() ?? data['reservationId']?.toString();

  /// Optional auction clear price in cents (used for impression billing context).
  int? get clearPriceCents {
    final auction = data['_auction'];
    if (auction is Map<String, dynamic>) {
      final raw = auction['clear_price_cents'];
      if (raw is int) return raw;
      if (raw is num) return raw.toInt();
      if (raw is String) return int.tryParse(raw);
    }
    final raw = data['clear_price_cents'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }
}
