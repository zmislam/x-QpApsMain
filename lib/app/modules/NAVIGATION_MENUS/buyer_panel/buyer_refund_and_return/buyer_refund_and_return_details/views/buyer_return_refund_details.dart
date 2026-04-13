import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../controllers/buyer_refund_detials_controller.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../config/constants/color.dart';

class ReturnRefundDetailsView
    extends GetView<BuyerReturnRefundDetailsController> {
  const ReturnRefundDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerRefundDetailsData();
    controller.getBuyerRefundChatData(controller.refundId ?? '');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
            onPressed: () {
              Get.offNamed(Routes.MARKETPLACE_BUYER_PANEL, arguments: {'tab': 3});
            },
          ),
          title: Text('Returns & Refund Details'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: PRIMARY_COLOR,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                indicator: const BoxDecoration(color: Colors.transparent),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text('Returns/Refund'.tr)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text('Chatting Details'.tr)),
                    ),
                  ),
                ],
              ),
            ),
            controller.refundDetailsData.value?.status == 'accepted'
                ? InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Get.back(),
                                  ),
                                ),
                                Text('View Return Details'.tr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    (controller
                                            .refundDetailsData.value?.qrCode ??
                                        '').formatedReturnQrUrlLive,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        AppAssets.DEFAULT_IMAGE,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ), // Replace with your QR code widget or image
                                const SizedBox(height: 20),
                                Text('Please attach this QR code securely to the outside of your return package. When you drop off your package with the courier, they will scan this code to track your return.'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await controller.saveQrCode();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: PRIMARY_COLOR,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text('Save This QR'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text('After booking your return Product Please enter your tracking number below to keep your return on record and receive updates'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  decoration: InputDecoration(
                                    // labelText: 'Courier service Name'.tr,
                                    hintText: 'FedEx'.tr,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  decoration: InputDecoration(
                                    // labelText: 'Tracking number'.tr,
                                    hintText: '783408090590'.tr,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Note'.tr,
                                    hintText: '783408090590'.tr,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: PRIMARY_COLOR,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text('Submit'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 20,
                            image: AssetImage(AppAssets.QR_ICON),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('View Return Details'.tr,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildReturnRefundRequest(context),
                  _buildChattingDetails(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnRefundRequest(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReturnDetails(context),
          const SizedBox(height: 10),
          _buildProductCards(context),
          const SizedBox(height: 10),
          _buildProductPhotos(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReturnDetails(BuildContext context) {
    return Obx(() {
      final refundData = controller.refundDetailsData.value;
      if (refundData == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardTheme.color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    (refundData.store?.imagePath ?? '').formatedStoreUrlLive,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        AppAssets.DEFAULT_IMAGE,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      refundData.store?.name?.capitalizeFirst ?? '',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      refundData.store?.categoryName?.capitalizeFirst ?? '',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Order Number: '.tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(" ${refundData.orderSubDetailsId ?? 'N/A'}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Status: '.tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(refundData.status?.capitalizeFirst ?? 'N/A',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Returns Total Item:    ${refundData.refundDetails?.length ?? 0}'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(' Items'.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProductCards(BuildContext context) {
    return Obx(() {
      final refundData = controller.refundDetailsData.value;
      if (refundData == null ||
          refundData.refundDetails == null ||
          refundData.refundDetails!.isEmpty) {
        return Center(child: Text('No products to display'.tr));
      }

      return Column(
        children: refundData.refundDetails!.map((productDetail) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        (
                            productDetail.product?.media?.first ?? '').formatedProductUrlLive,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            AppAssets.DEFAULT_IMAGE,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productDetail.product?.productName ?? 'N/A',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Unit Price: \$${productDetail.sellPrice?.toStringAsFixed(2) ?? 'N/A'}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Quantity: ${productDetail.refundQuantity ?? 'N/A'}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${productDetail.productVariant?.attributes?.map((attribute) {
                                  return "${attribute.value?.toUpperCase()}: ${attribute.name}";
                                }).join(', ') ?? 'N/A'}"
                            "${productDetail.productVariant?.color?.name != null ? ', Color: ${productDetail.productVariant?.color?.name}' : ''}\n",
                            style: TextStyle(color: Colors.grey),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Sub Total: \$${(productDetail.sellPrice ?? 0) * (productDetail.refundQuantity ?? 0)}'.tr,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Reason for Return: '.tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      productDetail.refundNote ?? 'N/A',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Description: '.tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildProductPhotos() {
    return Obx(() {
      final refundData = controller.refundDetailsData.value;
      if (refundData == null ||
          refundData.refundDetails == null ||
          refundData.refundDetails!.isEmpty) {
        return const SizedBox();
      }

      // Ensure productPhotos is a List<String> or handle it conditionally
      final List<String> productPhotos = refundData.images ?? [];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products Photo:'.tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: productPhotos.map((photo) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildPhotoCard(photo),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPhotoCard(String photoUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
        image: DecorationImage(
          image: NetworkImage((photoUrl).formatedProductOrderReFundUrlLive),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildChattingDetails(BuildContext context) {
    controller.getBuyerRefundChatData(controller.refundId ?? '');
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getBuyerRefundDetailsData();
        await controller.getBuyerRefundChatData(controller.refundId ?? '');
      },
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.chatMessages.length,
                itemBuilder: (context, index) {
                  final chatMessage = controller.chatMessages[index];
                  final isSentByMe = chatMessage?.sendBy != null;

                  return _buildChatBubble(
                    chatMessage?.message ?? 'No message',
                    isSentByMe: isSentByMe,
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    controller.pickImage();
                  },
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Write your message'.tr,
                      hintStyle:
                          Theme.of(context).inputDecorationTheme.hintStyle,
                      filled: true,
                      fillColor: Theme.of(context).cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.sendChatMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message, {required bool isSentByMe}) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.teal : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
