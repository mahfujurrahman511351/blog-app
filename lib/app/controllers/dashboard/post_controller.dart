import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/like.dart';
import '../../models/dashboard/post.dart';
import '../../models/response_status.dart';
import '../../service/post_service.dart';

class PostController extends GetxController {
  final _postService = PostService();
  final _imagePicker = ImagePicker();
  var allPosts = <Post>[].obs;

  var loadingData = false.obs;
  var likeUnlikeLoading = false.obs;
  var creatingPost = false.obs;

  String selectedCategoryId = "";
  String title = "";
  String description = "";

  var thumbnailPath = "".obs;
  var imagePaths = <String>[].obs;
  //

  createPost() async {
    if (!creatingPost.value) {
      creatingPost.value = true;

      if (selectedCategoryId.isNotEmpty) {
        //
        if (thumbnailPath.isNotEmpty) {
          final content = {
            "title": title,
            "description": description,
            "categoryId": selectedCategoryId,
          };

          List<String> newImagePaths = [];

          newImagePaths.addAll(imagePaths);

          newImagePaths.insert(0, thumbnailPath.value);

          final response = await _postService.createPost(content, newImagePaths);

          if (response.error == null) {
            final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

            bool success = responseStatus.success ?? false;

            if (success) {
              title = "";
              description = "";
              selectedCategoryId = "";
              thumbnailPath.value = "";
              imagePaths.clear();
              getAllPosts();
              Get.back();
              creatingPost.value = false;
            } else {
              creatingPost.value = false;
              showError(error: responseStatus.message ?? "");
            }
            //
          } else if (response.error == UN_AUTHENTICATED) {
            creatingPost.value = false;
            logout();
            //
          } else {
            newImagePaths.removeAt(0);
            creatingPost.value = false;
            showError(error: response.error ?? "something went wrong");
          }
          //
        } else {
          print("hrer");
          creatingPost.value = false;
          showError(title: "Thumbnail", error: "Select a thumbnail image first");
        }
      } else {
        creatingPost.value = false;
        showError(title: "Category", error: "Select a post category first");
      }
    }
  }

  selectThumbnail() async {
    var pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      thumbnailPath.value = pickedFile.path;
      //
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

  selectOtherImages() async {
    final files = await _imagePicker.pickMultiImage();

    for (var item in files) {
      imagePaths.add(item.path);
    }
  }

  getAllPosts() async {
    loadingData.value = true;
    var response = await _postService.getAllPosts();

    if (response.error == null) {
      var postList = response.data != null ? response.data as List<dynamic> : [];

      allPosts.clear();
      for (var item in postList) {
        allPosts.add(item);
      }
      loadingData.value = false;
    } else if (response.error == UN_AUTHENTICATED) {
      logout();
      loadingData.value = false;
    }
  }

  likeUnlike(String postId, int index) async {
    if (!likeUnlikeLoading.value) {
      likeUnlikeLoading.value = true;

      final response = await _postService.likeUnlike(postId);

      if (response.error == null) {
        //
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          //
          Like like = responseStatus.data != null ? responseStatus.data as Like : Like();
          //
          final post = allPosts[index];
          post.isLiked = like.isLiked ?? false;
          post.likeCount = like.likeCount ?? 0;
          allPosts[index] = post;
        } else {
          showError(error: responseStatus.message ?? '');
        }
        likeUnlikeLoading.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        likeUnlikeLoading.value = false;
        logout();
      } else {
        likeUnlikeLoading.value = false;
        showError(error: response.error ?? '');
      }
    }
  }

  @override
  void onInit() {
    getAllPosts();
    super.onInit();
  }
}
