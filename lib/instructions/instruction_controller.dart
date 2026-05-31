import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';

class InstructionController extends GetxController {
  bool isLoading = false;
  List<Map<String, dynamic>> instructions = [];

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final sortOrderCtrl = TextEditingController(text: '0');
  bool isActive = true;
  int? editingId;

  @override
  void onInit() {
    super.onInit();
    fetchInstructions();
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    contentCtrl.dispose();
    sortOrderCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchInstructions() async {
    try {
      isLoading = true;
      update();

      final res = await ApiService.get(allInstructionsApi);
      if (res['success'] == true) {
        instructions = List<Map<String, dynamic>>.from(res['data'] ?? []);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  void startEdit(Map<String, dynamic> instruction) {
    editingId = instruction['id'];
    titleCtrl.text = instruction['title']?.toString() ?? '';
    contentCtrl.text = instruction['content']?.toString() ?? '';
    sortOrderCtrl.text = instruction['sort_order']?.toString() ?? '0';
    isActive = instruction['is_active'] == true || instruction['is_active'] == 1;
    update();
  }

  void clearForm() {
    editingId = null;
    titleCtrl.clear();
    contentCtrl.clear();
    sortOrderCtrl.text = '0';
    isActive = true;
    update();
  }

  Future<void> saveInstruction() async {
    if (titleCtrl.text.trim().isEmpty || contentCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Title and content are required');
      return;
    }

    final body = {
      'title': titleCtrl.text.trim(),
      'content': contentCtrl.text.trim(),
      'is_active': isActive,
      'sort_order': int.tryParse(sortOrderCtrl.text.trim()) ?? 0,
    };

    try {
      isLoading = true;
      update();

      final res = editingId == null
          ? await ApiService.post(instructionsApi, body)
          : await ApiService.put('$instructionsApi/$editingId', body);

      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Instruction saved',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
        await fetchInstructions();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Failed to save instruction');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteInstruction(int id) async {
    try {
      final res = await ApiService.delete('$instructionsApi/$id');
      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Instruction deleted',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        if (editingId == id) clearForm();
        await fetchInstructions();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> toggleActive(Map<String, dynamic> instruction) async {
    try {
      final res = await ApiService.put('$instructionsApi/${instruction['id']}', {
        'is_active': !(instruction['is_active'] == true || instruction['is_active'] == 1),
      });

      if (res['success'] == true) {
        await fetchInstructions();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
