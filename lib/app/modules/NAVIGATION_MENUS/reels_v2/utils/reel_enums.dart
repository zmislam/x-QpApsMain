/// Reels V2 Feed Types
enum ReelFeedType {
  forYou,
  following,
  trending,
  hashtag,
  sound,
  location,
  topic,
  related,
  challenges,
}

/// Reel privacy settings
enum ReelPrivacy {
  public_,
  friends,
  private_;

  String get value {
    switch (this) {
      case ReelPrivacy.public_:
        return 'public';
      case ReelPrivacy.friends:
        return 'friends';
      case ReelPrivacy.private_:
        return 'private';
    }
  }

  static ReelPrivacy fromString(String? value) {
    switch (value) {
      case 'friends':
        return ReelPrivacy.friends;
      case 'private':
        return ReelPrivacy.private_;
      default:
        return ReelPrivacy.public_;
    }
  }
}

/// Reel comment permission
enum ReelCommentPermission {
  everyone,
  friends,
  off;

  String get value => name;

  static ReelCommentPermission fromString(String? value) {
    switch (value) {
      case 'friends':
        return ReelCommentPermission.friends;
      case 'off':
        return ReelCommentPermission.off;
      default:
        return ReelCommentPermission.everyone;
    }
  }
}

/// Reel status
enum ReelStatus {
  draft,
  scheduled,
  processing,
  published,
  removed;

  String get value => name;

  static ReelStatus fromString(String? value) {
    switch (value) {
      case 'draft':
        return ReelStatus.draft;
      case 'scheduled':
        return ReelStatus.scheduled;
      case 'processing':
        return ReelStatus.processing;
      case 'removed':
        return ReelStatus.removed;
      default:
        return ReelStatus.published;
    }
  }
}

/// Remix types
enum ReelRemixType {
  duet,
  stitch,
  greenScreen;

  String get value {
    switch (this) {
      case ReelRemixType.duet:
        return 'duet';
      case ReelRemixType.stitch:
        return 'stitch';
      case ReelRemixType.greenScreen:
        return 'greenScreen';
    }
  }

  static ReelRemixType? fromString(String? value) {
    switch (value) {
      case 'duet':
        return ReelRemixType.duet;
      case 'stitch':
        return ReelRemixType.stitch;
      case 'greenScreen':
        return ReelRemixType.greenScreen;
      default:
        return null;
    }
  }
}

/// Reaction types for reels and comments
enum ReelReactionType {
  like,
  love,
  haha,
  wow,
  sad,
  angry;

  String get value => name;
  String get emoji {
    switch (this) {
      case ReelReactionType.like:
        return '👍';
      case ReelReactionType.love:
        return '❤️';
      case ReelReactionType.haha:
        return '😂';
      case ReelReactionType.wow:
        return '😮';
      case ReelReactionType.sad:
        return '😢';
      case ReelReactionType.angry:
        return '😡';
    }
  }

  static ReelReactionType fromString(String? value) {
    switch (value) {
      case 'love':
        return ReelReactionType.love;
      case 'haha':
        return ReelReactionType.haha;
      case 'wow':
        return ReelReactionType.wow;
      case 'sad':
        return ReelReactionType.sad;
      case 'angry':
        return ReelReactionType.angry;
      default:
        return ReelReactionType.like;
    }
  }
}

/// Comment sort options
enum CommentSortOption {
  top,
  newest;

  String get value => name;
}

/// Player state for the video player
enum ReelPlayerState {
  idle,
  loading,
  ready,
  playing,
  paused,
  error,
  disposed,
}
