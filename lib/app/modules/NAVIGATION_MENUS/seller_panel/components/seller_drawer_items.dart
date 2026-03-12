import 'package:get/get.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../utils/custom_drawer.dart';
import '../views/seller_order_view.dart';
import '../views/seller_panel_dashboard_view.dart';
import '../views/seller_payment_view.dart';
import '../views/seller_product_view.dart';

// Predefined Drawer Items
List<DrawerItem> sellerDrawerItems = [
  DrawerItem(
    iconPath: AppAssets.DASHBOARD_ICON,
    title: 'Dashboard'.tr,
    onTap: () {
      Get.back();
      Get.to(() => const SellerPanelDashboardView());
    },
  ),
  DrawerItem(
    iconPath: AppAssets.ORDER_ICON,
    title: 'Order'.tr,
    onTap: () {
      Get.to(() => const SellerOrderView());
    },
  ),
  DrawerItem(
    iconPath: AppAssets.PRODUCT_ICON,
    title: 'Product'.tr,
    onTap: () {
      Get.to(() => const SellerProductView());
    },
  ),
  DrawerItem(
    iconPath: AppAssets.PAYMENT_ICON,
    title: 'Payment'.tr,
    onTap: () {
      Get.to(() => const SellerPaymentView());
    },
  ),
  // DrawerItem(
  //   iconPath: AppAssets.STORE_ICON,
  //   title: 'Store'.tr,
  //   onTap: () {
  //     Get.to(() => StoreView());
  //   },
  // ),
  // DrawerItem(
  //   iconPath: AppAssets.CATEGORY_ICON,
  //   title: 'Category'.tr,
  //   onTap: () {
  //     Get.to(() => CategoryView());
  //   },
  // ),
  // DrawerItem(
  //   iconPath: AppAssets.SETTINGS_ICON,
  //   title: 'Settings'.tr,
  //   onTap: () {
  //     Get.to(() => SellerSettingsView());
  //   },
  // ),
];
