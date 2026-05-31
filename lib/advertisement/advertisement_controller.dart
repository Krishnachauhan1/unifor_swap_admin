import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uniform_swap_admin/api_calls.dart';
class AdvertisementController extends GetxController {

  bool isLoading=false;
  final Set<String> deletingAdIds = <String>{};
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
    final res = await ApiService.get('all-ads');

    if (res['success'] == true) {
      advertisements = res['data'];
      update();
    }

    print(advertisements);
  }

  Future<void> deleteAdvertisement(String id) async {
    if (deletingAdIds.contains(id)) return;
    deletingAdIds.add(id);
    update();
    try {
      final res = await ApiService.patch('ads/$id/delete', {});

      if (res['success'] == true) {
        await getAdvertisements();
        Get.snackbar('Success', res['message'] ?? 'Advertisement deleted');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      deletingAdIds.remove(id);
      update();
    }
  }

  Future<void> addAdvertisement() async {
    loading();
    if (imageBytes == null) {
      Get.snackbar("Error", "Please upload image");
      loading();
      return;
    }

    // if (imageBytes!.length > 2 * 1024 * 1024) {
    //   Get.snackbar("Error", "Image must be less than 2MB");
    //   return;
    // }

    try {
      final res = await ApiService.postMultipart(
        'ads',
        fields: {
          'title': 'Advertisement',
          'description': urlController.text.trim().isNotEmpty
              ? urlController.text.trim()
              : 'Advertisement',
          if (urlController.text.trim().isNotEmpty)
            'url': urlController.text.trim(),
          'start_date': startDateController.text.trim(),
          'end_date': endDateController.text.trim(),
        },
        files: [
          http.MultipartFile.fromBytes(
            'image',
            imageBytes!,
            filename: 'ad_image.png',
            contentType: MediaType('image', 'png'),
          ),
        ],
      );

      if (res['success'] == true) {
        Get.snackbar('Success', res['message'] ?? 'Advertisement added');
        urlController.clear();
        startDateController.clear();
        endDateController.clear();
        imageBytes = null;
        await getAdvertisements();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Upload failed');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      loading();
      update();
    }
  }


}