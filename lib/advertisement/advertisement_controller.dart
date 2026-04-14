import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/app_colors.dart';

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

  void openAddDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Add Advertisement",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                /// IMAGE
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      imageBytes = result.files.first.bytes;
                      update();
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all()),
                    child: imageBytes == null
                        ? const Center(child: Text("Upload Image"))
                        : Image.memory(imageBytes!, fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 20),

                /// START DATE
                TextField(
                  controller: startDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Start Date",
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: Get.context!,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                      initialDate: DateTime.now(),
                    );
                    if (picked != null) {
                      startDateController.text = picked.toString().split(
                        " ",
                      )[0];
                    }
                  },
                ),

                const SizedBox(height: 15),

                /// END DATE
                TextField(
                  controller: endDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "End Date",
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: Get.context!,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                      initialDate: DateTime.now(),
                    );
                    if (picked != null) {
                      endDateController.text = picked.toString().split(" ")[0];
                    }
                  },
                ),

                const SizedBox(height: 15),

                /// URL
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter URL",
                  ),
                ),

                const SizedBox(height: 25),

                /// SUBMIT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      addAdvertisement();
                      Get.back();
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
