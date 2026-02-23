import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_calls.dart';
import '../../apis.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var products = <ProductModel>[].obs;
  var searchQuery = ''.obs;
  var filterCondition = 'all'.obs;
  var filterCategory = Rxn<int>();

  // Form controllers
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  var conditionVal = 'new'.obs;
  var selectedCategoryId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadDemoProducts();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    super.onClose();
  }

  void loadDemoProducts() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      products.value = _demoProducts();
      isLoading.value = false;
    });
  }

  List<ProductModel> get filteredProducts {
    var list = products.toList();
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              (p.schoolName?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    if (filterCondition.value != 'all') {
      list = list.where((p) => p.condition == filterCondition.value).toList();
    }
    if (filterCategory.value != null) {
      list = list.where((p) => p.categoryId == filterCategory.value).toList();
    }
    return list;
  }

  TextEditingController? get sizeCtrl => null;

  TextEditingController? get colorCtrl => null;

  Future<void> addProduct(Map<String, Object> map) async {
    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
      Get.snackbar('Validation', 'Please fill all required fields');
      return;
    }
    try {
      isLoading.value = true;
      final res = await ApiService.post(productsApi, {
        'name': nameCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'price': priceCtrl.text.trim(),
        'stock': stockCtrl.text.trim(),
        'condition': conditionVal.value,
        'category_id': selectedCategoryId.value,
      });
      if (res['success'] == true) {
        Get.back();
        loadDemoProducts();
        Get.snackbar('Success', 'Product added!',
            backgroundColor: const Color(0xFF4CAF50),
            colorText: const Color(0xFFFFFFFF));
      }
    } catch (e) {
      // Demo mode fallback
      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: nameCtrl.text.trim(),
        description: descCtrl.text.trim(),
        price: double.tryParse(priceCtrl.text) ?? 0,
        condition: conditionVal.value,
        stock: int.tryParse(stockCtrl.text) ?? 0,
        categoryId: selectedCategoryId.value ?? 1,
        subCategoryId: 1,
        sectionId: 1,
        isActive: true,
        createdAt: DateTime.now(),
      );
      products.insert(0, newProduct);
      Get.back();
      Get.snackbar('Added', 'Product added (demo mode)',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await ApiService.delete('$productsApi/$id');
    } catch (_) {}
    products.removeWhere((p) => p.id == id);
    Get.snackbar('Deleted', 'Product removed',
        backgroundColor: const Color(0xFFB00020),
        colorText: const Color(0xFFFFFFFF),
        snackPosition: SnackPosition.BOTTOM);
  }

  List<ProductModel> _demoProducts() {
    final now = DateTime.now();
    return [
      ProductModel(
          id: 1,
          name: 'Boys White Shirt - Class 5-8',
          description: 'Official school white shirt',
          price: 450,
          condition: 'new',
          stock: 24,
          categoryId: 1,
          subCategoryId: 1,
          sectionId: 1,
          schoolName: 'DPS School',
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 2,
          name: 'Boys Grey Trousers',
          description: 'Grey formal trousers',
          price: 380,
          condition: 'used',
          stock: 12,
          categoryId: 1,
          subCategoryId: 1,
          sectionId: 2,
          schoolName: 'Kendriya Vidyalaya',
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 3,
          name: 'Girls Navy Skirt',
          description: 'Navy blue pleated skirt',
          price: 320,
          condition: 'new',
          stock: 18,
          categoryId: 1,
          subCategoryId: 2,
          sectionId: 5,
          schoolName: 'Convent School',
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 4,
          name: 'Sports Track Suit Blue',
          description: 'Complete track suit',
          price: 750,
          condition: 'new',
          stock: 10,
          categoryId: 2,
          subCategoryId: 4,
          sectionId: 11,
          schoolName: 'St. Mary School',
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 5,
          name: 'School Backpack 30L',
          description: 'Durable school backpack',
          price: 1200,
          condition: 'new',
          stock: 35,
          categoryId: 3,
          subCategoryId: 6,
          sectionId: 18,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 6,
          name: 'CBSE Class 10 Science',
          description: 'NCERT Science textbook',
          price: 180,
          condition: 'used',
          stock: 8,
          categoryId: 4,
          subCategoryId: 8,
          sectionId: 26,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 7,
          name: 'JEE Physics Vol 1 & 2',
          description: 'Complete JEE physics guide',
          price: 850,
          condition: 'used',
          stock: 5,
          categoryId: 4,
          subCategoryId: 10,
          sectionId: 32,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 8,
          name: 'Geometry Box Premium',
          description: 'Full geometry set',
          price: 220,
          condition: 'new',
          stock: 40,
          categoryId: 5,
          subCategoryId: 13,
          sectionId: 41,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 9,
          name: 'Watercolor Set 24 Colors',
          description: 'Professional watercolors',
          price: 350,
          condition: 'new',
          stock: 22,
          categoryId: 6,
          subCategoryId: 14,
          sectionId: 44,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 10,
          name: 'Lab Coat White Medium',
          description: 'Science lab protection coat',
          price: 480,
          condition: 'new',
          stock: 15,
          categoryId: 7,
          subCategoryId: 16,
          sectionId: 50,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 11,
          name: 'Acoustic Guitar Beginner',
          description: 'Steel string beginner guitar',
          price: 3500,
          condition: 'used',
          stock: 3,
          categoryId: 8,
          subCategoryId: 18,
          sectionId: 56,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 12,
          name: 'Scientific Calculator FX',
          description: 'CASIO scientific calculator',
          price: 890,
          condition: 'new',
          stock: 20,
          categoryId: 9,
          subCategoryId: 20,
          sectionId: 62,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 13,
          name: 'Study Table with Shelf',
          description: 'Wooden study table',
          price: 4500,
          condition: 'used',
          stock: 4,
          categoryId: 10,
          subCategoryId: 21,
          sectionId: 66,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 14,
          name: 'Stainless Steel Water Bottle',
          description: '750ml insulated bottle',
          price: 350,
          condition: 'new',
          stock: 60,
          categoryId: 3,
          subCategoryId: 7,
          sectionId: 22,
          isActive: true,
          createdAt: now),
      ProductModel(
          id: 15,
          name: 'Cricket Kit Junior',
          description: 'Complete junior cricket set',
          price: 2800,
          condition: 'used',
          stock: 2,
          categoryId: 2,
          subCategoryId: 5,
          sectionId: 15,
          isActive: true,
          createdAt: now),
    ];
  }
}
