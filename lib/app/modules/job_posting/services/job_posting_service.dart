import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for job posting operations
class JobPostingService {
  /// Constructor
  JobPostingService({
    FirebaseFirestore? firestore,
    LoggerService? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Get.find<LoggerService>();

  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  /// Create a new job posting
  Future<JobPostModel?> createJobPosting({
    required String companyId,
    required String title,
    required String description,
    required String location,
    required int salary,
    required List<String> requirements,
    required List<String> responsibilities,
    required List<String> skills,
    required String jobType,
    required String experience,
    required String education,
    required String industry,
    required bool isRemote,
    DateTime? applicationDeadline,
    JobStatus status = JobStatus.active,
    List<String> benefits = const [],
    bool isFeatured = false,
  }) async {
    try {
      _logger.i('Creating job posting for company: $companyId');

      // Prepare job data
      final jobData = {
        'companyId': companyId,
        'title': title,
        'description': description,
        'location': location,
        'salary': salary,
        'postedDate': FieldValue.serverTimestamp(),
        'requirements': requirements,
        'responsibilities': responsibilities,
        'skills': skills,
        'jobType': jobType,
        'experience': experience,
        'education': education,
        'industry': industry,
        'isRemote': isRemote,
        'applicationDeadline': applicationDeadline != null
            ? Timestamp.fromDate(applicationDeadline)
            : null,
        'status': status.toString().split('.').last,
        'benefits': benefits,
        'isFeatured': isFeatured,
        'viewCount': 0,
        'applicationCount': 0,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Add to Firestore
      final docRef = await _firestore.collection('jobs').add(jobData);

      // Get the document with server timestamp
      final doc = await docRef.get();

      return JobPostModel.fromFirestore(doc);
    } catch (e, stackTrace) {
      _logger.e('Error creating job posting', e, stackTrace);
      return null;
    }
  }

  /// Get a job posting by ID
  Future<JobPostModel?> getJobPostingById(String jobId) async {
    try {
      _logger.i('Getting job posting: $jobId');

      final doc = await _firestore.collection('jobs').doc(jobId).get();

      if (!doc.exists) {
        _logger.w('Job posting not found: $jobId');
        return null;
      }

      return JobPostModel.fromFirestore(doc);
    } catch (e, stackTrace) {
      _logger.e('Error getting job posting', e, stackTrace);
      return null;
    }
  }

  /// Get all job postings for a company
  Future<List<JobPostModel>> getCompanyJobPostings(
    String companyId, {
    JobStatus? status,
  }) async {
    try {
      _logger.i('Getting job postings for company: $companyId');

      Query query = _firestore
          .collection('jobs')
          .where('companyId', isEqualTo: companyId)
          .orderBy('postedDate', descending: true);

      // Filter by status if provided
      if (status != null) {
        final statusStr = status.toString().split('.').last;
        query = query.where('status', isEqualTo: statusStr);
      }

      final snapshot = await query.get();

      return snapshot.docs.map(JobPostModel.fromFirestore).toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting company job postings', e, stackTrace);
      return [];
    }
  }

  /// Update a job posting
  Future<JobPostModel?> updateJobPosting({
    required String jobId,
    String? title,
    String? description,
    String? location,
    int? salary,
    List<String>? requirements,
    List<String>? responsibilities,
    List<String>? skills,
    String? jobType,
    String? experience,
    String? education,
    String? industry,
    bool? isRemote,
    DateTime? applicationDeadline,
    JobStatus? status,
    List<String>? benefits,
    bool? isFeatured,
  }) async {
    try {
      _logger.i('Updating job posting: $jobId');

      // Get current job posting
      final currentJob = await getJobPostingById(jobId);
      if (currentJob == null) {
        _logger.w('Job posting not found: $jobId');
        return null;
      }

      // Prepare update data
      final updateData = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Only update fields that are provided
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (location != null) updateData['location'] = location;
      if (salary != null) updateData['salary'] = salary;
      if (requirements != null) updateData['requirements'] = requirements;
      if (responsibilities != null) {
        updateData['responsibilities'] = responsibilities;
      }
      if (skills != null) updateData['skills'] = skills;
      if (jobType != null) updateData['jobType'] = jobType;
      if (experience != null) updateData['experience'] = experience;
      if (education != null) updateData['education'] = education;
      if (industry != null) updateData['industry'] = industry;
      if (isRemote != null) updateData['isRemote'] = isRemote;
      if (applicationDeadline != null) {
        updateData['applicationDeadline'] =
            Timestamp.fromDate(applicationDeadline);
      }
      if (status != null) {
        updateData['status'] = status.toString().split('.').last;
      }
      if (benefits != null) updateData['benefits'] = benefits;
      if (isFeatured != null) updateData['isFeatured'] = isFeatured;

      // Update in Firestore
      await _firestore.collection('jobs').doc(jobId).update(updateData);

      // Get updated document
      final updatedDoc = await _firestore.collection('jobs').doc(jobId).get();

      return JobPostModel.fromFirestore(updatedDoc);
    } catch (e, stackTrace) {
      _logger.e('Error updating job posting', e, stackTrace);
      return null;
    }
  }

  /// Delete a job posting
  Future<bool> deleteJobPosting(String jobId) async {
    try {
      _logger.i('Deleting job posting: $jobId');

      await _firestore.collection('jobs').doc(jobId).delete();

      return true;
    } catch (e, stackTrace) {
      _logger.e('Error deleting job posting', e, stackTrace);
      return false;
    }
  }

  /// Update job status
  Future<bool> updateJobStatus(String jobId, JobStatus status) async {
    try {
      _logger.i(
        'Updating job status: $jobId to ${status.toString().split('.').last}',
      );

      await _firestore.collection('jobs').doc(jobId).update({
        'status': status.toString().split('.').last,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e, stackTrace) {
      _logger.e('Error updating job status', e, stackTrace);
      return false;
    }
  }

  /// Increment view count
  Future<bool> incrementViewCount(String jobId) async {
    try {
      _logger.i('Incrementing view count for job: $jobId');

      await _firestore.collection('jobs').doc(jobId).update({
        'viewCount': FieldValue.increment(1),
      });

      return true;
    } catch (e, stackTrace) {
      _logger.e('Error incrementing view count', e, stackTrace);
      return false;
    }
  }

  /// Increment application count
  Future<bool> incrementApplicationCount(String jobId) async {
    try {
      _logger.i('Incrementing application count for job: $jobId');

      await _firestore.collection('jobs').doc(jobId).update({
        'applicationCount': FieldValue.increment(1),
      });

      return true;
    } catch (e, stackTrace) {
      _logger.e('Error incrementing application count', e, stackTrace);
      return false;
    }
  }
}
