/// Model for the /friends-things-in-common API response.
///
/// Each [ThingsInCommonItem] represents one attribute the current user
/// has in common with some of their friends (e.g. hometown, workplace,
/// language, birthday month, etc.).

class ThingsInCommonResponse {
  final List<ThingsInCommonItem> results;

  const ThingsInCommonResponse({required this.results});

  factory ThingsInCommonResponse.fromJson(Map<String, dynamic> json) {
    return ThingsInCommonResponse(
      results: ((json['results'] ?? []) as List)
          .map((e) => ThingsInCommonItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ThingsInCommonItem {
  /// Category key – location | home_town | education | workplace | language | date_of_birth
  final String type;

  /// Human-readable value – "Dhaka, Bangladesh", "English language", etc.
  final String label;

  /// Category subtitle – "Location", "Home town", "Education", etc.
  final String subtitle;

  /// Icon hint from backend (not used directly but kept for flexibility)
  final String icon;

  /// Total number of friends who share this attribute
  final int totalCount;

  /// Up to 3 sample friends
  final List<SampleFriend> sampleFriends;

  const ThingsInCommonItem({
    required this.type,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.totalCount,
    required this.sampleFriends,
  });

  factory ThingsInCommonItem.fromJson(Map<String, dynamic> json) {
    return ThingsInCommonItem(
      type: json['type'] ?? '',
      label: json['label'] ?? '',
      subtitle: json['subtitle'] ?? '',
      icon: json['icon'] ?? '',
      totalCount: json['total_count'] ?? 0,
      sampleFriends: ((json['sample_friends'] ?? []) as List)
          .map((e) => SampleFriend.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SampleFriend {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String profilePic;

  String get fullName => '$firstName $lastName'.trim();

  const SampleFriend({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profilePic,
  });

  factory SampleFriend.fromJson(Map<String, dynamic> json) {
    return SampleFriend(
      id: json['_id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      profilePic: json['profile_pic'] ?? '',
    );
  }
}
