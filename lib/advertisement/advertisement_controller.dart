import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';

class AdvertisementController extends GetxController {

  bool isLoading=false;
  Uint8List? imageBytes;
  List advertisements = [];
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController urlController = TextEditingController();


  void loading(){
    isLoading=!isLoading;
    update();
  }
  @override
  void onInit() {
    getAdvertisements();
    super.onInit();
  }
  Future<void> getAdvertisements() async {
    final res = await ApiService.get('ads');

    if (res['success'] == true) {
      advertisements = res['data'];
      update();
    }

    print(advertisements);
  }

  Future<void> deleteAdvertisement(String id) async {
    final res = await ApiService.get('ads/$id/delete');

    if (res['success'] == true) {
      getAdvertisements();
      update();
    }

    print(res);
  }

  Future<void> addAdvertisement() async {
    loading();
    if (imageBytes == null) {
      Get.snackbar("Error", "Please upload image");
      return;
    }

    // if (imageBytes!.length > 2 * 1024 * 1024) {
    //   Get.snackbar("Error", "Image must be less than 2MB");
    //   return;
    // }

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/ads"),
      );

      final token = await ApiService.getToken();

      request.headers['Authorization'] = "Bearer $token";

      request.fields['title'] = "Advertisement";
      request.fields['description'] = urlController.text;
      request.fields['price'] = "0";
      request.fields['location'] = "Delhi";
      request.fields['start_date'] = startDateController.text;
      request.fields['end_date'] = endDateController.text;

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes!,
          filename: "ad_image.png",
        ),
      );

      var response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Advertisement Added");
      } else {
        Get.snackbar("Error", "Upload failed");
      }

    } catch (e) {
      print(e);
      Get.snackbar("Error", "Something went wrong");
    }finally{
      loading();
      update();
    }
  }


}