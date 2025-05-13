import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for managing job applications
class ApplicationsService {
  /// Constructor
  ApplicationsService({
    FirebaseFirestore? firestore,
    LoggerService? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Get.find<LoggerService>();

  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  /// Get all applications for a user
  ///
  /// Note: This query requires a composite index on 'userId' and 'appliedAt'
  /// If you encounter a FirebaseException about missing indexes, you need to create
  /// this index in the Firebase console or follow the link in the error message.
  Future<List<ApplicationModel>> getUserApplications(String userId) async {
    try {
      _logger.i('Getting applications for user: $userId');

      final snapshot = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .orderBy('appliedAt', descending: true)
          .get();

      return snapshot.docs.map(ApplicationModel.fromFirestore).toList();
    } catch (e) {
      // Check if this is a missing index error
      if (e.toString().contains('failed-precondition') &&
          e.toString().contains('index')) {
        const errorMessage = 'Missing Firestore index for applications query. '
            'Please create a composite index on "userId" and "appliedAt".';

        // Extract the URL from the error message if available
        String? indexUrl;
        final errorString = e.toString();
        final urlMatch =
            RegExp(r'https://console\.firebase\.google\.com/[^\s]+')
                .firstMatch(errorString);

        if (urlMatch != null) {
          indexUrl = urlMatch.group(0);
          _logger.i('Index creation URL: $indexUrl');
        }

        _logger.e(errorMessage, e);

        // Rethrow with more context to allow the controller to handle it appropriately
        throw Exception(
          '$errorMessage${indexUrl != null ? ' URL: $indexUrl' : ''}',
        );
      } else {
        _logger.e('Error getting user applications', e);
        rethrow; // Rethrow to allow the controller to handle it
      }
    }
  }

  /// Get application details by ID
  Future<ApplicationModel?> getApplicationById(String applicationId) async {
    try {
      _logger.i('Getting application details for ID: $applicationId');

      final doc =
          await _firestore.collection('applications').doc(applicationId).get();

      if (!doc.exists) {
        _logger.w('Application not found: $applicationId');
        return null;
      }

      return ApplicationModel.fromFirestore(doc);
    } catch (e) {
      _logger.e('Error getting application details', e);
      return null;
    }
  }

  /// Get job details for an application
  Future<JobModel?> getJobForApplication(String jobId) async {
    try {
      _logger.i('Getting job details for application, job ID: $jobId');

      final doc = await _firestore.collection('jobs').doc(jobId).get();

      if (!doc.exists) {
        _logger.w('Job not found: $jobId');
        return null;
      }

      return JobModel.fromFirestore(doc);
    } catch (e) {
      _logger.e('Error getting job details for application', e);
      return null;
    }
  }

  /// Withdraw an application
  Future<bool> withdrawApplication(String applicationId) async {
    try {
      _logger.i('Withdrawing application: $applicationId');

      // Get the application first to verify it exists
      final application = await getApplicationById(applicationId);
      if (application == null) {
        _logger.w('Cannot withdraw non-existent application: $applicationId');
        return false;
      }

      // Only allow withdrawing if the application is in certain states
      final allowedStatuses = [
        ApplicationStatus.pending,
        ApplicationStatus.reviewed,
        ApplicationStatus.shortlisted,
      ];

      if (!allowedStatuses.contains(application.status)) {
        _logger.w(
          'Cannot withdraw application in status: ${application.status}',
        );
        return false;
      }

      // Update the application status to withdrawn
      await _firestore.collection('applications').doc(applicationId).update({
        'status': ApplicationStatus.withdrawn.toString().split('.').last,
        'lastUpdated': FieldValue.serverTimestamp(),
        'feedback': 'Application withdrawn by candidate',
      });

      return true;
    } catch (e) {
      _logger.e('Error withdrawing application', e);
      return false;
    }
  }

  /// Get applications by status
  ///
  /// Note: This query requires a composite index on 'userId', 'status', and 'appliedAt'
  /// If you encounter a FirebaseException about missing indexes, you need to create
  /// this index in the Firebase console or follow the link in the error message.
  Future<List<ApplicationModel>> getApplicationsByStatus(
    String userId,
    ApplicationStatus status,
  ) async {
    try {
      _logger.i(
        'Getting applications for user: $userId with status: $status',
      );

      final statusStr = status.toString().split('.').last;
      final snapshot = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: statusStr)
          .orderBy('appliedAt', descending: true)
          .get();

      return snapshot.docs.map(ApplicationModel.fromFirestore).toList();
    } catch (e) {
      // Check if this is a missing index error
      if (e.toString().contains('failed-precondition') &&
          e.toString().contains('index')) {
        _logger.e(
          'Missing Firestore index for applications by status query. '
          'Please create a composite index on "userId", "status", and "appliedAt".',
          e,
        );
      } else {
        _logger.e('Error getting applications by status', e);
      }
      return [];
    }
  }

  /// Get application count by status
  Future<Map<ApplicationStatus, int>> getApplicationCountsByStatus(
    String userId,
  ) async {
    try {
      _logger.i('Getting application counts for user: $userId');

      final applications = await getUserApplications(userId);
      final counts = <ApplicationStatus, int>{};

      // Initialize counts for all statuses
      for (final status in ApplicationStatus.values) {
        counts[status] = 0;
      }

      // Count applications by status
      for (final application in applications) {
        counts[application.status] = (counts[application.status] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      // If this is an index error, we want to propagate it to the controller
      if (e.toString().contains('Missing Firestore index')) {
        _logger.e('Error getting application counts due to missing index', e);
        rethrow;
      } else {
        _logger.e('Error getting application counts', e);

        // Return empty counts map with all statuses initialized to 0
        final counts = <ApplicationStatus, int>{};
        for (final status in ApplicationStatus.values) {
          counts[status] = 0;
        }
        return counts;
      }
    }
  }
}
