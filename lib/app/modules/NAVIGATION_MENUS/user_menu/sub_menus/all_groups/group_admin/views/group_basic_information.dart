import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/text_form_field.dart';
import '../controllers/group_settings_controller.dart';
import '../../../../../../../config/constants/color.dart';

class GroupBasicInformationView extends GetView<GroupSettingsController> {
  const GroupBasicInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    // AdminPageController adminPageController = Get.find();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(' Group Setting'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body:
      // Text('Group Basic Info'.tr)
       Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text('Group Basic information'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(' Group Name'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.groupNameController,
                   
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                ),
              
               
                const SizedBox(height: 20),
                Text('Group Description'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.descriptionController,
                    
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('City'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                     controller: controller.locationController,
                  decoration: InputDecoration(
                    hintText: 'City'.tr,
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                ),
               
             
        
                const SizedBox(
                  height: 20,
                ),
             
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: controller.isSaveButtonEnabled.value ==
                            false
                        ? () {
                            if (controller.formKey.currentState
                                    ?.validate() ??
                                false) {
                              controller.editGroupInfo();
                            }
                            // adminPageController.editPage(adminPageController
                            //         .pageProfileModel.value?.pageDetails?.id ??
                            //     '');
                          }
                        : null,
                    child: Text('Save Changes'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
   
    );
  }
}
