import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uniform_swap_admin/advertisement/advertisement_controller.dart';
import 'package:uniform_swap_admin/app_colors.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(
      init: AdvertisementController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Advertisement"),
          ),
          body: Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.advertisements.length,
                    itemBuilder: (context, index) {

                      final ad = controller.advertisements[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [

                            /// IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ad['image'] != null
                                  ? Image.network(
                                ad['image'],
                                height: 80,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                height: 80,
                                width: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image),
                              ),
                            ),

                            const SizedBox(width: 15),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    ad['title'] ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(ad['description'] ?? ""),

                                  const SizedBox(height: 5),

                                  Text(
                                    "Start: ${ad['start_date'] ?? "-"}",
                                    style: const TextStyle(fontSize: 12),
                                  ),

                                  Text(
                                    "End: ${ad['end_date'] ?? "-"}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),

                            /// STATUS
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ad['status'] ?? "",
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),

                  /// IMAGE FIELD
                  const Text("Advertisement Image"),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );

                      if (result != null) {
                        controller.imageBytes = result.files.first.bytes;
                        controller.update();
                      }
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.imageBytes == null
                          ? const Center(child: Text("Click to Upload Image"))
                          : Image.memory(controller.imageBytes!,
                          fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// START DATE
                  const Text("Start Date"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Select start date",
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                        initialDate: DateTime.now(),
                      );

                      if (picked != null) {
                        controller.startDateController.text =
                        picked.toString().split(" ")[0];
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  /// END DATE
                  const Text("End Date"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Select end date",
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                        initialDate: DateTime.now(),
                      );

                      if (picked != null) {
                        controller.endDateController.text =
                        picked.toString().split(" ")[0];
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  /// URL FIELD
                  const Text("Redirect URL"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.urlController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter URL",
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        controller.addAdvertisement();
                      },
                      child: controller.isLoading?Center(child: CircularProgressIndicator(),): Text("Add Advertisement"),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}