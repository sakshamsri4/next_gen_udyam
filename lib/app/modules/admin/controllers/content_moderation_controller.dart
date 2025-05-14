import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/models/moderation_item_model.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for content moderation
class ContentModerationController extends GetxController {
  /// Constructor
  ContentModerationController({
    required this.loggerService,
  });

  /// Logger service
  final LoggerService loggerService;

  /// Auth controller for current user info
  final AuthController _authController = Get.find<AuthController>();

  /// Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Moderation queue
  final RxList<ModerationItem> moderationQueue = <ModerationItem>[].obs;

  /// Selected moderation item
  final Rx<ModerationItem?> selectedItem = Rx<ModerationItem?>(null);

  /// Filter by type
  final RxString typeFilter = 'All'.obs;

  /// Filter by priority
  final RxString priorityFilter = 'All'.obs;

  /// Filter by status
  final RxString statusFilter = 'Pending'.obs;

  /// Search query
  final RxString searchQuery = ''.obs;

  /// Available types for filtering
  final List<String> availableTypes = [
    'All',
    'Job Posting',
    'User Profile',
    'Company Profile',
    'User Report',
  ];

  /// Available priorities for filtering
  final List<String> availablePriorities = [
    'All',
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  /// Available statuses for filtering
  final List<String> availableStatuses = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
    'Needs Info',
  ];

  @override
  void onInit() {
    super.onInit();
    loadModerationQueue();

    // Set up listeners for filter changes
    ever(typeFilter, (_) => loadModerationQueue());
    ever(priorityFilter, (_) => loadModerationQueue());
    ever(statusFilter, (_) => loadModerationQueue());
    debounce(
      searchQuery,
      (_) => loadModerationQueue(),
      time: const Duration(milliseconds: 500),
    );
  }

  /// Load moderation queue from Firestore
  Future<void> loadModerationQueue() async {
    try {
      isLoading.value = true;
      loggerService.i('Loading moderation queue');

      // In a real app, this would fetch from Firestore
      // For now, we'll use mock data
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Create mock data
      final allItems = [
        ModerationItem(
          id: '301',
          type: 'Job Posting',
          title: 'Senior Flutter Developer',
          submittedBy: 'Tech Innovations',
          submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
          status: 'Pending',
          priority: 'High',
          contentId: 'job123',
          reason: 'New job posting requires approval',
        ),
        ModerationItem(
          id: '302',
          type: 'Company Profile',
          title: 'Global Solutions',
          submittedBy: 'Global Solutions',
          submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'Pending',
          priority: 'Medium',
          contentId: 'company456',
          reason: 'Company verification required',
        ),
        ModerationItem(
          id: '303',
          type: 'User Report',
          title: 'Inappropriate Content',
          submittedBy: 'John Smith',
          submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
          status: 'Pending',
          priority: 'High',
          contentId: 'user789',
          reason: 'User reported for inappropriate content',
        ),
        ModerationItem(
          id: '304',
          type: 'Job Posting',
          title: 'Product Manager',
          submittedBy: 'Acme Corp',
          submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'Approved',
          priority: 'Medium',
          contentId: 'job456',
          reason: 'New job posting requires approval',
          reviewedBy: 'Admin',
          reviewedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        ModerationItem(
          id: '305',
          type: 'User Profile',
          title: 'Jane Doe',
          submittedBy: 'System',
          submittedAt: DateTime.now().subtract(const Duration(days: 3)),
          status: 'Rejected',
          priority: 'Low',
          contentId: 'user123',
          reason: 'Profile contains inappropriate content',
          reviewedBy: 'Admin',
          reviewedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      // Apply filters
      final filteredItems = allItems.where((item) {
        // Filter by type
        if (typeFilter.value != 'All' && item.type != typeFilter.value) {
          return false;
        }

        // Filter by priority
        if (priorityFilter.value != 'All' &&
            item.priority != priorityFilter.value) {
          return false;
        }

        // Filter by status
        if (statusFilter.value != 'All' && item.status != statusFilter.value) {
          return false;
        }

        // Filter by search query
        if (searchQuery.value.isNotEmpty) {
          final query = searchQuery.value.toLowerCase();
          return item.title.toLowerCase().contains(query) ||
              item.submittedBy.toLowerCase().contains(query) ||
              (item.reason?.toLowerCase().contains(query) ?? false);
        }

        return true;
      }).toList();

      moderationQueue.value = filteredItems;
      loggerService.d('Loaded ${moderationQueue.length} moderation items');
    } catch (e, stackTrace) {
      loggerService.e('Error loading moderation queue', e, stackTrace);
      moderationQueue.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Approve a moderation item
  Future<void> approveItem(String id) async {
    try {
      loggerService.i('Approving item: $id');

      // In a real app, this would update Firestore
      // For now, we'll just update the local state
      final index = moderationQueue.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = moderationQueue[index];
        final updatedItem = ModerationItem(
          id: item.id,
          type: item.type,
          title: item.title,
          submittedBy: item.submittedBy,
          submittedAt: item.submittedAt,
          status: 'Approved',
          priority: item.priority,
          contentId: item.contentId,
          reason: item.reason,
          notes: item.notes,
          reviewedBy: _authController.user.value?.displayName ?? 'Admin',
          reviewedAt: DateTime.now(),
        );

        moderationQueue[index] = updatedItem;

        // Update selected item if it's the same
        if (selectedItem.value?.id == id) {
          selectedItem.value = updatedItem;
        }
      }
    } catch (e, stackTrace) {
      loggerService.e('Error approving item', e, stackTrace);
      rethrow;
    }
  }

  /// Reject a moderation item
  Future<void> rejectItem(String id, {String? reason}) async {
    try {
      loggerService.i('Rejecting item: $id');

      // In a real app, this would update Firestore
      // For now, we'll just update the local state
      final index = moderationQueue.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = moderationQueue[index];
        final updatedItem = ModerationItem(
          id: item.id,
          type: item.type,
          title: item.title,
          submittedBy: item.submittedBy,
          submittedAt: item.submittedAt,
          status: 'Rejected',
          priority: item.priority,
          contentId: item.contentId,
          reason: item.reason,
          notes: reason,
          reviewedBy: _authController.user.value?.displayName ?? 'Admin',
          reviewedAt: DateTime.now(),
        );

        moderationQueue[index] = updatedItem;

        // Update selected item if it's the same
        if (selectedItem.value?.id == id) {
          selectedItem.value = updatedItem;
        }
      }
    } catch (e, stackTrace) {
      loggerService.e('Error rejecting item', e, stackTrace);
      rethrow;
    }
  }

  /// Request more information for a moderation item
  Future<void> requestMoreInfo(String id, {required String message}) async {
    try {
      loggerService.i('Requesting more info for item: $id');

      // In a real app, this would update Firestore
      // For now, we'll just update the local state
      final index = moderationQueue.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = moderationQueue[index];
        final updatedItem = ModerationItem(
          id: item.id,
          type: item.type,
          title: item.title,
          submittedBy: item.submittedBy,
          submittedAt: item.submittedAt,
          status: 'Needs Info',
          priority: item.priority,
          contentId: item.contentId,
          reason: item.reason,
          notes: message,
          reviewedBy: _authController.user.value?.displayName ?? 'Admin',
          reviewedAt: DateTime.now(),
        );

        moderationQueue[index] = updatedItem;

        // Update selected item if it's the same
        if (selectedItem.value?.id == id) {
          selectedItem.value = updatedItem;
        }
      }
    } catch (e, stackTrace) {
      loggerService.e('Error requesting more info', e, stackTrace);
      rethrow;
    }
  }

  /// Select a moderation item to view details
  void selectItem(ModerationItem item) {
    selectedItem.value = item;
  }

  /// Clear selected item
  void clearSelectedItem() {
    selectedItem.value = null;
  }
}
