import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/models/system_config_model.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for system configuration
class SystemConfigController extends GetxController {
  /// Constructor
  SystemConfigController({
    required this.loggerService,
  });

  /// Logger service
  final LoggerService loggerService;

  /// Auth controller for current user info
  final AuthController _authController = Get.find<AuthController>();

  // Firestore instance will be used in future implementations

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Saving state
  final RxBool isSaving = false.obs;

  /// Configuration items
  final RxList<SystemConfigModel> configItems = <SystemConfigModel>[].obs;

  /// Selected category
  final RxString selectedCategory = 'general'.obs;

  /// Available categories
  final RxList<String> categories = <String>[
    'general',
    'security',
    'notifications',
    'jobs',
    'users',
  ].obs;

  /// Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadConfig();

    // Set up listeners for filter changes
    ever(selectedCategory, (_) => loadConfig());
    debounce(
      searchQuery,
      (_) => loadConfig(),
      time: const Duration(milliseconds: 500),
    );
  }

  /// Load configuration from Firestore
  Future<void> loadConfig() async {
    try {
      isLoading.value = true;
      loggerService.i('Loading system configuration');

      // In a real app, this would fetch from Firestore
      // For now, we'll use mock data
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Create mock data
      final allItems = [
        SystemConfigModel(
          id: 'site_name',
          name: 'Site Name',
          value: 'Next Gen Udyam',
          category: 'general',
          description: 'The name of the site displayed in the header and title',
          lastUpdated: DateTime.now().subtract(const Duration(days: 30)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'maintenance_mode',
          name: 'Maintenance Mode',
          value: false,
          category: 'general',
          description:
              'Enable maintenance mode to show a maintenance page to users',
          dataType: 'boolean',
          lastUpdated: DateTime.now().subtract(const Duration(days: 10)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'max_file_size',
          name: 'Maximum File Size (MB)',
          value: 10,
          category: 'general',
          description: 'Maximum file size for uploads in megabytes',
          dataType: 'number',
          lastUpdated: DateTime.now().subtract(const Duration(days: 15)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'password_min_length',
          name: 'Minimum Password Length',
          value: 8,
          category: 'security',
          description: 'Minimum number of characters required for passwords',
          dataType: 'number',
          lastUpdated: DateTime.now().subtract(const Duration(days: 60)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'require_email_verification',
          name: 'Require Email Verification',
          value: true,
          category: 'security',
          description:
              'Require users to verify their email before accessing the site',
          dataType: 'boolean',
          lastUpdated: DateTime.now().subtract(const Duration(days: 45)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'email_notifications',
          name: 'Email Notifications',
          value: true,
          category: 'notifications',
          description: 'Send email notifications to users',
          dataType: 'boolean',
          lastUpdated: DateTime.now().subtract(const Duration(days: 20)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'job_auto_expire',
          name: 'Auto-Expire Jobs (days)',
          value: 30,
          category: 'jobs',
          description:
              'Number of days after which job postings are automatically expired',
          dataType: 'number',
          lastUpdated: DateTime.now().subtract(const Duration(days: 25)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'max_active_jobs',
          name: 'Maximum Active Jobs per Employer',
          value: 10,
          category: 'jobs',
          description:
              'Maximum number of active job postings allowed per employer',
          dataType: 'number',
          lastUpdated: DateTime.now().subtract(const Duration(days: 35)),
          updatedBy: 'Admin',
        ),
        SystemConfigModel(
          id: 'user_inactivity_threshold',
          name: 'User Inactivity Threshold (days)',
          value: 90,
          category: 'users',
          description:
              'Number of days of inactivity after which users are marked as inactive',
          dataType: 'number',
          lastUpdated: DateTime.now().subtract(const Duration(days: 40)),
          updatedBy: 'Admin',
        ),
      ];

      // Filter by category
      final filteredItems = allItems.where((item) {
        // Filter by category
        if (selectedCategory.value != 'all' &&
            item.category != selectedCategory.value) {
          return false;
        }

        // Filter by search query
        if (searchQuery.value.isNotEmpty) {
          final query = searchQuery.value.toLowerCase();
          return item.name.toLowerCase().contains(query) ||
              (item.description != null &&
                  item.description!.toLowerCase().contains(query));
        }

        return true;
      }).toList();

      configItems.value = filteredItems;
      loggerService.d('Loaded ${configItems.length} configuration items');
    } catch (e, stackTrace) {
      loggerService.e('Error loading configuration', e, stackTrace);
      configItems.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Update a configuration item
  Future<void> updateConfigItem(String id, dynamic newValue) async {
    try {
      isSaving.value = true;
      loggerService.i('Updating configuration item: $id');

      // In a real app, this would update Firestore
      // For now, we'll just update the local state
      final index = configItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = configItems[index];
        final updatedItem = item.copyWith(
          value: newValue,
          lastUpdated: DateTime.now(),
          updatedBy: _authController.user.value?.displayName ?? 'Admin',
        );

        configItems[index] = updatedItem;
      }

      // Simulate network delay
      await Future<void>.delayed(const Duration(milliseconds: 500));

      loggerService.d('Updated configuration item: $id');
    } catch (e, stackTrace) {
      loggerService.e('Error updating configuration item', e, stackTrace);
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  /// Reset a configuration item to its default value
  Future<void> resetConfigItem(String id) async {
    try {
      isSaving.value = true;
      loggerService.i('Resetting configuration item: $id');

      // In a real app, this would update Firestore with default values
      // For now, we'll just update the local state with mock defaults
      final index = configItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = configItems[index];
        dynamic defaultValue;

        // Mock default values based on ID
        switch (id) {
          case 'site_name':
            defaultValue = 'Next Gen Udyam';
          case 'maintenance_mode':
            defaultValue = false;
          case 'max_file_size':
            defaultValue = 10;
          case 'password_min_length':
            defaultValue = 8;
          case 'require_email_verification':
            defaultValue = true;
          case 'email_notifications':
            defaultValue = true;
          case 'job_auto_expire':
            defaultValue = 30;
          case 'max_active_jobs':
            defaultValue = 10;
          case 'user_inactivity_threshold':
            defaultValue = 90;
          default:
            defaultValue = item.value;
        }

        final updatedItem = item.copyWith(
          value: defaultValue,
          lastUpdated: DateTime.now(),
          updatedBy: _authController.user.value?.displayName ?? 'Admin',
        );

        configItems[index] = updatedItem;
      }

      // Simulate network delay
      await Future<void>.delayed(const Duration(milliseconds: 500));

      loggerService.d('Reset configuration item: $id');
    } catch (e, stackTrace) {
      loggerService.e('Error resetting configuration item', e, stackTrace);
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }
}
