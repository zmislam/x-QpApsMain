import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/snackbar.dart';
import '../providers/forgetpass_provider.dart';

class ForgetPasswordController extends GetxController {
  final count = 0.obs;

  var isLoading = false.obs;
  var email = ''.obs;

  var digit1 = ''.obs;
  var digit2 = ''.obs;
  var digit3 = ''.obs;
  var digit4 = ''.obs;
  var digit5 = ''.obs;

  var isProcessing = false.obs;

  var setPassProcessing = false.obs;

  var password = ''.obs;
  var confirmPass = ''.obs;

  RxString passwordError = ''.obs;
  RxString confirmPassError = ''.obs;

  final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
  );
  var isVisible = false.obs;

  var isVisible2 = false.obs;

  @override
  void onClose() {}
  void increment() => count.value++;

//=================== Request Forget Pssword to Send Otp=============================//
  Future<void> requestForgetPassword() async {
    isLoading.value = true;

    var sendOtpStatus = await ForgetpassProvider().sendOtp(email: email.value);

    if (sendOtpStatus == true) {
      isLoading.value = false;
      Get.toNamed(Routes.FORGET_PASS_OTP);
    } else {
      isLoading.value = false;
      showErrorSnackkbar(message: 'Could not Send Otp');
    }
  }

//=================== Check Otp Verification to Verify Otp=============================//

  Future<void> checkOtpVerification() async {
    isLoading.value = true;

    var otpVerificationStatus = await ForgetpassProvider().verifyOtp(
      email: email.value,
      number1: digit1.value,
      number2: digit2.value,
      number3: digit3.value,
      number4: digit4.value,
    );

    if (otpVerificationStatus == true) {
      isProcessing.value = false;
      Get.toNamed(Routes.FORGET_PASS_SET);
    } else {
      isProcessing.value = false;
      showErrorSnackkbar(message: 'Error !!! Provide correct otp ...');
    }
  }

//=================== Set New Password to Reset Password=============================//

  Future<void> setNewPassword() async {
    setPassProcessing.value = true;

    var otpVerificationStatus = await ForgetpassProvider().resetPassword(
        email: email.value,
        password: password.value,
        newPassword: confirmPass.value);

    if (otpVerificationStatus == true) {
      setPassProcessing.value = false;
      showSuccessSnackkbar(message: 'Your password has been changed...');

      Get.offNamed(Routes.LOGIN);
    } else {
      setPassProcessing.value = false;
      showErrorSnackkbar(message: 'Error !!! Password not changed...');
    }
  }
  void validatePassword() {
    final value = password.value.trim();

    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      passwordError.value = 'Must include an uppercase letter';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      passwordError.value = 'Must include a lowercase letter';
    } else if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      passwordError.value = 'Must include a special character';
    } else {
      passwordError.value = '';
    }

    validateConfirmPassword(); // also recheck confirm field
  }
  void validateConfirmPassword() {
    if (confirmPass.value.isEmpty) {
      confirmPassError.value = '';
      return;
    }

    if (confirmPass.value != password.value) {
      confirmPassError.value = 'Passwords do not match';
    } else {
      confirmPassError.value = '';
    }
  }
}
