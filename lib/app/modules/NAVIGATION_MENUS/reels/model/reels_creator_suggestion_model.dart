class ReelsCreatorSuggestion {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;
  final bool isVerified;
  final int reelCount;
  final int totalViews;
  final int followerCount;
  final int mutualFriendCount;

  ReelsCreatorSuggestion({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    this.isVerified = false,
    this.reelCount = 0,
    this.totalViews = 0,
    this.followerCount = 0,
    this.mutualFriendCount = 0,
  });

  String get displayName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return '$first $last'.trim();
  }

  String get subtitle {
    if (mutualFriendCount > 0) {
      return '$mutualFriendCount mutual friend${mutualFriendCount > 1 ? 's' : ''}';
    }
    final label = followerCount > 0
        ? 'Digital creator · ${_formatCount(followerCount)} followers'
        : 'Digital creator';
    return label;
  }

  static String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
    return count.toString();
  }

  factory ReelsCreatorSuggestion.fromMap(Map<String, dynamic> map) {
    return ReelsCreatorSuggestion(
      id: map['_id']?.toString(),
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      username: map['username'] as String?,
      profilePic: map['profile_pic'] as String?,
      isVerified: map['is_verified'] == true,
      reelCount: (map['reelCount'] as num?)?.toInt() ?? 0,
      totalViews: (map['totalViews'] as num?)?.toInt() ?? 0,
      followerCount: (map['followerCount'] as num?)?.toInt() ?? 0,
      mutualFriendCount: (map['mutualFriendCount'] as num?)?.toInt() ?? 0,
    );
  }
}
