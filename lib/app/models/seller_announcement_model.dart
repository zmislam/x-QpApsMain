class SellerAnnouncementModel {
  final String id;
  final String title;
  final String body;
  final String type; // info, warning, promotion
  final String target; // all_sellers, verified_only
  final DateTime? publishedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  SellerAnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'info',
    this.target = 'all_sellers',
    this.publishedAt,
    this.expiresAt,
    this.createdAt,
  });

  factory SellerAnnouncementModel.fromMap(Map<String, dynamic> map) {
    return SellerAnnouncementModel(
      id: map['_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      type: map['type']?.toString() ?? 'info',
      target: map['target']?.toString() ?? 'all_sellers',
      publishedAt: map['published_at'] != null
          ? DateTime.tryParse(map['published_at'].toString())
          : null,
      expiresAt: map['expires_at'] != null
          ? DateTime.tryParse(map['expires_at'].toString())
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }
}
