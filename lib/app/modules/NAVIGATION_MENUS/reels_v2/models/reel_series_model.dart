class ReelSeriesModel {
  final String id;
  final String title;
  final String? description;
  final String authorId;
  final String? authorName;
  final String? coverUrl;
  final int reelCount;
  final List<String>? reelIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReelSeriesModel({
    required this.id,
    required this.title,
    this.description,
    required this.authorId,
    this.authorName,
    this.coverUrl,
    this.reelCount = 0,
    this.reelIds,
    this.createdAt,
    this.updatedAt,
  });

  factory ReelSeriesModel.fromMap(Map<String, dynamic> map) {
    return ReelSeriesModel(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      authorId: map['authorId'] ?? map['author_id'] ?? '',
      authorName: map['authorName'] ?? map['author_name'],
      coverUrl: map['coverUrl'] ?? map['cover_url'],
      reelCount: map['reelCount'] ?? map['reel_count'] ?? 0,
      reelIds: (map['reelIds'] ?? map['reel_ids'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'coverUrl': coverUrl,
      'reelCount': reelCount,
      'reelIds': reelIds,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
