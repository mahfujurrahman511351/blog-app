import 'package:blog/app/constants/api_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/helper_function.dart';
import '../../../models/auth/user.dart';
import '../../../models/dashboard/post.dart';
import '../../../models/dashboard/post_category.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final category = post.category != null ? post.category as PostCategory : PostCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
        child: SafeArea(
            child: ListView(
          children: [
            _titleDescription(category),
            SizedBox(height: 10.w),
            _images(),
            SizedBox(height: 10.w),
            _authorCard(),
            _commentTitle(),
            SizedBox(height: 20.w),
          ],
        )),
      ),
    );
  }

  Widget _commentTitle() {
    int commentCount = post.commentCount ?? 0;

    return commentCount > 0
        ? Text('Total ($commentCount) comments')
        : Text(
            'No Comments yet!',
            style: TextStyle(fontSize: 13.sp),
          );
  }

  Widget _authorCard() {
    User user = post.user != null ? post.user as User : User();

    var avatar = user.avatar ?? '';
    var avatarLink = imageBaseUrl + avatar;

    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Column(
        children: [
          Divider(),
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Row(
              children: [
                if (avatar.isEmpty) Icon(Icons.person, size: 40.sp),
                if (avatar.isNotEmpty)
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(avatarLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? '',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      user.shortBio ?? '',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      'Total ${user.postCount} posts',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _images() {
    final images = (post.images != null) || (post.images!.isNotEmpty) ? post.images as List<String> : <String>[];
    images.insert(0, post.thumbnail ?? "");

    return Column(
      children: List.generate(images.length, (index) {
        String image = images[index];
        String imageUrl = imageBaseUrl + image;
        return image.isEmpty
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.w),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              );
      }),
    );
  }

  Widget _titleDescription(PostCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title ?? '',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 2.w),
        Row(
          children: [
            Expanded(child: Text(category.name ?? '', style: TextStyle(fontSize: 12.sp))),
            Text(getCustomDate(post.createdAt ?? ''), style: TextStyle(fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 10.w),
        Text(
          post.description ?? '',
          style: TextStyle(fontSize: 14.sp),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}
