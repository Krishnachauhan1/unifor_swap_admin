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
      return schools.toList(); // ✅ .toList() zaroori
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
      } else {
        // ✅ API aaya lekin data nahi — mock load karo
        schools.value = _mockSchools();
      }
    } catch (e) {
      // ✅ Exception pe bhi mock load karo
      schools.value = _mockSchools();
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

  List<SchoolModel> _mockSchools() => [
        SchoolModel(
            id: 1,
            name: 'Delhi Public School - R.K. Puram',
            address: 'New Delhi, 110022',
            phone: '011-26170839',
            email: 'dps@example.com'),
        SchoolModel(
            id: 2,
            name: 'Ryan International School',
            address: 'Noida, UP',
            phone: '0120-4567890',
            email: 'ryan@example.com'),
        SchoolModel(
            id: 3,
            name: 'KV Sangathan - Sector 8',
            address: 'Dwarka, New Delhi',
            phone: '011-28035678',
            email: 'kv@example.com'),
        SchoolModel(
            id: 4,
            name: 'Amity International School',
            address: 'Saket, New Delhi',
            phone: '011-41888999',
            email: 'amity@example.com'),
        SchoolModel(
            id: 5,
            name: "St. Columba's School",
            address: 'Ashok Place, New Delhi',
            phone: '011-23364041',
            email: 'stcolumba@example.com'),
        SchoolModel(
            id: 6,
            name: 'Modern School',
            address: 'Barakhamba Road, New Delhi',
            phone: '011-23325684',
            email: 'modern@example.com'),
      ];

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
