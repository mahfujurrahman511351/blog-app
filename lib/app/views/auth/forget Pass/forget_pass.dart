// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_import, unused_element

import 'dart:convert';

import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:blog/app/service/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../controllers/auth/forget_pass_controller.dart';
import '../../dashboard/dashboard/dashboard_view.dart';
import '../otp/forget otp/forget_pass_otp.dart';
import '../sign in/sign_in_view.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();

  final _forgetKey = GlobalKey<FormState>();

  bool hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _forgetKey,
            child: ListView(
              children: [
                SizedBox(height: 60.w),
                _logo(),
                SizedBox(height: 12.w),
                _otptitle(),
                SizedBox(height: 15.w),
                _emailField(),
                SizedBox(height: 8.w),
                _getOtp(),
                SizedBox(height: 8.w),
                _backTosignin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getOtp() {
    final controller = Get.find<ForgetPassController>();

    return MaterialButton(
        color: kBaseColor,
        onPressed: () {
          if (_forgetKey.currentState!.validate()) {
            controller.sendOtp();
          }
        },
        child: Obx(() {
          return controller.sendingOtp.value
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
                  "Get OTP",
                  style: TextStyle(fontSize: 15.w, color: Colors.white),
                );
        }));
  }

  Widget _emailField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: kBaseColor,
        ),
        labelText: "Email",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2.w),
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _emailController,
      onChanged: (value) {
        Get.find<ForgetPassController>().email = value;
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "email is required"),
        EmailValidator(errorText: "Enter a valid email"),
      ]),
    );
  }

  Widget _otptitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "Forget Password?",
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Don't worry.Just enter your email.We will send you a 6 digit OTP code.",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _backTosignin() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SignInView());
          },
          child: Text("Back to sign in"),
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
