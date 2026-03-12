import '../../enum/live_post_type_enum.dart';

class UserLiveStreamModel {
  String? description;
  String? privacy;
  int? cameraIndex;
  LivePostTypeEnum livePostTypeEnum;

  UserLiveStreamModel({this.description, this.privacy, this.cameraIndex, required this.livePostTypeEnum});
}
