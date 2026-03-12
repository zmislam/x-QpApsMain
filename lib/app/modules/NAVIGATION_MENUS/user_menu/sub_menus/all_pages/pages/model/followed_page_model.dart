class FollowedPageModel {
  FollowedPageModel({
    required this.id,
    required this.pageName,
    required this.category,
    required this.bio,
    required this.profilePic,
    required this.coverPic,
    required this.pageUserName,
    required this.userPageSettings,
    required this.followerCount,
  });

  final String? id;
  final String? pageName;
  final List<String> category;
  final String? bio;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final List<dynamic> userPageSettings;
  final int? followerCount;

  FollowedPageModel copyWith({
    String? id,
    String? pageName,
    List<String>? category,
    String? bio,
    String? profilePic,
    String? coverPic,
    String? pageUserName,
    List<dynamic>? userPageSettings,
    int? followerCount,
  }) {
    return FollowedPageModel(
      id: id ?? this.id,
      pageName: pageName ?? this.pageName,
      category: category ?? this.category,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
      pageUserName: pageUserName ?? this.pageUserName,
      userPageSettings: userPageSettings ?? this.userPageSettings,
      followerCount: followerCount ?? this.followerCount,
    );
  }

  factory FollowedPageModel.fromMap(Map<String, dynamic> json) {
    return FollowedPageModel(
      id: json['_id'],
      pageName: json['page_name'],
      category: json['category'] == null
          ? []
          : List<String>.from(json['category']!.map((x) => x)),
      bio: json['bio'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      pageUserName: json['page_user_name'],
      userPageSettings: json['userPageSettings'] == null
          ? []
          : List<dynamic>.from(json['userPageSettings']!.map((x) => x)),
      followerCount: json['followerCount'],
    );
  }

  @override
  String toString() {
    return '$id, $pageName, $category, $bio, $profilePic, $coverPic, $pageUserName, $userPageSettings, $followerCount, ';
  }
}
