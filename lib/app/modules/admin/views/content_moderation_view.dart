import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/admin/controllers/content_moderation_controller.dart';
import 'package:next_gen/app/modules/admin/models/moderation_item_model.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/primary_button.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Content moderation view for admin users
class ContentModerationView extends GetView<ContentModerationController> {
  /// Creates a content moderation view
  const ContentModerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'Content Moderation',
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
          // Search and filter bar
          _buildSearchAndFilter(context),

          const SizedBox(height: 16),

          // Content list or details
          Expanded(
            child: Obx(() {
              return controller.selectedItem.value == null
                  ? _buildModerationQueue(context)
                  : _buildItemDetails(context, controller.selectedItem.value!);
            }),
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
            height: 120,
            width: double.infinity,
            borderRadius: 8,
          ),

          const SizedBox(height: 16),

          // Shimmer for content list
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
              hintText: 'Search by title, submitter, or reason',
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

          // Filter options
          Row(
            children: [
              // Type filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Content Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  value: controller.typeFilter.value,
                  items: controller.availableTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.typeFilter.value = value;
                    }
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Priority filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  value: controller.priorityFilter.value,
                  items: controller.availablePriorities.map((priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.priorityFilter.value = value;
                    }
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Status filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  value: controller.statusFilter.value,
                  items: controller.availableStatuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.statusFilter.value = value;
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Filter actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  controller.typeFilter.value = 'All';
                  controller.priorityFilter.value = 'All';
                  controller.statusFilter.value = 'All';
                  controller.searchQuery.value = '';
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Filters'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => controller.loadModerationQueue(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RoleThemes.adminPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModerationQueue(BuildContext context) {
    if (controller.moderationQueue.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No items in moderation queue',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All content has been reviewed',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.moderationQueue.length,
      itemBuilder: (context, index) {
        final item = controller.moderationQueue[index];
        return _buildModerationItem(context, item);
      },
    );
  }

  Widget _buildModerationItem(BuildContext context, ModerationItem item) {
    Color statusColor;
    switch (item.status) {
      case 'Pending':
        statusColor = Colors.orange;
      case 'Approved':
        statusColor = Colors.green;
      case 'Rejected':
        statusColor = Colors.red;
      case 'Needs Info':
        statusColor = Colors.blue;
      default:
        statusColor = Colors.grey;
    }

    Color priorityColor;
    switch (item.priority) {
      case 'Low':
        priorityColor = Colors.green;
      case 'Medium':
        priorityColor = Colors.blue;
      case 'High':
        priorityColor = Colors.orange;
      case 'Urgent':
        priorityColor = Colors.red;
      default:
        priorityColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => controller.selectItem(item),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Content type icon
              CircleAvatar(
                radius: 24,
                backgroundColor: RoleThemes.adminPrimary.withOpacity(0.1),
                child: _getContentTypeIcon(item.type),
              ),

              const SizedBox(width: 16),

              // Content info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submitted by ${item.submittedBy} • ${item.submissionTimeAgo}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    if (item.reason != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.reason!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Status and priority
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.priority,
                      style: TextStyle(
                        color: priorityColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetails(BuildContext context, ModerationItem item) {
    Color statusColor;
    switch (item.status) {
      case 'Pending':
        statusColor = Colors.orange;
      case 'Approved':
        statusColor = Colors.green;
      case 'Rejected':
        statusColor = Colors.red;
      case 'Needs Info':
        statusColor = Colors.blue;
      default:
        statusColor = Colors.grey;
    }

    Color priorityColor;
    switch (item.priority) {
      case 'Low':
        priorityColor = Colors.green;
      case 'Medium':
        priorityColor = Colors.blue;
      case 'High':
        priorityColor = Colors.orange;
      case 'Urgent':
        priorityColor = Colors.red;
      default:
        priorityColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: controller.clearSelectedItem,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Queue'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Item details card
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content type icon
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          RoleThemes.adminPrimary.withValues(alpha: 26),
                      child: _getContentTypeIcon(item.type, size: 32),
                    ),

                    const SizedBox(width: 24),

                    // Content info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Submitted by ${item.submittedBy}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Submitted ${item.submissionTimeAgo}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  item.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: priorityColor.withValues(alpha: 26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  item.priority,
                                  style: TextStyle(
                                    color: priorityColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: RoleThemes.adminPrimary
                                      .withValues(alpha: 26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  item.type,
                                  style: const TextStyle(
                                    color: RoleThemes.adminPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (item.reason != null) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Reason for Moderation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.reason!,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],

                if (item.notes != null) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Review Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.notes!,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],

                if (item.reviewedBy != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Reviewed by ${item.reviewedBy} on ${_formatDate(item.reviewedAt!)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action buttons
                if (item.status == 'Pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showRejectDialog(context, item);
                          },
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text('Reject'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showRequestInfoDialog(context, item);
                          },
                          icon: const Icon(Icons.info, color: Colors.blue),
                          label: const Text('Request Info'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.approveItem(item.id);
                            Get.snackbar(
                              'Content Approved',
                              'The content has been approved',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // View content button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO(developer): Implement view content functionality
                        Get.snackbar(
                          'View Content',
                          'Viewing content with ID: ${item.contentId}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Content'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getContentTypeIcon(String type, {double size = 24}) {
    switch (type) {
      case 'Job Posting':
        return HeroIcon(
          HeroIcons.briefcase,
          color: RoleThemes.adminPrimary,
          size: size,
        );
      case 'User Profile':
        return HeroIcon(
          HeroIcons.user,
          color: RoleThemes.adminPrimary,
          size: size,
        );
      case 'Company Profile':
        return HeroIcon(
          HeroIcons.buildingOffice2,
          color: RoleThemes.adminPrimary,
          size: size,
        );
      case 'User Report':
        return HeroIcon(
          HeroIcons.flag,
          color: RoleThemes.adminPrimary,
          size: size,
        );
      default:
        return HeroIcon(
          HeroIcons.document,
          color: RoleThemes.adminPrimary,
          size: size,
        );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showRejectDialog(BuildContext context, ModerationItem item) {
    final reasonController = TextEditingController();

    Get.dialog<void>(
      AlertDialog(
        title: const Text('Reject Content'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter reason for rejection',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                controller.rejectItem(item.id, reason: reason);
                Get
                  ..back<void>()
                  ..snackbar(
                    'Content Rejected',
                    'The content has been rejected',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
              } else {
                Get.snackbar(
                  'Error',
                  'Please provide a reason for rejection',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            text: 'Reject',
          ),
        ],
      ),
    );
  }

  void _showRequestInfoDialog(BuildContext context, ModerationItem item) {
    final messageController = TextEditingController();

    Get.dialog<void>(
      AlertDialog(
        title: const Text('Request More Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please specify what additional information is needed:'),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Enter your request',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            onPressed: () {
              final message = messageController.text.trim();
              if (message.isNotEmpty) {
                controller.requestMoreInfo(item.id, message: message);
                Get
                  ..back<void>()
                  ..snackbar(
                    'Request Sent',
                    'Request for more information has been sent',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
              } else {
                Get.snackbar(
                  'Error',
                  'Please specify what information is needed',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            text: 'Send Request',
          ),
        ],
      ),
    );
  }
}
