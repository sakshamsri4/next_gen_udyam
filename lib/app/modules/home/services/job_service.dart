import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      // Ensure the doc exists; merge keeps existing fields intact.
      await userRef.set({'savedJobs': <String>[]}, SetOptions(merge: true));

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
  Future<List<String>> getSavedJobIds(String userId) async {
    try {
      _logger.i('Fetching saved job IDs for user: $userId');

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        _logger.w('User document not found: $userId');
        return [];
      }

      final data = userDoc.data()!;
      if (data.containsKey('savedJobs') && data['savedJobs'] is List) {
        return List<String>.from(data['savedJobs'] as List);
      }

      return [];
    } catch (e) {
      _logger.e('Error fetching saved job IDs', e);
      rethrow;
    }
  }

  /// Search for jobs
  Future<List<JobModel>> searchJobs(
    String query, [
    Map<String, dynamic>? filters,
  ]) async {
    try {
      _logger.i('Searching for jobs with query: $query');

      // Create base query
      var jobsQuery = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .orderBy('postedDate', descending: true);

      // Apply filters if provided
      if (filters != null && filters.isNotEmpty) {
        if (filters.containsKey('location') && filters['location'] != null) {
          jobsQuery =
              jobsQuery.where('location', isEqualTo: filters['location']);
        }

        if (filters.containsKey('jobType') && filters['jobType'] != null) {
          jobsQuery = jobsQuery.where('jobType', isEqualTo: filters['jobType']);
        }

        // Add more filters as needed
      }

      // Apply text search (simple contains for now)
      // In a real app, you'd use a more sophisticated search solution
      final snapshot = await jobsQuery.limit(20).get();
      final results = snapshot.docs.map(JobModel.fromFirestore).toList();

      // Filter by text query if provided
      if (query.isNotEmpty) {
        return results.where((job) {
          final title = job.title.toLowerCase();
          final company = job.company.toLowerCase();
          final description = job.description.toLowerCase();
          final searchQuery = query.toLowerCase();

          return title.contains(searchQuery) ||
              company.contains(searchQuery) ||
              description.contains(searchQuery);
        }).toList();
      }

      return results;
    } catch (e) {
      _logger.e('Error searching for jobs', e);
      return []; // Return empty list instead of rethrowing to prevent UI errors
    }
  }

  /// Get saved jobs with full details
  Future<List<JobModel>> getSavedJobs() async {
    try {
      _logger.i('Fetching saved jobs');

      // Get current user ID from Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _logger.w('No user logged in');
        return [];
      }

      // Get saved job IDs
      final savedJobIds = await getSavedJobIds(user.uid);
      if (savedJobIds.isEmpty) {
        return [];
      }

      // Fetch job details for each saved job
      final jobs = <JobModel>[];
      for (final jobId in savedJobIds) {
        final job = await getJobById(jobId);
        if (job != null) {
          jobs.add(job);
        }
      }

      return jobs;
    } catch (e) {
      _logger.e('Error fetching saved jobs', e);
      return []; // Return empty list instead of rethrowing to prevent UI errors
    }
  }

  /// Save a job
  Future<void> saveJob(JobModel job) async {
    try {
      _logger.i('Saving job: ${job.id}');

      // Get current user ID from Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _logger.w('No user logged in');
        throw Exception('User not logged in');
      }

      // Save the job
      await toggleSaveJob(userId: user.uid, jobId: job.id, isSaved: false);
    } catch (e) {
      _logger.e('Error saving job', e);
      rethrow;
    }
  }

  /// Unsave a job
  Future<void> unsaveJob(String jobId) async {
    try {
      _logger.i('Unsaving job: $jobId');

      // Get current user ID from Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _logger.w('No user logged in');
        throw Exception('User not logged in');
      }

      // Unsave the job
      await toggleSaveJob(userId: user.uid, jobId: jobId, isSaved: true);
    } catch (e) {
      _logger.e('Error unsaving job', e);
      rethrow;
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
