import 'package:flutter/cupertino.dart';

class ReactionStack extends StatelessWidget {
  final String profileImageLink;
  final String reactionImageLink;

  const ReactionStack(
      {super.key,
      required this.profileImageLink,
      required this.reactionImageLink});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(profileImageLink),
              ),
            ),
          ),
          Positioned(
            left: 40,
            top: 30,
            child: Image.asset(
              reactionImageLink,
              height: 27,
              width: 27,
            ),
          )
        ],
      ),
    );
  }
}
