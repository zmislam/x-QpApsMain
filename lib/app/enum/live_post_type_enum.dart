enum LivePostTypeEnum{
  ON_TIMELINE,
  ON_REELS,
  ON_BOTH
}


final Map<LivePostTypeEnum, String> LivePostTypeEnumValueMap = {
  LivePostTypeEnum.ON_TIMELINE: 'posts',
  LivePostTypeEnum.ON_REELS: 'reels',
  LivePostTypeEnum.ON_BOTH: 'both',
};