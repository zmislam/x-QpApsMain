class ReelHashtagModel {
  final String id;
  final String name;
  final int reelCount;
  final String? description;
  final bool isTrending;
  final String? coverUrl;
  final DateTime? createdAt;

  ReelHashtagModel({
    required this.id,
    required this.name,
    this.reelCount = 0,
    this.description,
    this.isTrending = false,
    this.coverUrl,
    this.createdAt,
  });

  factory ReelHashtagModel.fromMap(Map<String, dynamic> map) {
    return ReelHashtagModel(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      reelCount: map['reelCount'] ?? map['reel_count'] ?? 0,
      description: map['description'],
      isTrending: map['isTrending'] ?? map['is_trending'] ?? false,
      coverUrl: map['coverUrl'] ?? map['cover_url'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'reelCount': reelCount,
      'description': description,
      'isTrending': isTrending,
      'coverUrl': coverUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
