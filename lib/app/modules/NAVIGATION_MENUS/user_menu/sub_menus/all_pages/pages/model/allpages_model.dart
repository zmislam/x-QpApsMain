class AllPagesModel {
  AllPagesModel({
    required this.id,
    required this.pageName,
    required this.category,
    required this.bio,
    required this.profilePic,
    required this.coverPic,
    required this.pageUserName,
    required this.followerCount,
    required this.status,
    required this.totalCount,
  });

  final String? id;
  final String? pageName;
  final List<String> category;
  final String? bio;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final int? followerCount;
  final int? status;
  final int? totalCount;

  AllPagesModel copyWith({
    String? id,
    String? pageName,
    List<String>? category,
    String? bio,
    String? profilePic,
    String? coverPic,
    String? pageUserName,
    int? followerCount,
    int? status,
    int? totalCount,
  }) {
    return AllPagesModel(
      id: id ?? this.id,
      pageName: pageName ?? this.pageName,
      category: category ?? this.category,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
      pageUserName: pageUserName ?? this.pageUserName,
      followerCount: followerCount ?? this.followerCount,
      status: status ?? this.status,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  factory AllPagesModel.fromMap(Map<String, dynamic> json) {
    return AllPagesModel(
      id: json['_id'],
      pageName: json['page_name'],
      category: json['category'] == null
          ? []
          : List<String>.from(json['category']!.map((x) => x)),
      bio: json['bio'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      pageUserName: json['page_user_name'],
      followerCount: json['followerCount'],
      status: json['status'],
      totalCount: json['totalCount'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'page_name': pageName,
    'category': category.map((x) => x).toList(),
    'bio': bio,
    'profile_pic': profilePic,
    'cover_pic': coverPic,
    'page_user_name': pageUserName,
    'followerCount': followerCount,
    'status': status,
    'totalCount': totalCount,
  };

  @override
  String toString() {
    return '$id, $pageName, $category, $bio, $profilePic, $coverPic, $pageUserName, $followerCount, $status, $totalCount, ';
  }
}