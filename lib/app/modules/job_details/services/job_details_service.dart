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

  /// Get company details by company name
  Future<Map<String, dynamic>?> getCompanyDetails(String companyName) async {
    try {
      _logger.i('Fetching company details for: $companyName');
      final snapshot = await _firestore
          .collection('companies')
          .where('name', isEqualTo: companyName)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        _logger.w('Company not found: $companyName');
        return null;
      }

      return snapshot.docs.first.data();
    } catch (e) {
      _logger.e('Error fetching company details', e);
      rethrow;
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
      final snapshot = await _firestore
          .collection('jobs')
          .where('jobType', isEqualTo: jobType)
          .where('industry', isEqualTo: industry)
          .where('isActive', isEqualTo: true)
          .limit(5)
          .get();

      // Filter out the current job
      return snapshot.docs
          .map(JobModel.fromFirestore)
          .where((job) => job.id != currentJobId)
          .toList();
    } catch (e) {
      _logger.e('Error fetching similar jobs', e);
      rethrow;
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
