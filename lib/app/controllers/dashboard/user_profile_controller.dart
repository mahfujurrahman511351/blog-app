// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/auth/user.dart';
import '../../models/response_status.dart';
import '../../service/auth_service.dart';
import '../../service/profile_service.dart';
import 'post_controller.dart';

class UserProfileController extends GetxController {
  final _storage = GetStorage();
  final _profileService = ProfileService();
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  var gettingData = false.obs;
  var showPasswordCard = false.obs;
  var changingPassword = false.obs;
  var editingProfile = false.obs;
  var updatingProfilePhoto = false.obs;

  var profilePhotoPath = "".obs;
  var avatar = "".obs;

  String currentPass = "";
  String newPass = "";

  String name = "";
  String phone = "";
  String shortBio = "";

  var user = User().obs;

  getUser() async {
    if (!gettingData.value) {
      gettingData.value = true;

      final response = await _profileService.getUser();

      if (response.error == null) {
        User userResponse = response.data != null ? response.data as User : User();

        await _storage.write(USER_NAME, userResponse.name);
        await _storage.write(USER_ID, userResponse.id);
        await _storage.write(USER_EMAIL, userResponse.email);
        await _storage.write(USER_AVATAR, userResponse.avatar);

        user.value = userResponse;
        avatar.value = userResponse.avatar ?? "";

        gettingData.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingData.value = false;
      } else {
        gettingData.value = false;
      }
    }
  }

  Future<bool> updatePassword() async {
    bool changed = false;
    if (!changingPassword.value) {
      changingPassword.value = true;

      var body = jsonEncode({
        "currentPass": currentPass,
        "newPass": newPass,
      });

      final response = await _authService.updatePass(body: body);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          changed = true;
          currentPass = "";
          newPass = "";
          showCustomDialogue(title: "Success", message: status.message ?? "");
          changingPassword.value = false;
        } else {
          changingPassword.value = false;
          showError(error: status.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        changingPassword.value = false;
      } else {
        showError(error: response.error ?? '');
        changingPassword.value = false;
      }
    }
    return changed;
  }

  updateProfile() async {
    if (!editingProfile.value) {
      editingProfile.value = true;

      var body = jsonEncode({
        "name": name,
        "phone": phone,
        "shortBio": shortBio,
      });

      final response = await _profileService.updateProfile(body: body);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          getUser();

          showCustomDialogue(title: "Success", message: status.message ?? "");
          editingProfile.value = false;
        } else {
          editingProfile.value = false;
          showError(error: status.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        editingProfile.value = false;
      } else {
        showError(error: response.error ?? '');
        editingProfile.value = false;
      }
    }
  }

  selectProfilePhoto({required ImageSource source}) async {
    var pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      profilePhotoPath.value = pickedFile.path;

      if (pickedFile.path.isNotEmpty) {
        updateProfilePhoto(pickedFile.path);
      } else {
        Get.snackbar(
          "Failed",
          "Image upload failed",
          colorText: Colors.white,
          backgroundColor: Colors.black54,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Not Selected",
        "No Image selected",
        colorText: Colors.white,
        backgroundColor: Colors.black54,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  updateProfilePhoto(String imagePath) async {
    if (!updatingProfilePhoto.value) {
      updatingProfilePhoto.value = true;

      final response = await _profileService.updateProfilePhoto(imagePath);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          String avatarImage = status.data != null ? status.data as String : "";

          avatar.value = avatarImage;

          updatingProfilePhoto.value = false;

          Get.find<PostController>().getData();

          showCustomDialogue(title: "Success", message: status.message ?? "");
        } else {
          showError(error: status.message ?? "");
          updatingProfilePhoto.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        updatingProfilePhoto.value = false;
      } else {
        showError(error: response.error ?? "");
        updatingProfilePhoto.value = false;
      }
    }
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
