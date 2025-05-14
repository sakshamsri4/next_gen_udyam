import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/admin/controllers/user_management_controller.dart';
import 'package:next_gen/app/modules/admin/models/user_filter_model.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/primary_button.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// User management view for admin users
class UserManagementView extends GetView<UserManagementController> {
  /// Creates a user management view
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'User Management',
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
          // User stats cards
          _buildUserStats(context),

          const SizedBox(height: 24),

          // Search and filter bar
          _buildSearchAndFilter(context),

          const SizedBox(height: 16),

          // User list or details
          Expanded(
            child: Obx(() {
              return controller.selectedUser.value == null
                  ? _buildUserList(context)
                  : _buildUserDetails(context, controller.selectedUser.value!);
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
          // Shimmer for stats cards
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < 2 ? 8.0 : 0,
                  ),
                  child: const ShimmerWidget.rectangular(
                    height: 100,
                    width: double.infinity,
                    borderRadius: 8,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Shimmer for search bar
          const ShimmerWidget.rectangular(
            height: 50,
            width: double.infinity,
            borderRadius: 8,
          ),

          const SizedBox(height: 16),

          // Shimmer for user list
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

  Widget _buildUserStats(BuildContext context) {
    const primaryColor = RoleThemes.adminPrimary;
    const accentColor = RoleThemes.adminAccent;

    return Row(
      children: [
        _buildStatCard(
          context,
          title: 'Total Users',
          value: controller.totalUsers.value.toString(),
          icon: HeroIcons.users,
          color: primaryColor,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          context,
          title: 'Active Users',
          value: controller.activeUsers.value.toString(),
          icon: HeroIcons.userCircle,
          color: Colors.green,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          context,
          title: 'New Users (30d)',
          value: controller.newUsers.value.toString(),
          icon: HeroIcons.userPlus,
          color: accentColor,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required HeroIcons icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HeroIcon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
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
              hintText: 'Search users by name or email',
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
              final currentFilter = controller.filter.value;
              controller.updateFilter(
                currentFilter.copyWith(searchQuery: value),
              );
            },
          ),

          const SizedBox(height: 16),

          // Filter options
          Row(
            children: [
              // User type filter
              Expanded(
                child: DropdownButtonFormField<UserType>(
                  decoration: InputDecoration(
                    labelText: 'User Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  hint: const Text('All Types'),
                  items: UserType.values.map((type) {
                    return DropdownMenuItem<UserType>(
                      value: type,
                      child: Text(
                        type.toString().split('.').last.capitalize!,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final currentFilter = controller.filter.value;
                    final userTypes = value != null ? [value] : <UserType>[];
                    controller.updateFilter(
                      currentFilter.copyWith(userTypes: userTypes),
                    );
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Verification status filter
              Expanded(
                child: DropdownButtonFormField<bool?>(
                  decoration: InputDecoration(
                    labelText: 'Verification Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  hint: const Text('All Statuses'),
                  items: const [
                    DropdownMenuItem<bool?>(
                      value: true,
                      child: Text('Verified'),
                    ),
                    DropdownMenuItem<bool?>(
                      value: false,
                      child: Text('Not Verified'),
                    ),
                  ],
                  onChanged: (value) {
                    final currentFilter = controller.filter.value;
                    controller.updateFilter(
                      currentFilter.copyWith(isVerified: value),
                    );
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Sort options
              Expanded(
                child: DropdownButtonFormField<UserSortOption>(
                  decoration: InputDecoration(
                    labelText: 'Sort By',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  value: controller.filter.value.sortBy,
                  items: UserSortOption.values.map((option) {
                    return DropdownMenuItem<UserSortOption>(
                      value: option,
                      child: Text(option.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final currentFilter = controller.filter.value;
                      controller.updateFilter(
                        currentFilter.copyWith(sortBy: value),
                      );
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
                onPressed: controller.resetFilter,
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
                onPressed: () => controller.loadUsers(),
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

  Widget _buildUserList(BuildContext context) {
    if (controller.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No users found',
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
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        final user = controller.users[index];
        return _buildUserCard(context, user);
      },
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user) {
    final userType = user.userType;
    final userTypeColor = userType == UserType.employee
        ? RoleThemes.employeePrimary
        : userType == UserType.employer
            ? RoleThemes.employerPrimary
            : RoleThemes.adminPrimary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => controller.selectUser(user),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // User avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: userTypeColor.withValues(alpha: 51),
                child: user.photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          user.photoUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: userTypeColor,
                              size: 24,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: userTypeColor,
                        size: 24,
                      ),
              ),

              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // User type badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: userTypeColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  userType?.toString().split('.').last.capitalize ?? 'Unknown',
                  style: TextStyle(
                    color: userTypeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Verification status
              Icon(
                user.emailVerified ? Icons.verified : Icons.warning,
                color: user.emailVerified ? Colors.green : Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, UserModel user) {
    final userType = user.userType;
    final userTypeColor = userType == UserType.employee
        ? RoleThemes.employeePrimary
        : userType == UserType.employer
            ? RoleThemes.employerPrimary
            : RoleThemes.adminPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: controller.clearSelectedUser,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to User List'),
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

        // User profile card
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
                    // User avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: userTypeColor.withValues(alpha: 51),
                      child: user.photoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                user.photoUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    color: userTypeColor,
                                    size: 40,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: userTypeColor,
                              size: 40,
                            ),
                    ),

                    const SizedBox(width: 24),

                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          if (user.phoneNumber != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user.phoneNumber!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: userTypeColor.withValues(alpha: 26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  userType
                                          ?.toString()
                                          .split('.')
                                          .last
                                          .capitalize ??
                                      'Unknown',
                                  style: TextStyle(
                                    color: userTypeColor,
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
                                  color: user.emailVerified
                                      ? Colors.green.withValues(alpha: 26)
                                      : Colors.orange.withValues(alpha: 26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      user.emailVerified
                                          ? Icons.verified
                                          : Icons.warning,
                                      size: 16,
                                      color: user.emailVerified
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      user.emailVerified
                                          ? 'Verified'
                                          : 'Not Verified',
                                      style: TextStyle(
                                        color: user.emailVerified
                                            ? Colors.green
                                            : Colors.orange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // User actions
                Row(
                  children: [
                    // Change role button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showChangeRoleDialog(context, user);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Change Role'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Send verification email button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO(developer): Implement send verification email
                          Get.snackbar(
                            'Verification Email',
                            'Verification email sent to ${user.email}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        icon: const Icon(Icons.email),
                        label: const Text('Send Verification Email'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Reset password button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO(developer): Implement reset password
                          Get.snackbar(
                            'Reset Password',
                            'Password reset email sent to ${user.email}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                          );
                        },
                        icon: const Icon(Icons.lock_reset),
                        label: const Text('Reset Password'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Activity log
        Text(
          'Activity Log',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        const SizedBox(height: 16),

        // Activity log list
        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              if (controller.activityLogs.isEmpty) {
                return const Center(
                  child: Text('No activity logs found'),
                );
              }

              return ListView.builder(
                itemCount: controller.activityLogs.length,
                itemBuilder: (context, index) {
                  final log = controller.activityLogs[index];
                  return ListTile(
                    leading: _getActivityIcon(log.action),
                    title: Text(log.action),
                    subtitle: Text(
                      log.details?['message'] as String? ?? '',
                    ),
                    trailing: Text(
                      log.timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _getActivityIcon(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return const Icon(Icons.login, color: Colors.blue);
      case 'profile update':
        return const Icon(Icons.edit, color: Colors.green);
      case 'job application':
        return const Icon(Icons.work, color: Colors.orange);
      default:
        return const Icon(Icons.info, color: Colors.grey);
    }
  }

  void _showChangeRoleDialog(BuildContext context, UserModel user) {
    var selectedRole = user.userType;

    Get.dialog<void>(
      AlertDialog(
        title: const Text('Change User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current role: ${user.userType?.toString().split('.').last.capitalize ?? 'None'}',
            ),
            const SizedBox(height: 16),
            const Text('Select new role:'),
            const SizedBox(height: 8),
            ...UserType.values.map((role) {
              return RadioListTile<UserType>(
                title: Text(role.toString().split('.').last.capitalize!),
                value: role,
                groupValue: selectedRole,
                onChanged: (value) {
                  selectedRole = value;
                  Get.back<void>();
                  _showChangeRoleDialog(context, user);
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            onPressed: () {
              if (selectedRole != null && selectedRole != user.userType) {
                controller.updateUserRole(user.uid, selectedRole!);
                Get.back();
                Get.snackbar(
                  'Role Updated',
                  'User role updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.back();
              }
            },
            text: 'Update Role',
          ),
        ],
      ),
    );
  }
}
