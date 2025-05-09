import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/models/job_category.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for job-related operations
class JobService {
  /// Constructor
  JobService({
    FirebaseFirestore? firestore,
    LoggerService? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Get.find<LoggerService>();

  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  /// Get featured jobs
  Future<List<JobModel>> getFeaturedJobs() async {
    try {
      _logger.i('Fetching featured jobs');
      final snapshot = await _firestore
          .collection('jobs')
          .where('isFeatured', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('postedDate', descending: true)
          .limit(5)
          .get();

      return snapshot.docs.map(JobModel.fromFirestore).toList();
    } catch (e) {
      _logger.e('Error fetching featured jobs', e);
      rethrow;
    }
  }

  /// Get recent jobs
  Future<List<JobModel>> getRecentJobs({String? category}) async {
    try {
      _logger.i('Fetching recent jobs with category: $category');

      // Create base query
      final query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .orderBy('postedDate', descending: true);

      // Apply category filter if provided and not "All"
      final filteredQuery = (category != null && category != 'All')
          ? query.where('jobType', isEqualTo: category)
          : query;

      final snapshot = await filteredQuery.limit(10).get();
      return snapshot.docs.map(JobModel.fromFirestore).toList();
    } catch (e) {
      _logger.e('Error fetching recent jobs', e);
      rethrow;
    }
  }

  /// Get job categories
  Future<List<JobCategory>> getJobCategories() async {
    try {
      _logger.i('Fetching job categories');
      final snapshot = await _firestore.collection('jobCategories').get();

      // Create list with "All" category first, then add other categories
      return [
        JobCategory.all(),
        ...snapshot.docs.map(JobCategory.fromFirestore),
      ];
    } catch (e) {
      _logger.e('Error fetching job categories', e);
      rethrow;
    }
  }

  /// Save or unsave a job
  Future<bool> toggleSaveJob({
    required String userId,
    required String jobId,
    required bool isSaved,
  }) async {
    try {
      _logger.i(
        '${isSaved ? "Unsaving" : "Saving"} job: $jobId for user: $userId',
      );

      final userRef = _firestore.collection('users').doc(userId);

      if (isSaved) {
        // Remove job from saved jobs
        await userRef.update({
          'savedJobs': FieldValue.arrayRemove([jobId]),
        });
        return false;
      } else {
        // Add job to saved jobs
        await userRef.update({
          'savedJobs': FieldValue.arrayUnion([jobId]),
        });
        return true;
      }
    } catch (e) {
      _logger.e('Error toggling saved job', e);
      rethrow;
    }
  }

  /// Get saved jobs for a user
  Future<List<String>> getSavedJobs(String userId) async {
    try {
      _logger.i('Fetching saved jobs for user: $userId');

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return [];
      }

      final data = userDoc.data()!;
      if (data.containsKey('savedJobs') && data['savedJobs'] is List) {
        return List<String>.from(data['savedJobs'] as List);
      }

      return [];
    } catch (e) {
      _logger.e('Error fetching saved jobs', e);
      return [];
    }
  }

  /// Get job by ID
  Future<JobModel?> getJobById(String jobId) async {
    try {
      _logger.i('Fetching job details for job: $jobId');
      final doc = await _firestore.collection('jobs').doc(jobId).get();

      if (!doc.exists) {
        _logger.w('Job not found: $jobId');
        return null;
      }

      return JobModel.fromFirestore(doc);
    } catch (e) {
      _logger.e('Error fetching job details', e);
      rethrow;
    }
  }
}
