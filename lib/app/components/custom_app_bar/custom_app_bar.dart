import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions ;
  final String? title;
  const CustomAppBar({Key? key, this.actions, this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  AppBarTitle(title: title,),
      leading: const BackButtonWidget(),
      actions: actions
      // const [
      //   CreateTicketButton(),
      //   FilterButtonWidget(),
      // ],
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String? title;
  const AppBarTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Text(
      title ?? 'QP',
      style:Theme.of(context).appBarTheme.titleTextStyle
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onTap: () => Get.back(),
        child:  Icon(Icons.arrow_back_sharp, color: Theme.of(context).appBarTheme.foregroundColor),
      ),
    );
  }
}