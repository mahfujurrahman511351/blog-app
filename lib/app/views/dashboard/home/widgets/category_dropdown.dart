// ignore_for_file: unused_local_variable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/dashboard/home_contrller.dart';

class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        },
      );
    });
  }
}
