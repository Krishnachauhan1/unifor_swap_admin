import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {

  bool isLoading = false;

  List<CategoryModel> categories = [];

  Map<int, bool> expandedCategories = {};
  Map<int, bool> expandedSubCategories = {};

  String searchQuery = '';

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  int? selectedCategoryId;
  int? selectedSubCategoryId;

  @override
  void onInit() {
    super.onInit();
    getCategories(); // ✅ Only API
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }

  // ✅ Fetch Categories From API
  Future<void> getCategories() async {
    try {
      isLoading = true;
      update();

      final res = await ApiService.get(categoriesApi);

      if (res['status'] == true) {
        final List data = res['data'];

        categories =
            data.map((e) => CategoryModel.fromJson(e)).toList();
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // ✅ Search
  List<CategoryModel> get filteredCategories {
    if (searchQuery.isEmpty) return categories;

    final q = searchQuery.toLowerCase();

    return categories.where((cat) {
      if (cat.name.toLowerCase().contains(q)) return true;

      for (var sub in cat.subCategories) {
        if (sub.name.toLowerCase().contains(q)) return true;
      }

      return false;
    }).toList();
  }

  void toggleCategory(int id) {
    expandedCategories[id] = !(expandedCategories[id] ?? false);
    update();
  }

  void toggleSubCategory(int id) {
    expandedSubCategories[id] = !(expandedSubCategories[id] ?? false);
    update();
  }

  void deleteCategory(int id) {
    categories.removeWhere((c) => c.id == id);

    Get.snackbar(
      'Deleted',
      'Category removed',
      backgroundColor: const Color(0xFFB00020),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    update();
  }

  // Stats
  int get totalCategories => categories.length;

  int get totalSubCategories =>
      categories.fold(0, (sum, c) => sum + c.subCategories.length);

  Future<void> addCategory(String name) async {
    if (name.trim().isEmpty) {
      Get.snackbar("Error", "Category name required");
      return;
    }

    try {
      // isSaving = true;
      // update();

      final res = await ApiService.post(categoriesApi, {
        "name": name.trim(),
      });

      print(res);

      if (res['status'] == true) {

        Get.snackbar(
          "Success",
          res['message'] ?? "Category created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green
        );
        getCategories();
      } else {
        Get.snackbar(
          "Error",
          res['message'] ?? "Failed to create category",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }


  }

  Future<void> addSubCategory(String categoryId, String name) async {

    if (name.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Sub category name required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final res = await ApiService.post('sub-categories', {
        "category_id": categoryId,
        "name": name.trim(),
      });

      if (res['status'] == true) {
        Get.snackbar(
          "Success",
          res['message'] ?? "Sub-category created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,

        );
        getCategories();
      } else {
        Get.snackbar(
          "Error",
          res['message'] ?? "Failed to create sub-category",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red
        );
      }

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

  }
}