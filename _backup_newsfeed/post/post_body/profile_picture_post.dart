part of 'post_body.dart';

class ProfilePicturePost extends StatelessWidget {
  const ProfilePicturePost({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SingleImage(
            imgURL: (postModel.media?[0].media ?? '').formatedPostUrl));
      },
      child: NetworkCircleAvatar(
        radius: 128,
        imageUrl: (postModel.media?[0].media ?? '').formatedPostUrl,
      ),
    );
  }
}
