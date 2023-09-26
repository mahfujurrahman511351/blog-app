// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_import

import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/controllers/auth/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../forget Pass/forget_pass.dart';
import '../otp/sign up otp/sign_up_otp.dart';
import '../sign in/sign_in_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signUpKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
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
            key: _signUpKey,
            child: ListView(
              children: [
                SizedBox(height: 60.w),
                _signUpLogo(),
                SizedBox(height: 12.w),
                _signUpTitle(),
                SizedBox(height: 15.w),
                _nameField(),
                SizedBox(height: 15.w),
                _emailField(),
                SizedBox(height: 15.w),
                _passwordField(),
                SizedBox(height: 15.w),
                _nextButton(),
                SizedBox(height: 5.w),
                _backTosignin()
              ],
            ),
          ),
        ),
      ),
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

  Widget _nextButton() {
    final controller = Get.find<SignupController>();
    return MaterialButton(
      color: kBaseColor,
      onPressed: () {
        if (_signUpKey.currentState!.validate()) {
          controller.handleSendOtp();
        }
      },
      child: Obx(() {
        return controller.checkingSendOtp.value
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
                "Next",
                style: TextStyle(fontSize: 15.w, color: Colors.white),
              );
      }),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      final controller = Get.find<SignupController>();
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
          Get.find<SignupController>().password = value;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: "Password is required"),
          MinLengthValidator(6, errorText: 'Password must be at least 6 character'),
        ]),
      );
    });
  }

  Widget _nameField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Full Name",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2.w),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: kBaseColor,
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _nameController,
      onChanged: (value) {
        Get.find<SignupController>().name = value;
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Full Name is required"),
        MinLengthValidator(3, errorText: "At least 3 character is required"),
      ]),
    );
  }

  Widget _emailField() {
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
        Get.find<SignupController>().email = value;
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Email is required"),
        EmailValidator(errorText: "Enter a valid Email"),
      ]),
    );
  }

  Widget _signUpTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Create Account",
          style: TextStyle(fontSize: 20.sp),
        ),
      ],
    );
  }

  Widget _signUpLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 60.w),
      ],
    );
  }
}
