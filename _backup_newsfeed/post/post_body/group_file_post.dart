part of 'post_body.dart';

class GroupFilePost extends StatelessWidget {
  const GroupFilePost({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    List<String> docFilesList = [];

    for (var i = 0; i < (postModel.media?.length ?? 0); i++) {
      docFilesList.add((postModel.media?[i].media ?? ''));
    }

    return GestureDetector(
      onTap: () {
        debugPrint('Download Your File');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: ExpandableText(
              postModel.description ?? '',
              expandText: 'See more',
              maxLines: 10,
              collapseText: 'See less',
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < docFilesList.length; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  border: Border.all(style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Image.asset(
                    getFileIconAsset(postModel.media?[i].media),
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DownloadableTextDoc(
                      docFileName: docFilesList[i],
                      fileUrl: (docFilesList[i]).formatedPostUrl,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
