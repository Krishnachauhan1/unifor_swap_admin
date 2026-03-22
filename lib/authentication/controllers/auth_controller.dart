import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/dashboard/dashboard_view.dart';
import 'package:uniform_swap_admin/products/views/add_product_view.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final emailCtrl = TextEditingController(text: 'krishan@gmail.com');
  final passwordCtrl = TextEditingController(text: '123456');

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  // Login with API
  Future<void> login() async {
    // Validation
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      // Debug prints
      print('🔥 Login API URL: $baseUrl$loginApi');
      print('📧 Email: ${emailCtrl.text.trim()}');
      print('🔑 Password: ${passwordCtrl.text}');

      // API Call
      final res = await ApiService.post(loginApi, {
        'email': emailCtrl.text.trim(),
        'password': passwordCtrl.text.trim(),
      });

      print('✅ API Response: $res');

      // Handle response
      if (res['success'] == true || res['token'] != null) {
        // Extract token and userId from response
        final token = res['token'] ?? res['data']?['token'] ?? '';
        final userId = res['data']?['id']?.toString() ??
            res['user']?['id']?.toString() ??
            '1';

        print('🎫 Token: $token');
        print('👤 User ID: $userId');

        // Save auth data
        await ApiService.saveAuthData(token: token, userId: userId);

        // Show success message
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );

        // Navigate to dashboard
        Get.offAll(() => const DashboardView());
      } else {
        // Login failed
        print('❌ Login failed: ${res['message']}');
        Get.snackbar(
          'Login Failed',
          res['message'] ?? 'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      // Handle errors
      print('💥 Login error: $e');
      Get.snackbar(
        'Error',
        'Login failed. Please check your credentials.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Demo login (bypass API for testing)
  void demoLogin() {
    Get.snackbar(
      'Demo Mode',
      'Logging in without API',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    Get.offAll(() => const DashboardView());
  }

  // Logout
  Future<void> logout() async {
    await ApiService.clearAuth();
    emailCtrl.clear();
    passwordCtrl.clear();
    Get.offAllNamed('/login');
  }
}
