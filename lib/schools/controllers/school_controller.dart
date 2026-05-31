import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/schools/models/school_model.dart';

class SchoolController extends GetxController {
  static const List<String> boardOptions = [
    'CBSE',
    'ICSE',
    'State Board',
    'IB',
    'IGCSE',
    'Other',
  ];

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var schools = <SchoolModel>[].obs;
  var searchQuery = ''.obs;

  List<SchoolModel> get filteredSchools {
    if (searchQuery.value.isEmpty) return schools.toList();
    final q = searchQuery.value.toLowerCase();
    return schools
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            (s.address?.toLowerCase().contains(q) ?? false) ||
            (s.city?.toLowerCase().contains(q) ?? false) ||
            (s.email?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  final searchCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  final selectedBoard = RxnString();
  final isActive = true.obs;
  final isFeatured = false.obs;
  final logoBytes = Rxn<Uint8List>();
  final logoFileName = RxnString();
  final bannerBytes = Rxn<Uint8List>();
  final bannerFileName = RxnString();

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
        schools.value = (res['data'] as List)
            .map((e) => SchoolModel.fromJson(e))
            .toList();
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Failed to load schools',
        backgroundColor: const Color(0xFFB00020),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    nameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    addressCtrl.clear();
    cityCtrl.clear();
    stateCtrl.clear();
    pincodeCtrl.clear();
    selectedBoard.value = null;
    isActive.value = true;
    isFeatured.value = false;
    logoBytes.value = null;
    logoFileName.value = null;
    bannerBytes.value = null;
    bannerFileName.value = null;
  }

  Future<bool> registerSchool() async {
    if (nameCtrl.text.trim().isEmpty) {
      Get.snackbar('Validation', 'School name is required',
          backgroundColor: const Color(0xFFB00020), colorText: Colors.white);
      return false;
    }

    try {
      isSubmitting.value = true;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$schoolsApi'),
      );

      final token = await ApiService.getToken();
      request.headers['Accept'] = 'application/json';
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields.addAll({
        'name': nameCtrl.text.trim(),
        if (selectedBoard.value != null) 'board': selectedBoard.value!,
        if (emailCtrl.text.trim().isNotEmpty) 'email': emailCtrl.text.trim(),
        if (phoneCtrl.text.trim().isNotEmpty) 'phone': phoneCtrl.text.trim(),
        if (addressCtrl.text.trim().isNotEmpty)
          'address': addressCtrl.text.trim(),
        if (cityCtrl.text.trim().isNotEmpty) 'city': cityCtrl.text.trim(),
        if (stateCtrl.text.trim().isNotEmpty) 'state': stateCtrl.text.trim(),
        if (pincodeCtrl.text.trim().isNotEmpty)
          'pincode': pincodeCtrl.text.trim(),
        'is_active': isActive.value ? '1' : '0',
        'is_featured': isFeatured.value ? '1' : '0',
      });

      if (logoBytes.value != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'logo',
          logoBytes.value!,
          filename: logoFileName.value ?? 'logo.jpg',
        ));
      }

      if (bannerBytes.value != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'banner_image',
          bannerBytes.value!,
          filename: bannerFileName.value ?? 'banner.jpg',
        ));
      }

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        await fetchSchools();
        resetForm();
        Get.snackbar('Success', 'School registered successfully',
            backgroundColor: const Color(0xFF4CAF50), colorText: Colors.white);
        return true;
      }

      throw Exception('API Error ${streamed.statusCode}: $body');
    } catch (e) {
      Get.snackbar('Error', 'Failed to register school. Please try again.',
          backgroundColor: const Color(0xFFB00020), colorText: Colors.white);
      return false;
    } finally {
      isSubmitting.value = false;
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
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pincodeCtrl.dispose();
    super.onClose();
  }
}
