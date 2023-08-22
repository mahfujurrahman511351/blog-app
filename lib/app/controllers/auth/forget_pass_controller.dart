import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/helper_function.dart';
import '../../models/response_status.dart';
import '../../service/auth_service.dart';
import '../../views/auth/new password/new_password.dart';
import '../../views/auth/otp/forget otp/forget_pass_otp.dart';
import '../../views/auth/sign in/sign_in_view.dart';

class ForgetPassController extends GetxController {
  final _authService = AuthService();

  var sendingOtp = false.obs;
  var hidePassword = true.obs;
  var veryfyingOtp = false.obs;
  var checkingSubmit = false.obs;

  var email = '';
  var newPass = '';

  sendOtp() async {
    if (!sendingOtp.value) {
      sendingOtp.value = true;

      var body = jsonEncode({
        "email": email.trim(),
      });

      await _authService.checkResetPass(body: body).then((response) {
        if (response.error == null) {
          var responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

          bool success = responseStatus.success ?? false;

          if (success) {
            Get.to(() => const ForgetPassOtp());
          } else {
            showError(error: responseStatus.message ?? '');
          }

          sendingOtp.value = false;
        } else {
          showError(error: response.error ?? '');

          sendingOtp.value = false;
        }
      });
    }
  }

  varifyOtp() async {
    if (!veryfyingOtp.value) {
      veryfyingOtp.value = true;

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Get.to(() => const NewPasswordView());

        veryfyingOtp.value = false;
      });
    }
  }

  handleSubmit() async {
    if (!checkingSubmit.value) {
      checkingSubmit.value = true;

      var body = jsonEncode({
        "email": email.trim(),
        "newPass": newPass.trim(),
      });

      await _authService.resetPass(body: body).then((response) {
        if (response.error == null) {
          var responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
          bool success = responseStatus.success ?? false;

          if (success) {
            Get.snackbar(
              "Success",
              responseStatus.message ?? "",
              colorText: Colors.white,
              backgroundColor: Colors.black54,
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.offAll(() => const SignInView());
          } else {
            showError(error: responseStatus.message ?? "");
          }

          checkingSubmit.value = false;
        } else {
          showError(error: response.error ?? "");

          checkingSubmit.value = false;
        }
      });
    }
  }
}
