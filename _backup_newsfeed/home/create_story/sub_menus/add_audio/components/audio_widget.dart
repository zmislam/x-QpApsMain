// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/extension/num.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/create_story/sub_menus/add_audio/models/audio_model.dart';
import '../../../../../../../components/image.dart';

class AudioWidget extends StatelessWidget {
  const AudioWidget({
    Key? key,
    required this.audioModel,
    required this.onPressedFavorate,
  }) : super(key: key);

  final AudioModel audioModel;
  final void Function() onPressedFavorate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back(result: audioModel);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: PrimaryNetworkImage(
              imageUrl: (
                audioModel.thumbnail ?? ''
              ).formatedAudioThumbnailUrl,
            ),
          ),
          10.w,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(audioModel.title ?? ''),
                Text(audioModel.artist_name ?? ''),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onPressedFavorate,
                icon: Icon(
                  (audioModel.isFavorite ?? true)
                      ? Icons.favorite
                      : Icons.favorite_outline,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
