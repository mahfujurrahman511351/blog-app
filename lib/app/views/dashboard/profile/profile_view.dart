// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/api_string.dart';
import '../../../constants/app_string.dart';
import '../../../constants/colors.dart';
import '../../../constants/helper_function.dart';
import '../../../controllers/dashboard/profile_Controller.dart';
import '../posts/deleted_post_view/deleted_post_view.dart';
import '../posts/my_post_view/my_post_view.dart';
import '../posts/saved_posts/saved_post_view.dart';
import 'edit_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _passwordKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("My Profile"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: ListView(
          children: [
            SizedBox(height: 10.w),
            _profileImage(),
            SizedBox(height: 10.w),
            _infoCard(),
            SizedBox(height: 5.w),
            _changePassword(),
            SizedBox(height: 5.w),
            _myPosts(),
            SizedBox(height: 5.w),
            _savePosts(),
            SizedBox(height: 5.w),
            _deletedPosts(),
            SizedBox(height: 5.w),
            _logOut(),
            SizedBox(height: 5.w),
          ],
        ),
      )),
    );
  }

  Widget _logOut() {
    return ProfileItemCard(
      prefixIcon: Icons.logout,
      text: "Log Out",
      onTap: () {
        logout();
      },
    );
  }

  Widget _deletedPosts() {
    return ProfileItemCard(
      prefixIcon: Icons.notes_outlined,
      text: "Deleted Posts",
      suffixIcon: Icons.arrow_right,
      onTap: () {
        Get.to(() => DeletedPostView());
      },
    );
  }

  Widget _savePosts() {
    return ProfileItemCard(
      prefixIcon: Icons.notes_outlined,
      text: "Saved Posts",
      suffixIcon: Icons.arrow_right,
      onTap: () {
        Get.to(() => SavedPostsView());
      },
    );
  }

  Widget _myPosts() {
    return ProfileItemCard(
      prefixIcon: Icons.notes_outlined,
      text: "Posts by me",
      suffixIcon: Icons.arrow_right,
      onTap: () {
        Get.to(() => MyPostView());
      },
    );
  }

  Widget _changePassword() {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<ProfileController>();
        controller.showPasswordCard.value = !controller.showPasswordCard.value;
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 10.w),
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    bool showPasswordCard = Get.find<ProfileController>().showPasswordCard.value;
                    return showPasswordCard ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_right);
                  })
                ],
              ),
              Obx(() {
                bool showPasswordCard = Get.find<ProfileController>().showPasswordCard.value;
                return showPasswordCard
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Form(
                          key: _passwordKey,
                          child: Column(
                            children: [
                              SizedBox(height: 5.w),
                              TextFormField(
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  labelText: "Current Password",
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "Current password is required"),
                                  MinLengthValidator(6, errorText: "Minimum 6 character required"),
                                ]),
                                controller: _currentPasswordController,
                                onSaved: (value) {
                                  Get.find<ProfileController>().currentPass = value ?? "";
                                },
                              ),
                              SizedBox(height: 5.w),
                              TextFormField(
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "Write new password"),
                                  MinLengthValidator(6, errorText: "Minimum 6 character required"),
                                ]),
                                controller: _newPasswordController,
                                onSaved: (value) {
                                  Get.find<ProfileController>().newPass = value ?? "";
                                },
                              ),
                              SizedBox(height: 5.w),
                              MaterialButton(
                                onPressed: () async {
                                  if (_passwordKey.currentState!.validate()) {
                                    _passwordKey.currentState!.save();
                                    bool changed = await Get.find<ProfileController>().updatePassword();

                                    if (changed) {
                                      _currentPasswordController.clear();
                                      _newPasswordController.clear();
                                    }
                                  }
                                },
                                minWidth: double.infinity,
                                color: kBaseColor,
                                child: Obx(() {
                                  final controller = Get.find<ProfileController>();
                                  return controller.changingPassword.value
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
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Obx(() {
      final user = Get.find<ProfileController>().user.value;
      return Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name ?? "",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: kBaseColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(() => EditProfileView(user: user));
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 18.sp,
                        )),
                  ],
                ),
                SizedBox(height: 3.w),
                Text(
                  "Email : ${user.email ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Phone : ${user.phone ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Total Posts : ${user.postCount ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Joining Date : ${getCustomDate(user.createdAt ?? "") ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  "ShortBio : ${user.shortBio ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.w),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _profileImage() {
    return Obx(() {
      var user = Get.find<ProfileController>().user.value;
      String avatar = user.avatar ?? "";

      String avatarUrl = imageBaseUrl + avatar;

      return Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(width: 1.w, color: Colors.grey[400]!),
          image: DecorationImage(
            image: avatar.isNotEmpty ? NetworkImage(avatarUrl) : AssetImage(DEFAULT_USER_IMAGE) as ImageProvider<Object>,
          ),
        ),
      );
    });
  }
}

class ProfileItemCard extends StatelessWidget {
  const ProfileItemCard({
    super.key,
    required this.prefixIcon,
    required this.text,
    this.suffixIcon,
    required this.onTap,
  });

  final IconData prefixIcon;
  final String text;
  final IconData? suffixIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(prefixIcon),
                    SizedBox(width: 10.w),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              if (suffixIcon != null) Icon(suffixIcon),
            ],
          ),
        ),
      ),
    );
  }
}
