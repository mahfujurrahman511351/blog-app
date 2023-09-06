import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/models/dashboard/post_category.dart';
import 'package:blog/app/service/home_service.dart';
import 'package:get/get.dart';

import '../../constants/app_string.dart';

class HomeController extends GetxController {
  final _homeService = HomeService();
  var categories = <PostCategory>[].obs;

  var searching = false.obs;

  var selectedCategoryId = "";

  getCategories() async {
    var response = await _homeService.getCategories();

    if (response.error == null) {
      var categoryList = response.data != null ? response.data as List<dynamic> : [];

      categories.clear();
      for (var item in categoryList) {
        categories.add(item);
      }
    } else if (response.error == UN_AUTHENTICATED) {
      logout();
    }
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
  // get categories
}
