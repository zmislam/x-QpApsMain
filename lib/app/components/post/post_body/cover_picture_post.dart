part of 'post_body.dart';

class CoverPicturePost extends StatelessWidget {
  const CoverPicturePost({
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
      child: PrimaryNetworkImage(
        imageUrl: (postModel.media?[0].media ?? '').formatedPostUrl,
      ),
    );
  }
}