import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_drawer_title.dart';

import '../../config/constants/app_assets.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/add_qp_balance.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/bill_view.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/payment_setting.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/send_money_view.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/transaction_history.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/wallet_view.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/withdraw_money.dart';
import '../button.dart';

class WalletDrawerWidget extends StatelessWidget {
  const WalletDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12),
              Image(
                height: 35,
                width: 35,
                image: AssetImage(AppAssets.APP_LOGO),
              ),
              SizedBox(width: 8),
              Text('Quantum Possibilities'.tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )
            ],
          ),
          Divider(color: Colors.grey.withValues(alpha: 0.4)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ImageButton(
              text: 'Add QP balance'.tr,
              horizontalPadding: 30,
              verticalPadding: 50,
              onPressed: () {
                Get.to(() => const AddQpBalance());
              },
              imagePath: AppAssets.ADD_QP_ICON,
            ),
          ),
          const SizedBox(height: 20),
          WalletDrawerTitle(
            iconPath: AppAssets.WITHDRAW_DASHBOARD_ICON,
            title: 'Wallet DashBoard'.tr,
            onTap: () {
              Get.to(() => const WalletView());
            },
          ),
          const SizedBox(height: 20),
          WalletDrawerTitle(
            iconPath: AppAssets.SENDMONEY_DASHBOARD_ICON,
            title: 'Send Money'.tr,
            onTap: () {
              Get.to(() => SendMoneyView());
            },
          ),
          const SizedBox(height: 20),
          WalletDrawerTitle(
            iconPath: AppAssets.PAYMENTSETTING_DASHBOARD_ICON,
            title: 'Payment Settings'.tr,
            onTap: () {
              Get.to(() => const PaymentSetting());
            },
          ),
          const SizedBox(height: 20),
          WalletDrawerTitle(
            iconPath: AppAssets.BILLING_DASHBOARD_ICON,
            title: 'Billing'.tr,
            onTap: () {
              Get.to(() => const BillView());
            },
          ),
          const SizedBox(height: 20),
          WalletDrawerTitle(
            iconPath: AppAssets.WITHDRAWAL_DASHBOARD_ICON,
            title: 'Withdraw'.tr,
            onTap: () {
              Get.to(() => WithdrawMoney());
            },
          ),
          const SizedBox(height: 20),
          WalletDrawerTitle(
            iconPath: AppAssets.HISTORY_DASHBOARD_ICON,
            title: 'Transaction History'.tr,
            onTap: () {
              Get.to(() => const TransactionHistory());
            },
          ),
        ],
      ),
    );
  }
}
