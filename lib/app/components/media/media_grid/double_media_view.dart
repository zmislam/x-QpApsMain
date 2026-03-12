part of 'media_grid.dart';

class DoubleMediaView extends StatelessWidget {
  const DoubleMediaView({
    super.key,
    required this.mediaUrls,
    required this.onTap,
  });

  final List<String> mediaUrls;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(0), 
            child: SizedBox(
              height: 500,
              child: ContentView(
                url: mediaUrls.first,
                imageHeight: 500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(1), 
            child: SizedBox(
              height: 500,
              child: ContentView(
                url: mediaUrls.last,
                imageHeight: 500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
