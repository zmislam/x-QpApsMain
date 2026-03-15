// =============================================================================
// Search Result Models — Data models for V2 search API responses
// =============================================================================
// Maps the JSON from /api/v2/search/* endpoints into typed Dart objects.
// Each model has a factory constructor `fromJson` for deserialization.
//
// Created: 2026-03-14
// =============================================================================

/// Wrapper for paginated search results per category.
class SearchResultPage<T> {
  final List<T> items;
  final int total;
  final bool hasMore;
  final String? nextCursor;

  SearchResultPage({
    required this.items,
    required this.total,
    required this.hasMore,
    this.nextCursor,
  });

  factory SearchResultPage.empty() =>
      SearchResultPage(items: [], total: 0, hasMore: false);
}

/// Full unified search response containing all categories.
class UnifiedSearchResult {
  final String query;
  final SearchResultPage<SearchPersonResult> people;
  final SearchResultPage<SearchPostResult> posts;
  final SearchResultPage<SearchReelResult> reels;
  final SearchResultPage<SearchPageResult> pages;
  final SearchResultPage<SearchGroupResult> groups;
  final SearchResultPage<SearchMarketplaceResult> marketplace;

  UnifiedSearchResult({
    required this.query,
    required this.people,
    required this.posts,
    required this.reels,
    required this.pages,
    required this.groups,
    required this.marketplace,
  });

  factory UnifiedSearchResult.empty() => UnifiedSearchResult(
        query: '',
        people: SearchResultPage.empty(),
        posts: SearchResultPage.empty(),
        reels: SearchResultPage.empty(),
        pages: SearchResultPage.empty(),
        groups: SearchResultPage.empty(),
        marketplace: SearchResultPage.empty(),
      );

  factory UnifiedSearchResult.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>? ?? {};
    return UnifiedSearchResult(
      query: json['query'] as String? ?? '',
      people: _parsePage(results['people'], SearchPersonResult.fromJson),
      posts: _parsePage(results['posts'], SearchPostResult.fromJson),
      reels: _parsePage(results['reels'], SearchReelResult.fromJson),
      pages: _parsePage(results['pages'], SearchPageResult.fromJson),
      groups: _parsePage(results['groups'], SearchGroupResult.fromJson),
      marketplace:
          _parsePage(results['marketplace'], SearchMarketplaceResult.fromJson),
    );
  }
}

SearchResultPage<T> _parsePage<T>(
  dynamic json,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (json == null || json is! Map<String, dynamic>) {
    return SearchResultPage.empty();
  }
  final items = (json['items'] as List?)
          ?.map((e) => fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];
  return SearchResultPage(
    items: items,
    total: (json['total'] as num?)?.toInt() ?? items.length,
    hasMore: json['hasMore'] as bool? ?? false,
    nextCursor: json['nextCursor'] as String?,
  );
}

// =============================================================================
//  Person Result
// =============================================================================

class SearchPersonResult {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String? profilePic;
  final String? coverPhoto;
  final String? bio;
  final String? presentTown;
  final bool verified;
  final int followersCount;
  final bool isFriend;
  final String friendStatus; // "none" | "friend" | "request_sent" | "request_received"
  final int mutualFriendsCount;

  SearchPersonResult({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.profilePic,
    this.coverPhoto,
    this.bio,
    this.presentTown,
    this.verified = false,
    this.followersCount = 0,
    this.isFriend = false,
    this.friendStatus = 'none',
    this.mutualFriendsCount = 0,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory SearchPersonResult.fromJson(Map<String, dynamic> json) {
    // followers may be an array or a number
    int followersCount = 0;
    final followers = json['followers'];
    if (followers is List) {
      followersCount = followers.length;
    } else if (followers is num) {
      followersCount = followers.toInt();
    }

    return SearchPersonResult(
      id: json['_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString(),
      coverPhoto: json['cover_photo']?.toString(),
      bio: json['bio']?.toString(),
      presentTown: json['present_town']?.toString(),
      verified: json['verified'] == true,
      followersCount: followersCount,
      isFriend: json['isFriend'] == true,
      friendStatus: json['friendStatus']?.toString() ?? 'none',
      mutualFriendsCount:
          (json['mutualFriendsCount'] as num?)?.toInt() ?? 0,
    );
  }

  /// Create a copy with updated friendStatus.
  SearchPersonResult copyWith({String? friendStatus, bool? isFriend}) {
    return SearchPersonResult(
      id: id,
      firstName: firstName,
      lastName: lastName,
      username: username,
      profilePic: profilePic,
      coverPhoto: coverPhoto,
      bio: bio,
      presentTown: presentTown,
      verified: verified,
      followersCount: followersCount,
      isFriend: isFriend ?? this.isFriend,
      friendStatus: friendStatus ?? this.friendStatus,
      mutualFriendsCount: mutualFriendsCount,
    );
  }
}

// =============================================================================
//  Embedded User (for posts, reels, marketplace seller)
// =============================================================================

class EmbeddedUser {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String? profilePic;
  final bool verified;

  EmbeddedUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.profilePic,
    this.verified = false,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory EmbeddedUser.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return EmbeddedUser(id: '', firstName: '', lastName: '', username: '');
    }
    return EmbeddedUser(
      id: json['_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString(),
      verified: json['verified'] == true,
    );
  }
}

// =============================================================================
//  Post Result
// =============================================================================

class SearchPostResult {
  final String id;
  final String? description;
  final String? privacy;
  final String? createdAt;
  final EmbeddedUser? user;
  final List<String> mediaUrls;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;

  SearchPostResult({
    required this.id,
    this.description,
    this.privacy,
    this.createdAt,
    this.user,
    this.mediaUrls = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
  });

  factory SearchPostResult.fromJson(Map<String, dynamic> json) {
    // Extract media URLs from media array
    final List<String> media = [];
    final rawMedia = json['media'] as List?;
    if (rawMedia != null) {
      for (final m in rawMedia) {
        if (m is Map<String, dynamic> && m['media'] != null) {
          media.add(m['media'].toString());
        }
      }
    }
    // Fallback to images array
    if (media.isEmpty && json['images'] is List) {
      for (final img in json['images']) {
        media.add(img.toString());
      }
    }

    return SearchPostResult(
      id: json['_id']?.toString() ?? '',
      description: json['description']?.toString(),
      privacy: json['privacy']?.toString(),
      createdAt: json['createdAt']?.toString(),
      user: EmbeddedUser.fromJson(json['user_id']),
      mediaUrls: media,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      sharesCount: (json['shares_count'] as num?)?.toInt() ?? 0,
      isLiked: json['is_liked'] == true || json['isLiked'] == true,
    );
  }
}

// =============================================================================
//  Reel Result
// =============================================================================

class SearchReelResult {
  final String id;
  final String? title;
  final String? description;
  final String? thumbnail;
  final double duration; // seconds
  final int viewsCount;
  final int likesCount;
  final String? createdAt;
  final EmbeddedUser? user;

  SearchReelResult({
    required this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.duration = 0,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.createdAt,
    this.user,
  });

  /// Format duration as M:SS or H:MM:SS.
  String get formattedDuration {
    final totalSeconds = duration.round();
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  factory SearchReelResult.fromJson(Map<String, dynamic> json) {
    return SearchReelResult(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      duration: (json['duration'] as num?)?.toDouble() ?? 0,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt']?.toString(),
      user: EmbeddedUser.fromJson(json['user_id']),
    );
  }
}

// =============================================================================
//  Page Result
// =============================================================================

class SearchPageResult {
  final String id;
  final String pageName;
  final String? username;
  final String? description;
  final String? bio;
  final String? profilePic;
  final String? coverImage;
  final String? category;
  final bool verified;
  final int followersCount;
  final int likesCount;
  final String? locationCity;
  final String? website;
  final bool isFollowing;

  SearchPageResult({
    required this.id,
    required this.pageName,
    this.username,
    this.description,
    this.bio,
    this.profilePic,
    this.coverImage,
    this.category,
    this.verified = false,
    this.followersCount = 0,
    this.likesCount = 0,
    this.locationCity,
    this.website,
    this.isFollowing = false,
  });

  /// Preferred avatar: profile_pic > cover_image.
  String? get avatarUrl => profilePic ?? coverImage;

  factory SearchPageResult.fromJson(Map<String, dynamic> json) {
    String? city;
    final loc = json['location'];
    if (loc is Map<String, dynamic>) {
      city = loc['city']?.toString();
    }

    return SearchPageResult(
      id: json['_id']?.toString() ?? '',
      pageName: json['page_name']?.toString() ?? '',
      username: json['username']?.toString(),
      description: json['description']?.toString() ?? json['about']?.toString(),
      bio: json['bio']?.toString(),
      profilePic: json['profile_pic']?.toString(),
      coverImage: json['cover_image']?.toString(),
      category: json['category']?.toString(),
      verified: json['verified'] == true,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      locationCity: city,
      website: json['website']?.toString(),
      isFollowing: json['isFollowing'] == true,
    );
  }

  SearchPageResult copyWith({bool? isFollowing}) {
    return SearchPageResult(
      id: id,
      pageName: pageName,
      username: username,
      description: description,
      bio: bio,
      profilePic: profilePic,
      coverImage: coverImage,
      category: category,
      verified: verified,
      followersCount: followersCount,
      likesCount: likesCount,
      locationCity: locationCity,
      website: website,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

// =============================================================================
//  Group Result
// =============================================================================

class SearchGroupResult {
  final String id;
  final String groupName;
  final String? groupUsername;
  final String? description;
  final String? coverImage;
  final int membersCount;
  final int postsCount;
  final String privacy; // "public" | "private"
  final String? category;
  final bool isMember;

  SearchGroupResult({
    required this.id,
    required this.groupName,
    this.groupUsername,
    this.description,
    this.coverImage,
    this.membersCount = 0,
    this.postsCount = 0,
    this.privacy = 'public',
    this.category,
    this.isMember = false,
  });

  factory SearchGroupResult.fromJson(Map<String, dynamic> json) {
    return SearchGroupResult(
      id: json['_id']?.toString() ?? '',
      groupName: json['group_name']?.toString() ?? '',
      groupUsername: json['group_username']?.toString(),
      description: json['group_description']?.toString() ??
          json['description']?.toString(),
      coverImage: json['cover_image']?.toString(),
      membersCount: (json['members_count'] as num?)?.toInt() ?? 0,
      postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
      privacy: json['privacy']?.toString() ?? 'public',
      category: json['category']?.toString(),
      isMember: json['isMember'] == true,
    );
  }

  SearchGroupResult copyWith({bool? isMember}) {
    return SearchGroupResult(
      id: id,
      groupName: groupName,
      groupUsername: groupUsername,
      description: description,
      coverImage: coverImage,
      membersCount: membersCount,
      postsCount: postsCount,
      privacy: privacy,
      category: category,
      isMember: isMember ?? this.isMember,
    );
  }
}

// =============================================================================
//  Marketplace Result
// =============================================================================

class SearchMarketplaceResult {
  final String id;
  final String title;
  final String? description;
  final double price;
  final String currency;
  final List<String> images;
  final String? condition;
  final String? category;
  final String? locationCity;
  final String? createdAt;
  final int viewCount;
  final EmbeddedUser? seller;

  SearchMarketplaceResult({
    required this.id,
    required this.title,
    this.description,
    this.price = 0,
    this.currency = 'USD',
    this.images = const [],
    this.condition,
    this.category,
    this.locationCity,
    this.createdAt,
    this.viewCount = 0,
    this.seller,
  });

  factory SearchMarketplaceResult.fromJson(Map<String, dynamic> json) {
    final List<String> imgs = [];
    if (json['images'] is List) {
      for (final img in json['images']) {
        imgs.add(img.toString());
      }
    }

    String? city;
    final loc = json['location'];
    if (loc is Map<String, dynamic>) {
      city = loc['city']?.toString();
    }

    return SearchMarketplaceResult(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['product_name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'USD',
      images: imgs,
      condition: json['condition']?.toString(),
      category: json['category']?.toString(),
      locationCity: city,
      createdAt: json['createdAt']?.toString(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      seller: EmbeddedUser.fromJson(json['seller_id']),
    );
  }
}
