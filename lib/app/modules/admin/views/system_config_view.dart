import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/controllers/system_config_controller.dart';
import 'package:next_gen/app/modules/admin/models/system_config_model.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// System configuration view for admin users
class SystemConfigView extends GetView<SystemConfigController> {
  /// Creates a system configuration view
  const SystemConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'System Configuration',
      body: Obx(() {
        return controller.isLoading.value
            ? _buildLoadingState(context)
            : _buildContent(context);
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and category filter
          _buildSearchAndFilter(context),

          const SizedBox(height: 24),

          // Configuration items
          Expanded(
            child: _buildConfigItems(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer for search bar
          const ShimmerWidget.rectangular(
            height: 80,
            width: double.infinity,
            borderRadius: 8,
          ),

          const SizedBox(height: 24),

          // Shimmer for config items
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ShimmerWidget.rectangular(
                    height: 80,
                    width: double.infinity,
                    borderRadius: 8,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 26),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search configuration settings',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
            onChanged: (value) {
              controller.searchQuery.value = value;
            },
          ),

          const SizedBox(height: 16),

          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(context, 'all', 'All'),
                ...controller.categories.map((category) {
                  return _buildCategoryChip(
                    context,
                    category,
                    category.capitalize!,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String value, String label) {
    final isSelected = controller.selectedCategory.value == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          if (selected) {
            controller.selectedCategory.value = value;
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: RoleThemes.adminPrimary.withValues(alpha: 51),
        checkmarkColor: RoleThemes.adminPrimary,
        labelStyle: TextStyle(
          color: isSelected ? RoleThemes.adminPrimary : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildConfigItems(BuildContext context) {
    if (controller.configItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.settings,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No configuration items found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.configItems.length,
      itemBuilder: (context, index) {
        final item = controller.configItems[index];
        return _buildConfigItem(context, item);
      },
    );
  }

  Widget _buildConfigItem(BuildContext context, SystemConfigModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: RoleThemes.adminPrimary.withValues(alpha: 26),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.category.capitalize!,
                    style: const TextStyle(
                      color: RoleThemes.adminPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Value editor based on data type
            _buildValueEditor(context, item),

            const SizedBox(height: 8),

            // Last updated info
            if (item.lastUpdated != null) ...[
              Text(
                'Last updated: ${_formatDate(item.lastUpdated!)}${item.updatedBy != null ? ' by ${item.updatedBy}' : ''}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueEditor(BuildContext context, SystemConfigModel item) {
    switch (item.dataType) {
      case 'boolean':
        return Row(
          children: [
            Expanded(
              child: Text(
                'Value:',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Obx(() {
              return Switch(
                value: controller.isSaving.value
                    ? item.value as bool
                    : item.getTypedValue() as bool,
                onChanged: (value) {
                  if (!controller.isSaving.value) {
                    controller.updateConfigItem(item.id, value);
                  }
                },
                activeColor: RoleThemes.adminPrimary,
              );
            }),
          ],
        );
      case 'number':
        return Row(
          children: [
            Expanded(
              child: Text(
                'Value:',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: TextEditingController(
                  text: item.value.toString(),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onSubmitted: (value) {
                  final numValue = int.tryParse(value) ?? item.value as int;
                  controller.updateConfigItem(item.id, numValue);
                },
                enabled: !controller.isSaving.value,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.isSaving.value
                  ? null
                  : () => controller.resetConfigItem(item.id),
              tooltip: 'Reset to default',
              color: Colors.grey[600],
            ),
          ],
        );
      default: // string
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(
                  text: item.value.toString(),
                ),
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.isSaving.value
                        ? null
                        : () => controller.resetConfigItem(item.id),
                    tooltip: 'Reset to default',
                  ),
                ),
                onSubmitted: (value) {
                  controller.updateConfigItem(item.id, value);
                },
                enabled: !controller.isSaving.value,
              ),
            ),
          ],
        );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
