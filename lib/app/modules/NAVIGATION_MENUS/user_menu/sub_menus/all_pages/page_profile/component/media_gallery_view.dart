import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../admin_page/model/admin_media_model.dart';
import '../../../../../../../config/constants/color.dart';
import '../../admin_page/model/media_photo_model.dart';
import '../../pages/model/report_model.dart';
import '../controllers/page_profile_controller.dart';

class PageMediaGalleryView extends StatelessWidget {
  const PageMediaGalleryView({
    super.key,
    required this.controller,
    required this.pageMediaModel,
  });
  final PageProfileController controller;
  final PageMediaModel pageMediaModel;

  @override
  Widget build(BuildContext context) {
    TextEditingController reportDescription = TextEditingController();
    controller.getMediaPhotos(pageMediaModel.id ?? '');
    // MediaAlbumsModel? mediaAlbumsModel;
    return RefreshIndicator(
      onRefresh: () async {
        controller.getMediaPhotos(pageMediaModel.id ?? '');
      },
      child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            // backgroundColor: Colors.white,
            leading: const BackButton(
              color: Colors.black,
            ),
            title: Text(
              textAlign: TextAlign.center,
              pageMediaModel.title ?? '',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Obx(
                  () => Expanded(
                    child: controller.isLoadingMediaPhoto.value == true
                        ? ShimmarLoadingView()
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 0.8),
                            itemCount: controller.pageMediaList.value.length,
                            itemBuilder: (context, index) {
                              PageMediaPhotosModel pageMediaPhotosModel =
                                  controller.pageMediaList.value[index];

                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(SingleImage(
                                        imgURL:
                                            ('${pageMediaPhotosModel.media}')
                                                .formatedPostUrl,
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: FadeInImage(
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return const Image(
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              AppAssets.DEFAULT_IMAGE,
                                            ),
                                          );
                                        },
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            ('${pageMediaPhotosModel.media}')
                                                .formatedPostUrl),
                                        placeholder: const AssetImage(
                                            'assets/image/default_image.png'),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Image(
                                          height: 22,
                                          width: 22,
                                          image: AssetImage(AppAssets.MORE)),
                                      onPressed: () {
                                        Get.bottomSheet(InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.bottomSheet(
                                              SizedBox(
                                                height: Get.height / 1.8,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Text('Report'.tr,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    Obx(
                                                      () => Expanded(
                                                        child: ListView.builder(
                                                          itemCount: controller
                                                              .pageReportList
                                                              .value
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            PageReportModel
                                                                pageReportModel =
                                                                controller
                                                                    .pageReportList
                                                                    .value[index];
                                                            return ListView(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const ScrollPhysics(),
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                      pageReportModel
                                                                              .reportType ??
                                                                          ''),
                                                                  subtitle: Text(
                                                                      pageReportModel
                                                                              .description ??
                                                                          ''),
                                                                  leading: Obx(() => Radio<
                                                                          String>(
                                                                      value:
                                                                          pageReportModel.reportType ??
                                                                              '',
                                                                      groupValue: controller
                                                                          .selectedReportType
                                                                          .value,
                                                                      toggleable:
                                                                          true,
                                                                      onChanged:
                                                                          (String?
                                                                              value) {
                                                                        if (value !=
                                                                            null) {
                                                                          controller
                                                                              .selectedReportType
                                                                              .value = value;
                                                                          controller
                                                                              .selectedReportId
                                                                              .value = pageReportModel.id!;
                                                                        }
                                                                      },
                                                                      activeColor:
                                                                          PRIMARY_COLOR)),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            width:
                                                                Get.width / 2,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: 1)),
                                                            child: Text('Cancel'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();

                                                            Get.bottomSheet(
                                                              SizedBox(
                                                                height:
                                                                    Get.height /
                                                                        1.8,
                                                                width:
                                                                    Get.width,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          Text('Report'.tr,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      height: 1,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child:
                                                                              Text('Description'.tr,
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              Get.height / 2.9,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8),
                                                                          margin: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 10),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.grey.shade300, width: 1), //Colors.grey.withValues(alpha:0.1),width: 1),
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              TextField(
                                                                            controller:
                                                                                reportDescription,
                                                                            maxLines:
                                                                                8,
                                                                            decoration:
                                                                            InputDecoration(
                                                                              border: InputBorder.none,
                                                                              hintText: 'Enter a description about your Report...'.tr,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Get.back();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                Get.width / 2,
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 1)),
                                                                            child:
                                                                                Text('Back'.tr,
                                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            controller.reportAPost(
                                                                                report_type_id: controller.selectedReportId.value,
                                                                                page_id: controller.pageProfileModel.value?.pageDetails?.id ?? '',
                                                                                report_type: controller.selectedReportType.value,
                                                                                description: reportDescription.text);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                Get.width / 2,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.grey, width: 1),
                                                                                color: PRIMARY_COLOR
                                                                                //.withValues(alpha:0.7),
                                                                                ),
                                                                            child:
                                                                                Text('Report'.tr,
                                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              isScrollControlled:
                                                                  true,
                                                            );
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 0),
                                                              color:
                                                                  PRIMARY_COLOR,
                                                            ),
                                                            width:
                                                                Get.width / 2,
                                                            child: Text('Continue'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // backgroundColor: Colors.white,
                                              isScrollControlled: true,
                                            );
                                          },
                                          child: Container(
                                            height: 60,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.report_outlined,
                                                    size: 22,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('Report'.tr,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                  ),
                )
              ],
            ),
          ))),
    );
  }
}

Widget ShimmarLoadingView() {
  return SizedBox(
    height: Get.height,
    child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        }),
  );
}
