import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/create_post_controller.dart';

class GifPage extends GetView<CreatePostController> {
  const GifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Select GIF'.tr,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search GIF'.tr,
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none),
              //controller: textEditingController,
              //focusNode: focusNode,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 1,
                //childAspectRatio: 900 / (200 * 1.05)
              ),
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://i0.wp.com/www.galvanizeaction.org/wp-content/uploads/2022/06/Wow-gif.gif?fit=450%2C250&ssl=1'
                                // "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                                ))));
                // child: NetworkCircleAvatar(
                //     imageUrl:
                //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"));
              },
            ),
          )
        ],
      ),
    );
  }
}
