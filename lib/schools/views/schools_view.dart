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
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: c.searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search schools...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.textHint),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFEEEEEE))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFEEEEEE))),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _showAddSchoolDialog(context, c),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add School'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
          ),

          // Schools list
          Expanded(
            child: Obx(() {
              final _ = c.schools.length;
              final __ = c.searchQuery.value;
              if (c.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary));
              }
              final schools = c.filteredSchools;
              if (c.filteredSchools.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('No schools found',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 15)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: c.fetchSchools,
                color: AppColors.primary,
                child: isWide
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: schools
                            .length, // filteredSchools ki jagah local variable
                        itemBuilder: (_, i) =>
                            _SchoolCard(school: schools[i], controller: c),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemCount: schools.length,
                        itemBuilder: (_, i) =>
                            _SchoolCard(school: schools[i], controller: c),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddSchoolDialog(BuildContext context, SchoolController c) {
    final formKey = GlobalKey<FormState>();
    Get.dialog(AlertDialog(
      title: const Text('Add New School'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: c.nameCtrl,
                decoration: const InputDecoration(labelText: 'School Name *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: c.addressCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: c.phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: c.emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
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
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child:
              const Text('Add School', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}

class _SchoolCard extends StatelessWidget {
  final SchoolModel school;
  final SchoolController controller;

  const _SchoolCard({required this.school, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  child: Text('🏫', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  school.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (school.address != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    school.address!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (school.phone != null) ...[
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(school.phone!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 4),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, size: 14),
                label: const Text('View'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, school, controller),
                icon: const Icon(Icons.delete_outline, size: 14),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, SchoolModel school, SchoolController controller) {
    Get.dialog(AlertDialog(
      title: const Text('Delete School'),
      content: Text('Are you sure you want to delete "${school.name}"?'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            controller.deleteSchool(school.id);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}
