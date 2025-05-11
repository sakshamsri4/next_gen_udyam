import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for job details operations
class JobDetailsService {
  /// Constructor
  JobDetailsService({
    FirebaseFirestore? firestore,
    LoggerService? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Get.find<LoggerService>();

  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  /// Get job details by ID
  Future<JobModel?> getJobDetails(String jobId) async {
    try {
      _logger.i('Fetching job details for job: $jobId');

      // Validate job ID
      if (jobId.isEmpty) {
        _logger.w('Empty job ID provided');
        return null;
      }

      // Add a timeout to prevent hanging
      final docFuture = _firestore.collection('jobs').doc(jobId).get();
      final doc = await docFuture.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _logger.w('Timeout fetching job: $jobId');
          throw TimeoutException('Timeout fetching job details');
        },
      );

      if (!doc.exists) {
        _logger.w('Job not found: $jobId');
        return null;
      }

      if (!doc.data()!.containsKey('title')) {
        _logger.w('Invalid job document structure: $jobId');
        return null;
      }

      final jobModel = JobModel.fromFirestore(doc);
      _logger.i('Job details fetched successfully: ${jobModel.title}');
      return jobModel;
    } on TimeoutException catch (e) {
      _logger.e('Timeout fetching job details', e);
      return null;
    } catch (e, stackTrace) {
      _logger.e('Error fetching job details', e, stackTrace);
      // Return null instead of rethrowing to prevent app crashes
      return null;
    }
  }

  /// Get company details by company name
  Future<Map<String, dynamic>?> getCompanyDetails(String companyName) async {
    try {
      _logger.i('Fetching company details for: $companyName');

      // Validate company name
      if (companyName.isEmpty) {
        _logger.w('Empty company name provided');
        return {'name': 'Unknown Company'};
      }

      // Add a timeout to prevent hanging
      final queryFuture = _firestore
          .collection('companies')
          .where('name', isEqualTo: companyName)
          .limit(1)
          .get();

      final snapshot = await queryFuture.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          _logger.w('Timeout fetching company: $companyName');
          throw TimeoutException('Timeout fetching company details');
        },
      );

      if (snapshot.docs.isEmpty) {
        _logger.w('Company not found: $companyName');
        // Return a fallback company object instead of null
        return {
          'name': companyName,
          'description': 'No additional information available',
        };
      }

      final companyData = snapshot.docs.first.data();
      _logger.i('Company details fetched successfully for: $companyName');
      return companyData;
    } on TimeoutException catch (e) {
      _logger.e('Timeout fetching company details', e);
      // Return a fallback company object
      return {
        'name': companyName,
        'description': 'Unable to load company details (timeout)',
      };
    } catch (e, stackTrace) {
      _logger.e('Error fetching company details', e, stackTrace);
      // Return a fallback company object instead of rethrowing
      return {
        'name': companyName,
        'description': 'Unable to load company details',
      };
    }
  }

  /// Get similar jobs based on job type and industry
  Future<List<JobModel>> getSimilarJobs({
    required String currentJobId,
    required String jobType,
    required String industry,
  }) async {
    try {
      _logger.i('Fetching similar jobs for job: $currentJobId');

      // Validate parameters
      if (currentJobId.isEmpty || jobType.isEmpty || industry.isEmpty) {
        _logger.w('Invalid parameters for similar jobs query');
        return [];
      }

      // Try to get jobs with both jobType and industry
      try {
        final queryFuture = _firestore
            .collection('jobs')
            .where('jobType', isEqualTo: jobType)
            .where('industry', isEqualTo: industry)
            .where('isActive', isEqualTo: true)
            .limit(5)
            .get();

        final snapshot = await queryFuture.timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            _logger.w('Timeout fetching similar jobs with combined query');
            throw TimeoutException('Timeout fetching similar jobs');
          },
        );

        // Filter out the current job
        final jobs = snapshot.docs
            .map(JobModel.fromFirestore)
            .where((job) => job.id != currentJobId)
            .toList();

        if (jobs.isNotEmpty) {
          _logger.i('Found ${jobs.length} similar jobs');
          return jobs;
        }
      } on TimeoutException catch (e) {
        _logger.w(
          'Timeout with combined query, falling back to simpler query',
          e,
        );
        // Continue to fallback query
      } catch (e) {
        _logger.w(
          'Error with combined query, falling back to simpler query',
          e,
        );
        // Continue to fallback query
      }

      // Fallback: Try to get jobs with just jobType
      try {
        final fallbackFuture = _firestore
            .collection('jobs')
            .where('jobType', isEqualTo: jobType)
            .where('isActive', isEqualTo: true)
            .limit(5)
            .get();

        final fallbackSnapshot = await fallbackFuture.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            _logger.w('Timeout fetching similar jobs with fallback query');
            throw TimeoutException(
              'Timeout fetching similar jobs with fallback query',
            );
          },
        );

        final fallbackJobs = fallbackSnapshot.docs
            .map(JobModel.fromFirestore)
            .where((job) => job.id != currentJobId)
            .toList();

        _logger.i('Found ${fallbackJobs.length} jobs with fallback query');
        return fallbackJobs;
      } on TimeoutException catch (e) {
        _logger.e('Timeout fetching similar jobs with fallback query', e);
        return [];
      } catch (e, stackTrace) {
        _logger.e(
          'Error fetching similar jobs with fallback query',
          e,
          stackTrace,
        );
        return [];
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching similar jobs', e, stackTrace);
      // Return empty list instead of rethrowing
      return [];
    }
  }

  /// Apply for a job
  Future<void> applyForJob({
    required String userId,
    required String jobId,
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      _logger.i('Applying for job: $jobId by user: $userId');

      // Validate and sanitize application data
      final validFields = [
        'name',
        'email',
        'phone',
        'coverLetter',
        'resume',
        'jobTitle',
        'company',
      ];
      final sanitizedData = <String, dynamic>{};
      for (final field in validFields) {
        if (applicationData.containsKey(field)) {
          sanitizedData[field] = applicationData[field];
        }
      }

      // Create application document
      await _firestore.collection('applications').add({
        'userId': userId,
        'jobId': jobId,
        'status': 'pending',
        'appliedAt': FieldValue.serverTimestamp(),
        ...sanitizedData,
      });

      // Update user's applications list
      await _firestore.collection('users').doc(userId).update({
        'applications': FieldValue.arrayUnion([jobId]),
      });
    } catch (e) {
      _logger.e('Error applying for job', e);
      rethrow;
    }
  }

  /// Check if user has already applied for a job
  Future<bool> hasApplied({
    required String userId,
    required String jobId,
  }) async {
    try {
      _logger.i('Checking if user: $userId has applied for job: $jobId');

      final snapshot = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .where('jobId', isEqualTo: jobId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking application status', e);
      return false;
    }
  }
}
