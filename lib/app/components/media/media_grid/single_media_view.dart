part of 'media_grid.dart';

class SingleMediaView extends StatelessWidget {
  const SingleMediaView({
    super.key,
    required this.mediaUrls,
    required this.onTap,
  });

  final List<String> mediaUrls;
  final Function(int index) onTap; // Callback to handle tap events

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(0), // Pass index 0 since it's a single media item
      child: SizedBox(
        height: 250,
        child: ContentView(
          url: mediaUrls.first,
          imageHeight: 250,
        ),
      ),
    );
  }
}
