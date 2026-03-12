import '../../config/constants/api_constant.dart';
import '../../models/chat/chat_model.dart';
import '../../models/chat/participant_model.dart';
import '../../models/chat/required_chat_info.dart';
import '../../models/chat/required_info.dart';

RequiredInfo getRequiredInfoFromChat(
    ChatModel chatModel, String currentUserId) {
  String userName = '';
  String profilePicture = '';
  if ((chatModel.isGroupChat == true) && (chatModel.page_id == null)) {
    userName = chatModel.name ?? '';
    profilePicture =
        '${ApiConstant.SERVER_IP_PORT}/uploads/group/${chatModel.cover_image ?? ''}';
  } else if ((chatModel.isGroupChat == true) && (chatModel.page_id != null)) {
    userName = chatModel.name ?? '';
    profilePicture =
        '${ApiConstant.SERVER_IP_PORT}/uploads/page/${chatModel.pageInfo?.profile_pic ?? ''}';
  } else {
    for (ParticipantModel participantModel in chatModel.participants ?? []) {
      if (participantModel.id != currentUserId) {
        userName =
            '${participantModel.first_name ?? ''} ${participantModel.last_name ?? ''}';
        profilePicture =
            '${ApiConstant.SERVER_IP_PORT}/uploads/${participantModel.profile_pic ?? ''}';
      }
    }
  }

  return RequiredInfo(
    isGroupChat: chatModel.isGroupChat ?? false,
    username: userName,
    profilePicture: profilePicture,
  );
}

RequiredChatInfo getRequiredChatInfoFromChat(
    ChatModel chatModel, String currentUserId) {
  String userName = '';
  String profilePicture = '';
  if ((chatModel.isGroupChat ?? false) == false) {
    for (ParticipantModel participantModel in chatModel.participants ?? []) {
      if (participantModel.id != currentUserId) {
        userName =
            '${participantModel.first_name ?? ''} ${participantModel.last_name ?? ''}';
        profilePicture = participantModel.profile_pic ?? '';
      }
    }
  } else {
    userName = chatModel.name ?? '';
  }

  return RequiredChatInfo(
    username: userName,
    profilePicture: '${ApiConstant.SERVER_IP_PORT}/uploads/$profilePicture',
    undreadCount: chatModel.newMessageCount ?? 0,
  );
}
