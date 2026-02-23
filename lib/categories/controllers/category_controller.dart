import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  var expandedCategories = <int, bool>{}.obs;
  var expandedSubCategories = <int, bool>{}.obs;
  var searchQuery = ''.obs;
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  var selectedCategoryId = Rxn<int>();
  var selectedSubCategoryId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadDemoCategories();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }

  void loadDemoCategories() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      categories.value = _buildDemoData();
      isLoading.value = false;
    });
  }

  void toggleCategory(int id) {
    expandedCategories[id] = !(expandedCategories[id] ?? false);
    expandedCategories.refresh();
  }

  void toggleSubCategory(int id) {
    expandedSubCategories[id] = !(expandedSubCategories[id] ?? false);
    expandedSubCategories.refresh();
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) return categories;
    final q = searchQuery.value.toLowerCase();
    return categories.where((cat) {
      if (cat.name.toLowerCase().contains(q)) return true;
      for (var sub in cat.subCategories) {
        if (sub.name.toLowerCase().contains(q)) return true;
        for (var sec in sub.sections) {
          if (sec.name.toLowerCase().contains(q)) return true;
        }
      }
      return false;
    }).toList();
  }

  int get totalProducts => categories.fold(
      0,
      (sum, c) =>
          sum +
          c.subCategories.fold(
              0,
              (s2, sub) =>
                  s2 +
                  sub.sections.fold(0, (s3, sec) => s3 + sec.productCount)));
  int get totalCategories => categories.length;
  int get totalSubCategories =>
      categories.fold(0, (sum, c) => sum + c.subCategories.length);
  int get totalSections => categories.fold(
      0,
      (sum, c) =>
          sum + c.subCategories.fold(0, (s2, sub) => s2 + sub.sections.length));

  VoidCallback? get addCategory => null;

  void deleteCategory(int id) {
    categories.removeWhere((c) => c.id == id);
    Get.snackbar('Deleted', 'Category removed',
        backgroundColor: const Color(0xFFB00020),
        colorText: const Color(0xFFFFFFFF),
        snackPosition: SnackPosition.BOTTOM);
  }

  CategoryModel _cat(
          int id, String name, String icon, List<SubCategoryModel> subs) =>
      CategoryModel(
          id: id, name: name, icon: icon, description: '', subCategories: subs);

  SubCategoryModel _sub(
          int id, int catId, String name, List<SectionModel> secs) =>
      SubCategoryModel(id: id, categoryId: catId, name: name, sections: secs);

  SectionModel _sec(int id, int subId, String name, int count) => SectionModel(
      id: id,
      subCategoryId: subId,
      name: name,
      productCount: count,
      hasNew: true,
      hasUsed: count > 15);

  List<CategoryModel> _buildDemoData() {
    return [
      _cat(1, 'School Uniforms', '👔', [
        _sub(1, 1, 'Boys Uniform', [
          _sec(1, 1, 'Shirt', 24),
          _sec(2, 1, 'Trousers', 18),
          _sec(3, 1, 'Blazer', 10),
          _sec(4, 1, 'Tie and Belt', 30)
        ]),
        _sub(2, 1, 'Girls Uniform', [
          _sec(5, 2, 'Skirt Salwar', 20),
          _sec(6, 2, 'Blouse Shirt', 22),
          _sec(7, 2, 'Dupatta', 14)
        ]),
        _sub(3, 1, 'Accessories', [
          _sec(8, 3, 'School Shoes', 35),
          _sec(9, 3, 'Socks', 40),
          _sec(10, 3, 'ID Card Holder', 15)
        ]),
      ]),
      _cat(2, 'Sports and PE', '⚽', [
        _sub(4, 2, 'Sports Wear', [
          _sec(11, 4, 'Track Suit', 16),
          _sec(12, 4, 'Sports Shoes', 28),
          _sec(13, 4, 'Sports Jersey', 20)
        ]),
        _sub(5, 2, 'Equipment', [
          _sec(14, 5, 'Football', 12),
          _sec(15, 5, 'Cricket Kit', 8),
          _sec(16, 5, 'Badminton Set', 10),
          _sec(17, 5, 'Table Tennis', 6)
        ]),
      ]),
      _cat(3, 'Bags and Accessories', '🎒', [
        _sub(6, 3, 'Bags', [
          _sec(18, 6, 'Backpack', 45),
          _sec(19, 6, 'Trolley Bag', 20),
          _sec(20, 6, 'Laptop Bag', 12)
        ]),
        _sub(7, 3, 'Tiffin and Water', [
          _sec(21, 7, 'Lunch Box', 30),
          _sec(22, 7, 'Water Bottle', 35),
          _sec(23, 7, 'Snack Box', 18)
        ]),
      ]),
      _cat(4, 'Textbooks', '📚', [
        _sub(8, 4, 'CBSE Books', [
          _sec(24, 8, 'Class 1-5', 60),
          _sec(25, 8, 'Class 6-8', 55),
          _sec(26, 8, 'Class 9-10', 48),
          _sec(27, 8, 'Class 11-12', 40)
        ]),
        _sub(9, 4, 'ICSE State Board', [
          _sec(28, 9, 'Class 1-5', 40),
          _sec(29, 9, 'Class 6-8', 38),
          _sec(30, 9, 'Class 9-10', 35),
          _sec(31, 9, 'Class 11-12', 30)
        ]),
        _sub(10, 4, 'Competition Books', [
          _sec(32, 10, 'JEE NEET', 25),
          _sec(33, 10, 'Olympiad', 20),
          _sec(34, 10, 'NTSE Guides', 18)
        ]),
      ]),
      _cat(5, 'Notebooks and Stationery', '📓', [
        _sub(11, 5, 'Notebooks', [
          _sec(35, 11, 'Ruled Notebooks', 50),
          _sec(36, 11, 'Drawing Books', 30),
          _sec(37, 11, 'Graph Books', 20)
        ]),
        _sub(12, 5, 'Writing Instruments', [
          _sec(38, 12, 'Pens and Pencils', 80),
          _sec(39, 12, 'Colour Pencils', 40),
          _sec(40, 12, 'Markers', 35)
        ]),
        _sub(13, 5, 'Geometry Kit', [
          _sec(41, 13, 'Geometry Box', 25),
          _sec(42, 13, 'Calculator', 15),
          _sec(43, 13, 'Scale and Ruler', 20)
        ]),
      ]),
      _cat(6, 'Art and Craft', '🎨', [
        _sub(14, 6, 'Painting Supplies', [
          _sec(44, 14, 'Watercolors', 22),
          _sec(45, 14, 'Acrylic Colors', 18),
          _sec(46, 14, 'Brushes Set', 30)
        ]),
        _sub(15, 6, 'Craft Materials', [
          _sec(47, 15, 'Clay Modelling', 15),
          _sec(48, 15, 'Craft Paper', 25),
          _sec(49, 15, 'Glue Scissors', 20)
        ]),
      ]),
      _cat(7, 'Lab Equipment', '🔬', [
        _sub(16, 7, 'Safety Gear', [
          _sec(50, 16, 'Lab Coat', 18),
          _sec(51, 16, 'Safety Goggles', 22),
          _sec(52, 16, 'Gloves', 30)
        ]),
        _sub(17, 7, 'Instruments', [
          _sec(53, 17, 'Microscope', 8),
          _sec(54, 17, 'Lab Glassware', 14),
          _sec(55, 17, 'Physics Kit', 10)
        ]),
      ]),
      _cat(8, 'Musical Instruments', '🎵', [
        _sub(18, 8, 'String Instruments', [
          _sec(56, 18, 'Guitar', 12),
          _sec(57, 18, 'Ukulele', 8),
          _sec(58, 18, 'Violin', 6)
        ]),
        _sub(19, 8, 'Wind and Percussion', [
          _sec(59, 19, 'Flute', 10),
          _sec(60, 19, 'Drums', 5),
          _sec(61, 19, 'Keyboard', 7)
        ]),
      ]),
      _cat(9, 'Electronics', '💻', [
        _sub(20, 9, 'Devices', [
          _sec(62, 20, 'Scientific Calculator', 20),
          _sec(63, 20, 'Tablet', 10),
          _sec(64, 20, 'E-Reader', 6),
          _sec(65, 20, 'Headphones', 15)
        ]),
      ]),
      _cat(10, 'School Furniture', '🪑', [
        _sub(21, 10, 'Furniture', [
          _sec(66, 21, 'Study Table', 14),
          _sec(67, 21, 'Study Chair', 12),
          _sec(68, 21, 'Bookshelf', 8),
          _sec(69, 21, 'Storage Cabinet', 6)
        ]),
      ]),
    ];
  }
}
