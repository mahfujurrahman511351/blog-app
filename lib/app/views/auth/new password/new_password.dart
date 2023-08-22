// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_import, unused_local_variable, unnecessary_null_comparison, unused_element

import 'dart:convert';

import 'package:blog/app/controllers/auth/forget_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../constants/helper_function.dart';
import '../../../models/response_status.dart';
import '../../../service/auth_service.dart';
import '../../dashboard/dashboard/dashboard_view.dart';
import '../sign in/sign_in_view.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final _passwordController = TextEditingController();

  final _passwordKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _passwordKey,
            child: ListView(
              children: [
                SizedBox(height: 60.w),
                _logo(),
                SizedBox(height: 12.w),
                _title(),
                SizedBox(height: 15.w),
                _passwordField(),
                SizedBox(height: 8.w),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    final controller = Get.find<ForgetPassController>();

    return MaterialButton(
      color: kBaseColor,
      onPressed: () {
        if (_passwordKey.currentState!.validate()) {
          controller.handleSubmit();
        }
      },
      child: Obx(() {
        return controller.checkingSubmit.value
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
                "submit",
                style: TextStyle(fontSize: 15.w, color: Colors.white),
              );
      }),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      final controller = Get.find<ForgetPassController>();

      return TextFormField(
        obscureText: controller.hidePassword.value,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(color: kBaseColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kBaseColor, width: 2.w),
          ),
          prefixIcon: Icon(Icons.lock, color: kBaseColor),
          suffixIcon: IconButton(
            onPressed: () {
              controller.hidePassword.value = !controller.hidePassword.value;
            },
            icon: controller.hidePassword.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          ),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
        ),
        controller: _passwordController,
        onChanged: (value) {
          Get.find<ForgetPassController>().newPass = value;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: "Password is required"),
          MinLengthValidator(6, errorText: 'Password must be at least 6 character'),
        ]),
      );
    });
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "New Password",
              style: TextStyle(fontSize: 20.sp),
            ),
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
