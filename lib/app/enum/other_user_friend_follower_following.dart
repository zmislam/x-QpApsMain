enum FriendCategory { All, MutualFriends, Following, Followers }

extension FriendCategoryExtension on FriendCategory {
  String get displayTitle {
    switch (this) {
      case FriendCategory.All:
        return 'All';
      case FriendCategory.MutualFriends:
        return 'Mutual Friends';
      case FriendCategory.Following:
        return 'Following';
      case FriendCategory.Followers:
        return 'Followers';
    }
  }
}
