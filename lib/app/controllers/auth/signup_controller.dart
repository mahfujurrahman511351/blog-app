import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/auth/user.dart';
import '../../service/auth_service.dart';
import '../../views/auth/otp/sign up otp/sign_up_otp.dart';
import '../../views/dashboard/dashboard/dashboard_view.dart';

class SignupController extends GetxController {
  final _authService = AuthService();
  final _storage = GetStorage();
  final _secureStorage = FlutterSecureStorage();

  var checkingSubmit = false.obs;

  var hidePassword = true.obs;
  var checkingSignUp = false.obs;
  var checkingSendOtp = false.obs;

  String name = '';
  String email = '';
  String password = '';

  handleSendOtp() {
    if (!checkingSendOtp.value) {
      checkingSendOtp.value = true;

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Get.to(() => const SignUpOtp());

        checkingSendOtp.value = false;
      });
    }
  }

  handleSubmit() async {
    if (!checkingSubmit.value) {
      checkingSubmit.value = true;
      var body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      });

      await _authService.signUp(body: body).then((response) async {
        if (response.error == null) {
          User user = response.data != null ? response.data as User : User();
          await _storage.write(IS_LOGGED_IN, true);
          await _storage.write(USER_NAME, user.name);
          await _storage.write(USER_ID, user.id);
          await _storage.write(USER_EMAIL, user.email);

          await _secureStorage.write(key: AUTH_TOKEN, value: user.token);

          Get.offAll(() => const DashboardView());
        } else {
          showError(error: response.error ?? "");
        }

        checkingSubmit.value = false;
      });
    }
  }
}
