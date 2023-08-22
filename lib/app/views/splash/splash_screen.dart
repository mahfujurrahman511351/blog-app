// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_import

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/views/dashboard/admin_Dashboard/admin_dashboard.dart';
import 'package:blog/app/views/dashboard/dashboard/dashboard_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/sign in/sign_in_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      bool isLoggedIn = GetStorage().read(IS_LOGGED_IN) ?? false;

      if (isLoggedIn) {
        Get.offAll(() => DashboardView());
      } else {
        Get.offAll(() => SignInView());
      }
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
