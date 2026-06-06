import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/schools/controllers/school_controller.dart';
import 'package:uniform_swap_admin/schools/models/school_model.dart';
import 'package:uniform_swap_admin/schools/views/register_school_view.dart';

class SchoolsView extends StatelessWidget {
  const SchoolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SchoolController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
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
                              onPressed: openRegisterSchoolForm,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Register School'),
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
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: openRegisterSchoolForm,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Register School'),
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
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final schools = c.filteredSchools;

              if (schools.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No schools found',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: openRegisterSchoolForm,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Register First School'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
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
                    final isMobile = constraints.maxWidth < 600;

                    if (isMobile) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: schools.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            _SchoolCard(school: schools[i], controller: c),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 340,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: schools.length,
                      itemBuilder: (_, i) =>
                          _SchoolCard(school: schools[i], controller: c),
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
}

class _SchoolCard extends StatelessWidget {
  final SchoolModel school;
  final SchoolController controller;

  const _SchoolCard({required this.school, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasLogo = school.logo != null && school.logo!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasLogo
                    ? Image.network(
                        '$imageBaseUrl${school.logo}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('🏫', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    : const Center(
                        child: Text('🏫', style: TextStyle(fontSize: 20)),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (school.board != null && school.board!.isNotEmpty)
                      Text(
                        school.board!,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.primary),
                      ),
                  ],
                ),
              ),
              if (!school.isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Inactive',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (school.address != null && school.address!.isNotEmpty)
            _InfoRow(Icons.location_on_outlined, school.address!),
          if (school.locationLine != null)
            _InfoRow(Icons.map_outlined, school.locationLine!),
          if (school.phone != null && school.phone!.isNotEmpty)
            _InfoRow(Icons.phone_outlined, school.phone!),
          if (school.email != null && school.email!.isNotEmpty)
            _InfoRow(Icons.email_outlined, school.email!),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (school.isFeatured)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Featured',
                      style: TextStyle(fontSize: 10, color: AppColors.primary)),
                ),
              TextButton(
                onPressed: () =>
                    _confirmDelete(context, school, controller),
                child: const Text('Delete',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, SchoolModel school, SchoolController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete School'),
        content: Text('Delete "${school.name}"?'),
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
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
