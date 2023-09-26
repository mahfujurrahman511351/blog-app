// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/dashboard/user_profile_controller.dart';
import '../../../models/auth/user.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.user});

  final User user;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  User user = User();

  final _profileEditingKey = GlobalKey<FormState>();

  final controller = Get.find<UserProfileController>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shortBioController = TextEditingController();

  setValue() {
    user = widget.user;
    _nameController.text = user.name ?? "";
    _phoneController.text = user.phone ?? "";
    _shortBioController.text = user.shortBio ?? "";

    //
    controller.name = user.name ?? "";
    controller.phone = user.phone ?? "";
    controller.shortBio = user.shortBio ?? "";
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _shortBioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Profile"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Form(
            key: _profileEditingKey,
            child: ListView(
              children: [
                SizedBox(height: 20.w),
                _nameField(),
                SizedBox(height: 10.w),
                _phoneField(),
                SizedBox(height: 10.w),
                _shortBioField(),
                SizedBox(height: 10.w),
                _updateButton(),
              ],
            ),
          ),
        ),
      ),
    );
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
      onSaved: (value) {
        Get.find<UserProfileController>().name = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Full Name is required"),
        MinLengthValidator(3, errorText: "At least 3 character is required"),
      ]),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Phone",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2.w),
        ),
        prefixIcon: Icon(
          Icons.phone,
          color: kBaseColor,
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _phoneController,
      onSaved: (value) {
        Get.find<UserProfileController>().phone = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Number is required"),
        MinLengthValidator(11, errorText: "At least 11 character is required"),
      ]),
    );
  }

  Widget _shortBioField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Short Bio",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2.w),
        ),
        prefixIcon: Icon(
          Icons.description_outlined,
          color: kBaseColor,
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _shortBioController,
      onSaved: (value) {
        Get.find<UserProfileController>().shortBio = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Bio is required"),
        MaxLengthValidator(160, errorText: "Write within 160 character"),
      ]),
    );
  }

  Widget _updateButton() {
    return MaterialButton(
      onPressed: () async {
        if (_profileEditingKey.currentState!.validate()) {
          _profileEditingKey.currentState!.save();
          Get.find<UserProfileController>().updateProfile();
        }
      },
      minWidth: double.infinity,
      color: kBaseColor,
      child: Obx(() {
        final controller = Get.find<UserProfileController>();
        return controller.editingProfile.value
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
                "Update",
                style: TextStyle(fontSize: 15.w, color: Colors.white),
              );
      }),
    );
  }
}
