import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/modules/company_profile/models/company_model.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';

/// A utility class for generating test data
class TestDataGenerator {
  /// Private constructor to prevent instantiation
  TestDataGenerator._();

  /// Generate a test job model
  ///
  /// [id] is the job ID
  /// [companyId] is the company ID
  /// [title] is the job title
  /// [status] is the job status
  static JobPostModel generateTestJob({
    String id = 'test_job_id',
    String companyId = 'test_company_id',
    String title = 'Software Engineer',
    JobStatus status = JobStatus.active,
  }) {
    return JobPostModel(
      id: id,
      companyId: companyId,
      title: title,
      description: 'This is a test job description',
      location: 'New York, NY',
      salary: 100000,
      requirements: ["Bachelor's degree", '3+ years of experience'],
      responsibilities: ['Develop software', 'Fix bugs'],
      skills: ['Flutter', 'Dart', 'Firebase'],
      experience: '3-5 years',
      education: "Bachelor's degree",
      postedDate: DateTime.now().subtract(const Duration(days: 7)),
      applicationDeadline: DateTime.now().add(const Duration(days: 30)),
      status: status,
      benefits: ['Health insurance', '401k', 'Remote work'],
    );
  }

  /// Generate a list of test jobs
  ///
  /// [count] is the number of jobs to generate
  /// [companyId] is the company ID
  static List<JobPostModel> generateTestJobs({
    int count = 10,
    String companyId = 'test_company_id',
  }) {
    return List.generate(
      count,
      (index) => generateTestJob(
        id: 'test_job_id_$index',
        companyId: companyId,
        title: 'Software Engineer ${index + 1}',
        status: index % 3 == 0
            ? JobStatus.active
            : index % 3 == 1
                ? JobStatus.closed
                : JobStatus.draft,
      ),
    );
  }

  /// Generate a test application model
  ///
  /// [id] is the application ID
  /// [userId] is the user ID
  /// [jobId] is the job ID
  /// [status] is the application status
  static ApplicationModel generateTestApplication({
    String id = 'test_application_id',
    String userId = 'test_user_id',
    String jobId = 'test_job_id',
    ApplicationStatus status = ApplicationStatus.pending,
  }) {
    return ApplicationModel(
      id: id,
      userId: userId,
      jobId: jobId,
      status: status,
      appliedAt: DateTime.now().subtract(const Duration(days: 3)),
      name: 'Test User',
      email: 'test@example.com',
      phone: '123-456-7890',
      coverLetter: 'This is a test cover letter',
      resumeUrl: 'https://example.com/resume.pdf',
      jobTitle: 'Software Engineer',
      company: 'Test Company',
    );
  }

  /// Generate a list of test applications
  ///
  /// [count] is the number of applications to generate
  /// [userId] is the user ID
  static List<ApplicationModel> generateTestApplications({
    int count = 10,
    String userId = 'test_user_id',
  }) {
    return List.generate(
      count,
      (index) => generateTestApplication(
        id: 'test_application_id_$index',
        userId: userId,
        jobId: 'test_job_id_$index',
        status: index % 3 == 0
            ? ApplicationStatus.pending
            : index % 3 == 1
                ? ApplicationStatus.shortlisted
                : ApplicationStatus.rejected,
      ),
    );
  }

  /// Generate a test company model
  ///
  /// [id] is the company ID
  /// [name] is the company name
  static CompanyModel generateTestCompany({
    String id = 'test_company_id',
    String name = 'Test Company',
  }) {
    return CompanyModel(
      uid: id,
      name: name,
      email: 'company@example.com',
      description: 'This is a test company description',
      industry: 'Technology',
      location: 'New York, NY',
      website: 'https://example.com',
      logoUrl: 'https://example.com/logo.png',
      size: '51-200',
      phone: '123-456-7890',
      socialLinks: ['https://linkedin.com/company/test'],
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
    );
  }
}
