// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_import

import 'dart:convert';

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/service/auth_service.dart';
import 'package:blog/app/views/dashboard/dashboard/dashboard_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../controllers/auth/forget_pass_controller.dart';
import '../../../controllers/auth/signin_controller.dart';
import '../../../controllers/auth/signup_controller.dart';
import '../../../models/auth/user.dart';
import '../forget Pass/forget_pass.dart';
import '../sign up/sign_up_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  //controllers
  final _signupController = Get.put(SignupController());
  final _signinController = Get.put(SigninController());
  final _forgetPassController = Get.put(ForgetPassController());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signInKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
            key: _signInKey,
            child: ListView(
              children: [
                SizedBox(height: 60.w),
                _signinLogo(),
                SizedBox(height: 12.w),
                _signinTitle(),
                SizedBox(height: 15.w),
                _emailField(),
                SizedBox(height: 15.w),
                _passwordField(),
                SizedBox(height: 15.w),
                _signinButton(),
                SizedBox(height: 15.w),
                _createForgetRow()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createForgetRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SignUpView());
          },
          child: Text("Create Account"),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => ForgetPassword());
          },
          child: Text("Forget Password"),
        )
      ],
    );
  }

  Widget _signinButton() {
    final controller = Get.find<SigninController>();
    return MaterialButton(
      color: kBaseColor,
      onPressed: () {
        if (_signInKey.currentState!.validate()) {
          controller.handleSignin();
        }
      },
      child: Obx(() {
        return controller.checkingSignin.value
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
                "Sign In",
                style: TextStyle(fontSize: 15.w, color: Colors.white),
              );
      }),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      final controller = Get.find<SigninController>();

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
          controller.password = value;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: "Password is required"),
          MinLengthValidator(6, errorText: 'Password must be at least 6 character'),
        ]),
      );
    });
  }

  Widget _emailField() {
    final controller = Get.find<SigninController>();

    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2.w),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: kBaseColor,
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _emailController,
      onChanged: (value) {
        controller.email = value;
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Email is required"),
        EmailValidator(errorText: "Enter a valid Email"),
      ]),
    );
  }

  Widget _signinTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign In",
          style: TextStyle(fontSize: 20.sp),
        ),
      ],
    );
  }

  Widget _signinLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 60.w),
      ],
    );
  }
}
