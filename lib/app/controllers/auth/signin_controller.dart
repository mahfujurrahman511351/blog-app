// ignore_for_file: unused_field, prefer_const_constructors

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/auth/user.dart';
import '../../service/auth_service.dart';
import '../../views/dashboard/dashboard/dashboard_view.dart';

class SigninController extends GetxController {
  final _authService = AuthService();
  final _storage = GetStorage();
  final _secureStorage = FlutterSecureStorage();

  var hidePassword = true.obs;
  var checkingSignin = false.obs;

  String email = '';
  String password = '';

  handleSignin() async {
    if (!checkingSignin.value) {
      checkingSignin.value = true;

      var body = jsonEncode({
        "email": email.trim(),
        "password": password.trim(),
      });

      await _authService.login(body: body).then((response) async {
        if (response.error == null) {
          User user = response.data != null ? response.data as User : User();
          _storage.write(IS_LOGGED_IN, true);
          _storage.write(USER_NAME, user.name);
          _storage.write(USER_ID, user.id);
          _storage.write(USER_EMAIL, user.email);
          _storage.write(USER_AVATAR, user.avatar);
          await _secureStorage.write(key: AUTH_TOKEN, value: user.token);

          Get.offAll(() => DashboardView());
        } else {
          showError(error: response.error ?? "");
        }

        checkingSignin.value = false;
      });
    }
  }
}
