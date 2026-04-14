class ReelCollectionModel {
  final String id;
  final String name;
  final String? description;
  final int reelCount;
  final List<String>? coverUrls;
  final String? ownerId;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReelCollectionModel({
    required this.id,
    required this.name,
    this.description,
    this.reelCount = 0,
    this.coverUrls,
    this.ownerId,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ReelCollectionModel.fromMap(Map<String, dynamic> map) {
    return ReelCollectionModel(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      reelCount: map['reelCount'] ?? map['reel_count'] ?? 0,
      coverUrls: (map['coverUrls'] ?? map['cover_urls'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      ownerId: map['ownerId'] ?? map['owner_id'],
      isDefault: map['isDefault'] ?? map['is_default'] ?? false,
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
      'name': name,
      'description': description,
      'reelCount': reelCount,
      'coverUrls': coverUrls,
      'ownerId': ownerId,
      'isDefault': isDefault,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ReelCollectionModel copyWith({
    String? name,
    String? description,
    int? reelCount,
    List<String>? coverUrls,
  }) {
    return ReelCollectionModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      reelCount: reelCount ?? this.reelCount,
      coverUrls: coverUrls ?? this.coverUrls,
      ownerId: ownerId,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
