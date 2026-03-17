import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/color.dart';
import '../../../../services/versionCheckerService.dart';
import '../../../../utils/Localization/languageSelection.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionCheckerService().checkAppVersion();
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xff121212) : Colors.white;
    final cardColor = isDark ? const Color(0xff1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xff1A1A2E);
    final textSecondary = isDark ? Colors.grey[400]! : const Color(0xff6B7280);
    final inputBg = isDark ? const Color(0xff2A2A2A) : const Color(0xffF3F4F6);
    final inputBorder =
        isDark ? const Color(0xff3A3A3A) : const Color(0xffE5E7EB);
    final dividerColor =
        isDark ? const Color(0xff333333) : const Color(0xffE5E7EB);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Top bar: Language selector ──
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [LanguageSelector()],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Logo ──
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: PRIMARY_COLOR.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          AppAssets.APP_LOGO,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Welcome text ──
                  Text(
                    'Welcome back'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      fontFamily: 'SfProDisplay',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue to your account'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: textSecondary,
                      fontFamily: 'SfProDisplay',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Email field ──
                  Text(
                    'Email'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      fontFamily: 'SfProDisplay',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.userIdController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 15,
                      color: textPrimary,
                      fontFamily: 'SfProDisplay',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your email'.tr,
                      hintStyle: TextStyle(
                        color: textSecondary.withOpacity(0.6),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: textSecondary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: inputBg,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: inputBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: PRIMARY_COLOR, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: ACCENT_COLOR, width: 1),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required'.tr;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── Password field ──
                  Text(
                    'Password'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      fontFamily: 'SfProDisplay',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscureText.value,
                      style: TextStyle(
                        fontSize: 15,
                        color: textPrimary,
                        fontFamily: 'SfProDisplay',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your password'.tr,
                        hintStyle: TextStyle(
                          color: textSecondary.withOpacity(0.6),
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: textSecondary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.obscureText.value =
                                !controller.obscureText.value;
                          },
                          icon: Icon(
                            controller.obscureText.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: textSecondary,
                            size: 20,
                          ),
                        ),
                        filled: true,
                        fillColor: inputBg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: inputBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: PRIMARY_COLOR, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: ACCENT_COLOR, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Remember me + Forgot password row ──
                  Row(
                    children: [
                      // Remember me toggle
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.rememberMe.value =
                                !controller.rememberMe.value;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: (v) {
                                    controller.rememberMe.value = v ?? true;
                                  },
                                  activeColor: PRIMARY_COLOR,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: textSecondary.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me'.tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondary,
                                  fontFamily: 'SfProDisplay',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Forgot password
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.FORGET_PASS),
                        child: Text(
                          'Forgot password?'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: PRIMARY_COLOR,
                            fontFamily: 'SfProDisplay',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Sign in button ──
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.onPressedLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SfProDisplay',
                        ),
                      ),
                      child: Text('Sign in'.tr),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Divider with "or" ──
                  Row(
                    children: [
                      Expanded(child: Divider(color: dividerColor, height: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondary,
                            fontFamily: 'SfProDisplay',
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: dividerColor, height: 1)),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Create account button ──
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Get.toNamed(Routes.SIGNUP),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PRIMARY_COLOR,
                        side: const BorderSide(
                            color: PRIMARY_COLOR, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SfProDisplay',
                        ),
                      ),
                      child: Text('Create new account'.tr),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Footer tagline ──
                  Center(
                    child: Text(
                      'The first decentralised & centralised\nSocial Network in the world'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary.withOpacity(0.6),
                        fontFamily: 'SfProDisplay',
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
