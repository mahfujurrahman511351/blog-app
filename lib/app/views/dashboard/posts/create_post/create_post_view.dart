// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/dashboard/home_contrller.dart';
import '../../../../controllers/dashboard/post_controller.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _postKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Post'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
          child: Form(
            key: _postKey,
            child: ListView(
              children: [
                SizedBox(height: 20.w),
                _category(),
                SizedBox(height: 10.w),
                _titleField(),
                SizedBox(height: 10.w),
                _descriptionField(),
                SizedBox(height: 10.w),
                _selectThumbnail(),
                SizedBox(height: 10.w),
                _selectOtherImages(),
                SizedBox(height: 10.w),
                _publishButton(),
                SizedBox(height: 10.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _publishButton() {
    final controller = Get.find<PostController>();
    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_postKey.currentState!.validate()) {
          _postKey.currentState!.save();
          controller.createPost();
        }
      },
      child: Obx(() {
        return controller.creatingPost.value
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
                "Publish Now",
                style: TextStyle(fontSize: 15.w, color: Colors.white),
              );
      }),
    );
  }

  Widget _selectOtherImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MaterialButton(
              color: whiteBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              onPressed: () {
                Get.find<PostController>().selectOtherImages();
              },
              child: Row(
                children: [Icon(Icons.image), SizedBox(width: 5.w), Text("Select Other Images")],
              ),
            ),
          ],
        ),
        Obx(() {
          final imagePaths = Get.find<PostController>().imagePaths;

          return imagePaths.isEmpty
              ? Container()
              : Wrap(
                  children: List.generate(imagePaths.length, (index) {
                    String path = imagePaths[index];
                    return Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: SizedBox(
                        width: 150.w,
                        child: Stack(
                          children: [
                            Image.file(File(path)),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                onPressed: () {
                                  Get.find<PostController>().imagePaths.removeAt(index);
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                );
        })
      ],
    );
  }

  Widget _selectThumbnail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MaterialButton(
              color: whiteBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              onPressed: () {
                Get.find<PostController>().selectThumbnail();
              },
              child: Row(
                children: [Icon(Icons.image), SizedBox(width: 5.w), Text("Select Post Thumbnail")],
              ),
            ),
          ],
        ),
        Obx(() {
          String thumbnailPath = Get.find<PostController>().thumbnailPath.value;

          return thumbnailPath.isEmpty
              ? Container()
              : SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.file(File(thumbnailPath)),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            Get.find<PostController>().thumbnailPath.value = "";
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      )
                    ],
                  ),
                );
        })
      ],
    );
  }

  Widget _titleField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _titleController,
      onSaved: (value) {
        Get.find<PostController>().title = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Title is required"),
        MinLengthValidator(3, errorText: "At least 3 character is required"),
      ]),
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: "Description",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      maxLines: 8,
      controller: _descriptionController,
      onSaved: (value) {
        Get.find<PostController>().description = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Description is required"),
        MinLengthValidator(3, errorText: "At least 3 character is required"),
      ]),
    );
  }

  Widget _category() {
    return Obx(() {
      var categories = Get.find<HomeController>().categories;

      var categoryNames = ["All Category"];

      for (var item in categories) {
        categoryNames.add(item.name ?? '');
      }

      return DropdownSearch(
        showSearchBox: true,
        items: categoryNames,
        selectedItem: "All Category",
        onChanged: (name) {
          String selectedId = "";

          for (var item in categories) {
            if (item.name == name) {
              selectedId = item.id ?? "";
              break;
            }
          }
          Get.find<PostController>().selectedCategoryId = selectedId;
        },
      );
    });
  }
}
