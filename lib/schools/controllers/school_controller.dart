import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/schools/models/school_model.dart';
// school_controller.dart

class SchoolController extends GetxController {
  var isLoading = false.obs;
  var schools = <SchoolModel>[].obs;
  var searchQuery = ''.obs;

  // ✅ Clean getter — no bugs
  List<SchoolModel> get filteredSchools {
    if (searchQuery.value.isEmpty)
      return schools.toList();
    final q = searchQuery.value.toLowerCase();
    return schools
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            (s.address?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  final searchCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSchools();
    searchCtrl.addListener(() => searchQuery.value = searchCtrl.text);
  }

  Future<void> fetchSchools() async {
    try {
      isLoading.value = true;
      final res = await ApiService.get(schoolsApi);

      if (res != null && res['data'] != null) {
        schools.value =
            (res['data'] as List).map((e) => SchoolModel.fromJson(e)).toList();
      }
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSchool(Map<String, dynamic> data) async {
    try {
      final res = await ApiService.post(schoolsApi, data);
      final school = SchoolModel.fromJson(res['data'] ?? res);
      schools.insert(0, school);
      Get.snackbar('Success', 'School added successfully',
          backgroundColor: const Color(0xFF4CAF50), colorText: Colors.white);
    } catch (e) {
      final newSchool = SchoolModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: data['name'] ?? '',
        address: data['address'],
        phone: data['phone'],
        email: data['email'],
      );
      schools.insert(0, newSchool);
      Get.snackbar('Added', 'School added (demo)',
          backgroundColor: const Color(0xFF4CAF50), colorText: Colors.white);
    }
  }

  Future<void> deleteSchool(int id) async {
    try {
      await ApiService.delete('$schoolsApi/$id');
    } catch (_) {}
    schools.removeWhere((s) => s.id == id);
    Get.snackbar('Deleted', 'School removed',
        backgroundColor: const Color(0xFFB00020),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }



  @override
  void onClose() {
    searchCtrl.dispose();
    nameCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
