import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/schools/controllers/school_controller.dart';
import 'package:uniform_swap_admin/schools/models/school_model.dart';

class SchoolsView extends StatelessWidget {
  const SchoolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SchoolController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [

          /// 🔹 HEADER (RESPONSIVE)
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: isMobile
                    ? Column(
                  children: [
                    TextField(
                      controller: c.searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search schools...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showAddSchoolDialog(context, c),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add School'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c.searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search schools...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showAddSchoolDialog(context, c),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add School'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          /// 🔹 BODY
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary),
                );
              }

              final schools = c.filteredSchools;

              if (schools.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined,
                          size: 64,
                          color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No schools found',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: c.fetchSchools,
                color: AppColors.primary,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile =
                        constraints.maxWidth < 600;

                    /// 📱 MOBILE → LIST
                    if (isMobile) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: schools.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            _SchoolCard(
                                school: schools[i],
                                controller: c),
                      );
                    }

                    /// 💻 WEB/TABLET → GRID
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 320,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: schools.length,
                      itemBuilder: (_, i) => _SchoolCard(
                          school: schools[i],
                          controller: c),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 🔹 ADD SCHOOL DIALOG (RESPONSIVE)
  void _showAddSchoolDialog(
      BuildContext context, SchoolController c) {
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New School'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width > 600
              ? 480
              : double.infinity,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: c.nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'School Name *'),
                  validator: (v) =>
                  v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: c.addressCtrl,
                  decoration:
                  const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: c.phoneCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Phone'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: c.emailCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Email'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                c.addSchool({
                  'name': c.nameCtrl.text,
                  'address': c.addressCtrl.text,
                  'phone': c.phoneCtrl.text,
                  'email': c.emailCtrl.text,
                });

                c.nameCtrl.clear();
                c.addressCtrl.clear();
                c.phoneCtrl.clear();
                c.emailCtrl.clear();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Add School',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// 🔹 SCHOOL CARD
class _SchoolCard extends StatelessWidget {
  final SchoolModel school;
  final SchoolController controller;

  const _SchoolCard(
      {required this.school, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('🏫',
                      style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  school.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (school.address != null)
            Text(
              school.address!,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 10),

          if (school.phone != null)
            Text(
              school.phone!,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary),
            ),

          const SizedBox(height: 10),

          /// ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("View"),
              ),
              TextButton(
                onPressed: () =>
                    _confirmDelete(context, school, controller),
                child: const Text("Delete",
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context,
      SchoolModel school,
      SchoolController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete School'),
        content:
        Text('Delete "${school.name}"?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteSchool(school.id);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}