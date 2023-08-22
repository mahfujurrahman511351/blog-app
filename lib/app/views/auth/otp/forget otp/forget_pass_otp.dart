// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_import

import 'dart:convert';

import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/controllers/auth/forget_pass_controller.dart';
import 'package:blog/app/service/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../dashboard/dashboard/dashboard_view.dart';
import '../../new password/new_password.dart';

class ForgetPassOtp extends StatefulWidget {
  const ForgetPassOtp({super.key});

  @override
  State<ForgetPassOtp> createState() => _ForgetPassOtpState();
}

class _ForgetPassOtpState extends State<ForgetPassOtp> {
  final _otpController = TextEditingController();

  final _otpKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _otpKey,
            child: ListView(
              children: [
                SizedBox(height: 60.w),
                _logo(),
                SizedBox(height: 12.w),
                _title(),
                SizedBox(height: 15.w),
                _otpField(),
                SizedBox(height: 8.w),
                _varifyButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _varifyButton() {
    final controller = Get.find<ForgetPassController>();
    return MaterialButton(
      color: kBaseColor,
      onPressed: () {
        if (_otpKey.currentState!.validate()) {
          controller.varifyOtp();
        }
      },
      child: Obx(() {
        return controller.veryfyingOtp.value
            ? SizedBox(
                height: 30.w,
                width: 30.w,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: const [Color(0xFFffffff)],
                  strokeWidth: 6.w,
                ),
              )
            : Text(
                "Varify",
                style: TextStyle(fontSize: 15.w, color: Colors.white),
              );
      }),
    );
  }

  Widget _otpField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "6 Digit OTP",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2.w),
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _otpController,
      validator: MultiValidator([
        RequiredValidator(errorText: "Otp is required"),
      ]),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "OTP",
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(
              height: 6.w,
            ),
            Text("Enter the 6 digit otp code sent to your email")
          ],
        ),
      ],
    );
  }

  Widget _logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 60.w),
      ],
    );
  }
}
