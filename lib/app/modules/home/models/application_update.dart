/// Model class for job application updates
class ApplicationUpdate {
  /// Constructor
  ApplicationUpdate({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.date,
    this.message,
  });

  /// Application ID
  final String id;

  /// Job ID
  final String jobId;

  /// Job title
  final String jobTitle;

  /// Company name
  final String companyName;

  /// Application status
  final String status;

  /// Update date
  final DateTime date;

  /// Optional message
  final String? message;
}
