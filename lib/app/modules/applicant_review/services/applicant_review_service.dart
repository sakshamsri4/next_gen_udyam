import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_comparison_model.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_filter_model.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for managing applicant reviews
class ApplicantReviewService {
  /// Constructor
  ApplicantReviewService({
    FirebaseFirestore? firestore,
    LoggerService? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Get.find<LoggerService>();

  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  /// Get all applications for a job
  Future<List<ApplicationModel>> getJobApplications(String jobId) async {
    try {
      _logger.i('Getting applications for job: $jobId');

      final snapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .orderBy('appliedAt', descending: true)
          .get();

      return snapshot.docs.map(ApplicationModel.fromFirestore).toList();
    } catch (e) {
      _logger.e('Error getting job applications', e);
      return [];
    }
  }

  /// Get filtered applications for a job
  Future<List<ApplicationModel>> getFilteredApplications(
    ApplicantFilterModel filter,
  ) async {
    try {
      _logger.i('Getting filtered applications for job: ${filter.jobId}');

      // Start with base query
      Query query = _firestore.collection('applications');

      // Apply job ID filter if provided
      if (filter.jobId.isNotEmpty) {
        query = query.where('jobId', isEqualTo: filter.jobId);
      }

      // Apply status filter if provided
      if (filter.statuses.isNotEmpty) {
        final statusStrings = filter.statuses
            .map((status) => status.toString().split('.').last)
            .toList();
        query = query.where('status', whereIn: statusStrings);
      }

      // Apply date range filter if provided
      if (filter.applicationDateStart != null) {
        query = query.where(
          'appliedAt',
          isGreaterThanOrEqualTo:
              Timestamp.fromDate(filter.applicationDateStart!),
        );
      }
      if (filter.applicationDateEnd != null) {
        query = query.where(
          'appliedAt',
          isLessThanOrEqualTo: Timestamp.fromDate(filter.applicationDateEnd!),
        );
      }

      // Apply sort
      final sortField = _getSortField(filter.sortBy);
      query = query.orderBy(
        sortField,
        descending: filter.sortOrder == ApplicantSortOrder.descending,
      );

      // Apply pagination
      query = query.limit(filter.limit);

      // If not the first page, we need to use startAfter instead of offset
      if (filter.page > 1) {
        // Get the last document from the previous page
        final lastDocSnapshot = await query
            .limit((filter.page - 1) * filter.limit)
            .get()
            .then((value) => value.docs.isNotEmpty ? value.docs.last : null);

        // If we have a last document, use startAfter
        if (lastDocSnapshot != null) {
          query = query.startAfter([lastDocSnapshot]);
        }
      }

      // Execute query
      final snapshot = await query.get();
      final applications =
          snapshot.docs.map(ApplicationModel.fromFirestore).toList();

      // Apply client-side filters
      return applications.where((application) {
        // Name filter
        if (filter.name.isNotEmpty &&
            !application.name
                .toLowerCase()
                .contains(filter.name.toLowerCase())) {
          return false;
        }

        // Resume filter
        if (filter.hasResume && application.resumeUrl == null) {
          return false;
        }

        // Cover letter filter
        if (filter.hasCoverLetter && application.coverLetter.isEmpty) {
          return false;
        }

        // TODO(dev): Add filtering for skills, experience, and education
        // These would require additional fields in the ApplicationModel
        // or joining with user profile data

        return true;
      }).toList();
    } catch (e) {
      _logger.e('Error getting filtered applications', e);
      return [];
    }
  }

  /// Update application status
  Future<bool> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    try {
      _logger.i(
        'Updating application status: $applicationId to ${status.toString().split('.').last}',
      );

      await _firestore.collection('applications').doc(applicationId).update({
        'status': status.toString().split('.').last,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _logger.e('Error updating application status', e);
      return false;
    }
  }

  /// Add feedback to an application
  Future<bool> addFeedback(String applicationId, String feedback) async {
    try {
      _logger.i('Adding feedback to application: $applicationId');

      await _firestore.collection('applications').doc(applicationId).update({
        'feedback': feedback,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _logger.e('Error adding feedback to application', e);
      return false;
    }
  }

  /// Schedule an interview for an application
  Future<bool> scheduleInterview(
    String applicationId,
    DateTime interviewDate,
  ) async {
    try {
      _logger.i('Scheduling interview for application: $applicationId');

      await _firestore.collection('applications').doc(applicationId).update({
        'interviewDate': Timestamp.fromDate(interviewDate),
        'status': ApplicationStatus.interview.toString().split('.').last,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _logger.e('Error scheduling interview', e);
      return false;
    }
  }

  /// Save a comparison
  Future<ApplicantComparisonModel?> saveComparison(
    ApplicantComparisonModel comparison,
  ) async {
    try {
      _logger.i('Saving comparison for job: ${comparison.jobId}');

      final docRef = comparison.id.isEmpty
          ? _firestore.collection('comparisons').doc()
          : _firestore.collection('comparisons').doc(comparison.id);

      final data = comparison.toFirestore();
      await docRef.set(data);

      return comparison.copyWith(id: docRef.id);
    } catch (e) {
      _logger.e('Error saving comparison', e);
      return null;
    }
  }

  /// Get a comparison by ID
  Future<ApplicantComparisonModel?> getComparison(String comparisonId) async {
    try {
      _logger.i('Getting comparison: $comparisonId');

      final doc =
          await _firestore.collection('comparisons').doc(comparisonId).get();

      if (!doc.exists) {
        return null;
      }

      return ApplicantComparisonModel.fromFirestore(doc);
    } catch (e) {
      _logger.e('Error getting comparison', e);
      return null;
    }
  }

  /// Get sort field for a sort option
  String _getSortField(ApplicantSortOption sortOption) {
    switch (sortOption) {
      case ApplicantSortOption.applicationDate:
        return 'appliedAt';
      case ApplicantSortOption.name:
        return 'name';
      case ApplicantSortOption.status:
        return 'status';
      case ApplicantSortOption.matchScore:
        // This would require a match score field in the ApplicationModel
        return 'appliedAt'; // Default to application date for now
    }
  }
}
