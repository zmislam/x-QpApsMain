import 'package:flutter/material.dart';

import '../../../../components/simmar_loader.dart';
import '../../../../config/constants/app_assets.dart';

class StoryShimerLoader extends StatelessWidget {
  const StoryShimerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 150,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      ShimmerLoader(
                        child: Container(
                          height: 116.48,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.white, width: 0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          width: 80.64,
                        ),
                      ),
                      const Positioned(
                        left: 25,
                        top: 95,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromARGB(255, 45, 185, 185),
                          child: CircleAvatar(
                            radius: 13,
                            backgroundImage: AssetImage(
                              AppAssets.DEFAULT_STORY_IMAGE,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
