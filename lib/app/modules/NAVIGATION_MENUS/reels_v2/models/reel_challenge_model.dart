class ReelChallengeModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? hashtag;
  final int participantCount;
  final int reelCount;
  final bool isActive;
  final String? soundId;
  final String? soundTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;

  ReelChallengeModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.hashtag,
    this.participantCount = 0,
    this.reelCount = 0,
    this.isActive = true,
    this.soundId,
    this.soundTitle,
    this.startDate,
    this.endDate,
    this.createdAt,
  });

  factory ReelChallengeModel.fromMap(Map<String, dynamic> map) {
    return ReelChallengeModel(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      thumbnailUrl: map['thumbnailUrl'] ?? map['thumbnail_url'],
      hashtag: map['hashtag'],
      participantCount:
          map['participantCount'] ?? map['participant_count'] ?? 0,
      reelCount: map['reelCount'] ?? map['reel_count'] ?? 0,
      isActive: map['isActive'] ?? map['is_active'] ?? true,
      soundId: map['soundId'] ?? map['sound_id'],
      soundTitle: map['soundTitle'] ?? map['sound_title'],
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate'].toString())
          : null,
      endDate: map['endDate'] != null
          ? DateTime.tryParse(map['endDate'].toString())
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'hashtag': hashtag,
      'participantCount': participantCount,
      'reelCount': reelCount,
      'isActive': isActive,
      'soundId': soundId,
      'soundTitle': soundTitle,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
