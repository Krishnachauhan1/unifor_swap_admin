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

        final width = MediaQuery.of(context).size.width;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1024;
        final isDesktop = width >= 1024;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Advertisement"),
          ),

          body: Center(
            child: Container(
              width: isDesktop
                  ? 900
                  : isTablet
                  ? 700
                  : double.infinity,

              padding: EdgeInsets.all(isMobile ? 12 : 20),

              child: Column(
                children: [

                  /// ================= LIST =================
                  Expanded(
                    child: controller.advertisements.isEmpty
                        ? const Center(child: Text("No Ads Found"))
                        : ListView.builder(
                      itemCount: controller.advertisements.length,
                      itemBuilder: (context, index) {

                        final ad = controller.advertisements[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(isMobile ? 10 : 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: isMobile
                              ? _mobileCard(ad,controller)
                              : _webCard(ad),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= FORM =================
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// IMAGE
                          const Text("Advertisement Image"),
                          const SizedBox(height: 10),

                          GestureDetector(
                            onTap: () async {
                              FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );

                              if (result != null) {
                                controller.imageBytes =
                                    result.files.first.bytes;
                                controller.update();
                              }
                            },
                            child: Container(
                              height: isMobile ? 150 : 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: controller.imageBytes == null
                                  ? const Center(
                                  child: Text("Click to Upload Image"))
                                  : Image.memory(
                                controller.imageBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// DATES (Responsive Row)
                          isMobile
                              ? Column(
                            children: [
                              _dateField(
                                  "Start Date",
                                  controller.startDateController,
                                  context),
                              const SizedBox(height: 15),
                              _dateField(
                                  "End Date",
                                  controller.endDateController,
                                  context),
                            ],
                          )
                              : Row(
                            children: [
                              Expanded(
                                child: _dateField(
                                    "Start Date",
                                    controller.startDateController,
                                    context),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _dateField(
                                    "End Date",
                                    controller.endDateController,
                                    context),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// URL
                          const Text("Redirect URL"),
                          const SizedBox(height: 8),

                          TextField(
                            controller: controller.urlController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter URL",
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                controller.addAdvertisement();
                              },
                              child: controller.isLoading
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const Text("Add Advertisement"),
                            ),
                          ),
                        ],
                      ),
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

  /// ================= MOBILE CARD =================
  Widget _mobileCard(Map ad,AdvertisementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ad['image'] != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              ad['image'],
              errorBuilder: (context, error, stackTrace) => Text('Image not available'),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

        const SizedBox(height: 10),

        Text(ad['title'] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold)),

        Text(ad['description'] ?? ""),

        const SizedBox(height: 5),

        Text("Start: ${ad['start_date'] ?? "-"}"),
        Text("End: ${ad['end_date'] ?? "-"}"),
        ElevatedButton.icon(onPressed: (){
          print(ad['id']);
          controller.deleteAdvertisement(ad['id'].toString());
        }, label: Text("Delete"),icon: Icon(Icons.delete_forever,color: Colors.red,),)
      ],
    );
  }

  /// ================= WEB CARD =================
  Widget _webCard(Map ad) {
    return Row(
      children: [

        /// IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ad['image'] != null
              ? Image.network(
            ad['image'],
            errorBuilder: (context, error, stackTrace) => Text('Image not available'),
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
              Text(ad['title'] ?? "",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(ad['description'] ?? ""),
              Text("Start: ${ad['start_date'] ?? "-"}"),
              Text("End: ${ad['end_date'] ?? "-"}"),
            ],
          ),
        ),

        /// STATUS
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(ad['status'] ?? ""),
        )
      ],
    );
  }

  /// ================= DATE FIELD =================
  Widget _dateField(
      String label, TextEditingController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime(2030),
              initialDate: DateTime.now(),
            );

            if (picked != null) {
              controller.text = picked.toString().split(" ")[0];
            }
          },
        ),
      ],
    );
  }
}