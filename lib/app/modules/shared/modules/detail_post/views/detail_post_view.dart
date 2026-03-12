import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_post_controller.dart';

class DetailPostView extends GetView<DetailPostController> {
  const DetailPostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPostView'.tr),
        centerTitle: true,
      ),
      body:  Center(
        child: Text('DetailPostView is working'.tr,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
