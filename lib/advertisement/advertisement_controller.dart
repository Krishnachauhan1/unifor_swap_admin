import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uniform_swap_admin/api_calls.dart';

class AdvertisementController extends GetxController {
  bool isLoading = false;
  Uint8List? imageBytes;
  List advertisements = [];
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  void loading() {
    isLoading = !isLoading;
    update();
  }

  @override
  void onInit() {
    getAdvertisements();
    super.onInit();
  }

  Future<void> getAdvertisements() async {
    try {
      final res = await ApiService.get('ads');
      if (res['success'] == true) {
        advertisements = res['data'];
        update();
      }
      print(advertisements);
    } catch (e) {
      print("ADVERTISEMENT ERROR $e");
    }
  }

  Future<void> addAdvertisement() async {
    final token = await ApiService.getToken();
    print("TOKEN CHECK '$token'");

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Session expired, please login again");
      return;
    }
    if (imageBytes == null) {
      Get.snackbar("Error", "Please upload image");
      return;
    }
    if (startDateController.text.isEmpty) {
      Get.snackbar("Error", "Please select start date");
      return;
    }
    if (endDateController.text.isEmpty) {
      Get.snackbar("Error", "Please select end date");
      return;
    }
    DateTime startDate = DateTime.parse(startDateController.text);
    DateTime endDate = DateTime.parse(endDateController.text);
    if (!endDate.isAfter(startDate)) {
      Get.snackbar("Error", "End date must be after start date");
      return;
    }
    loading();
    try {
      final response = await ApiService.postMultipart(
        'ads',
        fields: {
          'title': 'Advertisement',
          'description': urlController.text,
          'url': urlController.text,
          'price': '0',
          'location': 'Delhi',
          'start_date': startDateController.text,
          'end_date': endDateController.text,
        },
        files: [
          http.MultipartFile.fromBytes(
            'image',
            imageBytes!,
            filename: 'ad_image.png',
          ),
        ],
      );

      print("ADVERTISEMENT RESPONSE : $response");
      Get.snackbar("Success", "Advertisement Added");
      imageBytes = null;
      startDateController.clear();
      endDateController.clear();
      urlController.clear();

      await getAdvertisements();
    } catch (e) {
      print("Error $e");
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""));
    } finally {
      loading();
      update();
    }
  }
}
