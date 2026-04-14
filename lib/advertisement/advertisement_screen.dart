import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    controller.openAddDialog();
                  },
                  child: const Text("Add Advertisement"),
                ),
              ),
            ],
          ),
          body: Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(20),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
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
                              child:
                                  ad['image'] != null &&
                                      ad['image'].toString().isNotEmpty
                                  ? SizedBox(
                                      height: 80,
                                      width: 120,
                                      child: Image.network(
                                        ad['image'].toString(),
                                        height: 80,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        headers: const {
                                          'Access-Control-Allow-Origin': '*',
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                height: 80,
                                                width: 120,
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              print("IMAGE ERROR $error");
                                              return Container(
                                                height: 80,
                                                width: 120,
                                                color: Colors.grey.shade200,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      width: 120,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
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
                            ),
                          ],
                        ),
                      );
                    }, childCount: controller.advertisements.length),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
