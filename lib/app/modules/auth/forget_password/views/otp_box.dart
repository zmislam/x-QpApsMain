import '../controllers/forget_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PasswordOtpBox extends GetView<ForgetPasswordController> {
  final String digitNo;

  const PasswordOtpBox(this.digitNo, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (value) {
                digitNo == '1'
                    ? controller.digit1.value = value.toString()
                    : digitNo == '2'
                        ? controller.digit2.value = value.toString()
                        : digitNo == '3'
                            ? controller.digit3.value = value.toString()
                            : digitNo == '4'
                                ? controller.digit4.value = value.toString()
                                : controller.digit5.value = value.toString();
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
