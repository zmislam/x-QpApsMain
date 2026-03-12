part of 'media_grid.dart';

class MoreMediaView extends StatelessWidget {
  const MoreMediaView({
    super.key,
    required this.mediaUrls,
    required this.onTap,
  });

  final List<String> mediaUrls;
  final Function(int index) onTap; // Callback to handle tap events

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(0), // Pass index 0
                    child: ContentView(
                      url: mediaUrls[0],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(2), // Pass index 2
                    child: ContentView(
                      url: mediaUrls[2],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(1), // Pass index 1
                    child: ContentView(
                      url: mediaUrls[1],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => onTap(3), // Pass index 3
                          child: ContentView(
                            url: mediaUrls[3],
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        width: Get.width / 2,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3)),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              onTap(
                                  3); // Handle taps for the overlay (optional)
                            },
                            child: Text('${(mediaUrls.length - 4)}+'.tr,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
