
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/custom_app_bar/custom_app_bar.dart';
import '../../../../../../components/search_bar/custom_search_bar_widget.dart';
import '../controllers/help_support_controller.dart';
import '../widgets/support_view_widgets/filter_button.dart';
import '../widgets/support_view_widgets/create_ticket_button.dart';
import '../widgets/support_view_widgets/help_list_widgets.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  CustomAppBar(
        title: 'Help Center'.tr,
        actions: [
          const CreateTicketButton(),
          FilterButtonWidget(controller: controller,),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          CustomSearchBarWidget(onChanged:    (value) {
            controller.filterSearch.value = value;
            controller.getHelpSupportList();
          },),
          const SizedBox(height: 15),
          const Expanded(child: HelpListWidget()),
        ],
      ),
    );
  }
}










