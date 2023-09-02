import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/like.dart';
import '../../models/dashboard/post.dart';
import '../../models/response_status.dart';
import '../../service/post_service.dart';
import '../../views/dashboard/dashboard/dashboard_view.dart';

class PostController extends GetxController {
  final _postService = PostService();
  final _imagePicker = ImagePicker();
  var allPosts = <Post>[].obs;
  var deletedPosts = <Post>[].obs;
  var savedPosts = <Post>[].obs;

  var loadingData = false.obs;
  var gettingDeletedPost = false.obs;
  var gettingSavedPost = false.obs;
  var likeUnlikeLoading = false.obs;
  var creatingPost = false.obs;
  var updatingPost = false.obs;
  var deletingPost = false.obs;
  var savingPost = false.obs;
  var removingSavedPost = false.obs;

  var selectedCategory = "All Category".obs;

  String selectedCategoryId = "";
  String title = "";
  String description = "";

  String editTitle = "";
  String editDescription = "";
  String editCategoryId = "";

  var isNetworkImage = false.obs;
  String deletedThumbnail = "";
  var networkImages = <String>[].obs;
  var deletedImages = <String>[];

  var thumbnailPath = "".obs;
  var imagePaths = <String>[].obs;
  //

  editPost(String postId) async {
    if (!updatingPost.value) {
      updatingPost.value = true;

      if (editCategoryId.isNotEmpty) {
        if (thumbnailPath.isNotEmpty) {
          //
          final content = {
            "title": editTitle,
            "description": editDescription,
            "postId": postId,
            "categoryId": editCategoryId,
            "deletedThumbnail": deletedThumbnail,
          };
          if (!isNetworkImage.value) {
            imagePaths.insert(0, thumbnailPath.value);
          }

          final response = await _postService.editPost(content, imagePaths, deletedImages);

          if (response.error == null) {
            final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

            bool success = responseStatus.success ?? false;

            if (success) {
              editTitle = "";
              editDescription = "";
              editCategoryId = "";
              thumbnailPath.value = "";
              deletedThumbnail = "";
              imagePaths.clear();
              deletedImages.clear();
              getAllPosts();
              Get.offAll(() => const DashboardView());
              updatingPost.value = false;
            } else {
              updatingPost.value = false;
              showError(error: responseStatus.message ?? "");
            }
            //
          } else if (response.error == UN_AUTHENTICATED) {
            updatingPost.value = false;
            logout();
            //
          } else {
            updatingPost.value = false;
            showError(error: response.error ?? "Something went wrong");
          }
          //
        } else {
          updatingPost.value = false;
          showError(title: "Thumbnail", error: "Select a thumbnail image first");
        }
      } else {
        updatingPost.value = false;
        showError(title: "Category", error: "Select a post category first");
      }
    }
  }

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
          creatingPost.value = false;
          showError(title: "Thumbnail", error: "Select a thumbnail image first");
        }
      } else {
        creatingPost.value = false;
        showError(title: "Category", error: "Select a post category first");
      }
    }
  }

  selectThumbnail({String? thumbnail}) async {
    var pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (isNetworkImage.value) {
        deletedThumbnail = thumbnail ?? "";
        isNetworkImage.value = false;
      }
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

  getDeletedPosts() async {
    gettingDeletedPost.value = true;
    var response = await _postService.getDeletedPosts();

    if (response.error == null) {
      var postList = response.data != null ? response.data as List<dynamic> : [];

      deletedPosts.clear();
      for (var item in postList) {
        deletedPosts.add(item);
      }
      gettingDeletedPost.value = false;
    } else if (response.error == UN_AUTHENTICATED) {
      logout();
      gettingDeletedPost.value = false;
    } else {
      gettingDeletedPost.value = false;
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

  deletePost(String postId, int index) async {
    if (!deletingPost.value) {
      deletingPost.value = true;

      final response = await _postService.deletePost(postId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          Get.snackbar(
            "Success",
            "Post deleted successfully",
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
          );
          allPosts.removeAt(index);
          getDeletedPosts();
          deletingPost.value = false;
        } else {
          deletingPost.value = false;
          showError(error: responseStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        deletingPost.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingPost.value = false;
      }
    }
  }

  deletePostPermanently(String postId, int index) async {
    if (!deletingPost.value) {
      deletingPost.value = true;

      final response = await _postService.deletePostPermanently(postId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          deletedPosts.removeAt(index);
          deletingPost.value = false;
          Get.snackbar(
            "Success",
            "Post deleted permanently",
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          deletingPost.value = false;
          showError(error: responseStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        deletingPost.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingPost.value = false;
      }
    }
  }

  removeSavedPost(String postId, int index) async {
    if (!removingSavedPost.value) {
      removingSavedPost.value = true;

      final response = await _postService.removeSavedPosts(postId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          removingSavedPost.value = false;
          savedPosts.removeAt(index);
          Get.snackbar(
            "Success",
            "Post Removed successfully",
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          removingSavedPost.value = false;
          showError(error: responseStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        removingSavedPost.value = false;
      } else {
        showError(error: response.error ?? "");
        removingSavedPost.value = false;
      }
    }
  }

  savedPost(String postId) async {
    if (!savingPost.value) {
      savingPost.value = true;

      final response = await _postService.savedPosts(postId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          getSavedPosts();
          savingPost.value = false;
          Get.snackbar(
            "Success",
            "Post Saved successfully",
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          savingPost.value = false;
          showError(error: responseStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        savingPost.value = false;
      } else {
        showError(error: response.error ?? "");
        savingPost.value = false;
      }
    }
  }

  getSavedPosts() async {
    if (!gettingSavedPost.value) {
      gettingSavedPost.value = true;

      final response = await _postService.getSavedPosts();

      if (response.error == null) {
        var postList = response.data != null ? response.data as List<dynamic> : [];

        savedPosts.clear();
        for (var item in postList) {
          savedPosts.add(item);
        }
        gettingSavedPost.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingSavedPost.value = false;
      } else {
        gettingSavedPost.value = false;
      }
    }
  }

  @override
  void onInit() {
    getAllPosts();
    getDeletedPosts();
    getSavedPosts();
    super.onInit();
  }
}
