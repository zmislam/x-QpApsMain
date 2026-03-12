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
  String? get campaignName => data['campaignName'] as String?;

  /// Campaign description.
  String? get description => data['description'] as String?;

  /// Website URL for the ad CTA.
  String? get websiteUrl => data['websiteUrl'] as String?;

  /// Campaign cover images/media.
  List<String> get coverMedia {
    final raw = data['campaignCoverPic'] as List?;
    if (raw == null) return [];
    return raw.map((e) => e.toString()).toList();
  }

  /// Ad/campaign ID.
  String? get adId => data['_id'] as String?;
}
