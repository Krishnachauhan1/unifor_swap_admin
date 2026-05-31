import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/instructions/instruction_controller.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstructionController>(
      init: InstructionController(),
      builder: (controller) {
        final isMobile = MediaQuery.of(context).size.width < 768;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: isMobile
              ? _mobileLayout(controller)
              : _desktopLayout(controller),
        );
      },
    );
  }

  Widget _desktopLayout(InstructionController controller) {
    return Row(
      children: [
        Expanded(flex: 5, child: _listPanel(controller)),
        const VerticalDivider(width: 1),
        Expanded(flex: 4, child: _formPanel(controller)),
      ],
    );
  }

  Widget _mobileLayout(InstructionController controller) {
    return Column(
      children: [
        Expanded(child: _listPanel(controller)),
        const Divider(height: 1),
        SizedBox(height: 320, child: _formPanel(controller)),
      ],
    );
  }

  Widget _listPanel(InstructionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Instructions List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text('Total: ${controller.instructions.length}'),
            ],
          ),
        ),
        Expanded(
          child: controller.isLoading && controller.instructions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : controller.instructions.isEmpty
                  ? const Center(child: Text('No instructions added yet'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.instructions.length,
                      itemBuilder: (context, index) {
                        final item = controller.instructions[index];
                        final isActive = item['is_active'] == true ||
                            item['is_active'] == 1;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              item['title']?.toString() ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              item['content']?.toString() ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Chip(
                                  label: Text(
                                    isActive ? 'Active' : 'Hidden',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  backgroundColor: isActive
                                      ? Colors.green.shade100
                                      : Colors.grey.shade200,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => controller.startEdit(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => controller.deleteInstruction(
                                      item['id'] as int),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _formPanel(InstructionController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.editingId == null
                ? 'Add Instruction'
                : 'Edit Instruction',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.titleCtrl,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.contentCtrl,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Instruction Content',
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.sortOrderCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Sort Order',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show in mobile app'),
            value: controller.isActive,
            activeColor: AppColors.primary,
            onChanged: (value) {
              controller.isActive = value;
              controller.update();
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.isLoading
                      ? null
                      : controller.saveInstruction,
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(controller.editingId == null ? 'Add' : 'Update'),
                ),
              ),
              if (controller.editingId != null) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: controller.clearForm,
                  child: const Text('Cancel'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
