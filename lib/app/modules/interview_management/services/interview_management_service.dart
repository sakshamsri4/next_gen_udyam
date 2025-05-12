import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/interview_management/models/interview_model.dart';
import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/auth_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:uuid/uuid.dart';

/// Service for interview management
class InterviewManagementService {
  /// Constructor
  InterviewManagementService() {
    _firestore = FirebaseFirestore.instance;
    _logger = Get.find<LoggerService>();
    _authService = Get.find<AuthService>();
    _analyticsService = Get.find<AnalyticsService>();
  }

  late final FirebaseFirestore _firestore;
  late final LoggerService _logger;
  late final AuthService _authService;
  late final AnalyticsService _analyticsService;

  /// Get all interviews for the current employer
  Future<List<InterviewModel>> getInterviews() async {
    try {
      _logger.i('Getting interviews');

      // In a real app, we would fetch this from Firestore
      // For now, we'll use mock data
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Log the screen view
      await _analyticsService.logScreenView(
        screenName: 'interview_management',
        screenClass: 'InterviewManagementView',
      );

      return _getMockInterviews();
    } catch (e) {
      _logger.e('Error getting interviews', e);
      rethrow;
    }
  }

  /// Get an interview by ID
  Future<InterviewModel?> getInterviewById(String id) async {
    try {
      _logger.i('Getting interview by ID: $id');

      // In a real app, we would fetch this from Firestore
      // For now, we'll use mock data
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final interviews = _getMockInterviews();
      return interviews.firstWhereOrNull((interview) => interview.id == id);
    } catch (e) {
      _logger.e('Error getting interview by ID', e);
      rethrow;
    }
  }

  /// Create a new interview
  Future<InterviewModel> createInterview(InterviewModel interview) async {
    try {
      _logger.i('Creating interview');

      // In a real app, we would save this to Firestore
      // For now, we'll just simulate the creation
      await Future<void>.delayed(const Duration(seconds: 1));

      // Generate a unique ID
      final id = const Uuid().v4();
      final now = DateTime.now();

      // Create the interview with the generated ID
      final newInterview = interview.copyWith(
        id: id,
        createdAt: now,
        updatedAt: now,
      );

      // Log the event
      await _analyticsService.logEvent(
        name: 'create_interview',
        parameters: {
          'interview_id': id,
          'job_id': interview.jobId,
          'candidate_id': interview.candidateId,
        },
      );

      return newInterview;
    } catch (e) {
      _logger.e('Error creating interview', e);
      rethrow;
    }
  }

  /// Update an existing interview
  Future<InterviewModel> updateInterview(InterviewModel interview) async {
    try {
      _logger.i('Updating interview: ${interview.id}');

      // In a real app, we would update this in Firestore
      // For now, we'll just simulate the update
      await Future<void>.delayed(const Duration(seconds: 1));

      // Update the interview with the current timestamp
      final updatedInterview = interview.copyWith(
        updatedAt: DateTime.now(),
      );

      // Log the event
      await _analyticsService.logEvent(
        name: 'update_interview',
        parameters: {
          'interview_id': interview.id,
          'status': interview.status.toString().split('.').last,
        },
      );

      return updatedInterview;
    } catch (e) {
      _logger.e('Error updating interview', e);
      rethrow;
    }
  }

  /// Cancel an interview
  Future<bool> cancelInterview(String id, String reason) async {
    try {
      _logger.i('Canceling interview: $id');

      // In a real app, we would update this in Firestore
      // For now, we'll just simulate the cancellation
      await Future<void>.delayed(const Duration(seconds: 1));

      // Log the event
      await _analyticsService.logEvent(
        name: 'cancel_interview',
        parameters: {
          'interview_id': id,
          'reason': reason,
        },
      );

      return true;
    } catch (e) {
      _logger.e('Error canceling interview', e);
      rethrow;
    }
  }

  /// Reschedule an interview
  Future<InterviewModel> rescheduleInterview(
    String id,
    DateTime newDate,
    String reason,
  ) async {
    try {
      _logger.i('Rescheduling interview: $id');

      // In a real app, we would update this in Firestore
      // For now, we'll just simulate the rescheduling
      await Future<void>.delayed(const Duration(seconds: 1));

      // Get the interview
      final interview = await getInterviewById(id);
      if (interview == null) {
        throw Exception('Interview not found');
      }

      // Update the interview with the new date
      final updatedInterview = interview.copyWith(
        scheduledDate: newDate,
        status: InterviewStatus.rescheduled,
        notes: '${interview.notes ?? ''}\n\nRescheduled: $reason',
        updatedAt: DateTime.now(),
      );

      // Log the event
      await _analyticsService.logEvent(
        name: 'reschedule_interview',
        parameters: {
          'interview_id': id,
          'reason': reason,
        },
      );

      return updatedInterview;
    } catch (e) {
      _logger.e('Error rescheduling interview', e);
      rethrow;
    }
  }

  /// Add feedback to an interview
  Future<InterviewModel> addFeedback(String id, String feedback) async {
    try {
      _logger.i('Adding feedback to interview: $id');

      // In a real app, we would update this in Firestore
      // For now, we'll just simulate the update
      await Future<void>.delayed(const Duration(seconds: 1));

      // Get the interview
      final interview = await getInterviewById(id);
      if (interview == null) {
        throw Exception('Interview not found');
      }

      // Update the interview with the feedback
      final updatedInterview = interview.copyWith(
        feedback: feedback,
        status: InterviewStatus.completed,
        updatedAt: DateTime.now(),
      );

      // Log the event
      await _analyticsService.logEvent(
        name: 'add_interview_feedback',
        parameters: {
          'interview_id': id,
        },
      );

      return updatedInterview;
    } catch (e) {
      _logger.e('Error adding feedback to interview', e);
      rethrow;
    }
  }

  /// Get mock interviews for testing
  List<InterviewModel> _getMockInterviews() {
    final now = DateTime.now();
    return [
      InterviewModel(
        id: '1',
        applicationId: 'app-1',
        jobId: 'job-1',
        candidateId: 'candidate-1',
        candidateName: 'John Doe',
        jobTitle: 'Senior Flutter Developer',
        scheduledDate: now.add(const Duration(days: 2)),
        duration: 60,
        status: InterviewStatus.scheduled,
        type: InterviewType.video,
        notes: 'Initial technical interview',
        videoLink: 'https://meet.google.com/abc-defg-hij',
        interviewerIds: ['interviewer-1'],
        interviewerNames: ['Jane Smith'],
        preparationResources: [
          'Review Flutter state management',
          'Prepare questions about architecture',
        ],
        questions: [
          'Describe your experience with state management in Flutter',
          'How would you architect a complex Flutter application?',
          'Tell us about a challenging bug you fixed recently',
        ],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      InterviewModel(
        id: '2',
        applicationId: 'app-2',
        jobId: 'job-2',
        candidateId: 'candidate-2',
        candidateName: 'Alice Johnson',
        jobTitle: 'UX Designer',
        scheduledDate: now.add(const Duration(days: 1)),
        duration: 45,
        status: InterviewStatus.confirmed,
        type: InterviewType.phone,
        notes: 'Initial screening call',
        phoneNumber: '+1234567890',
        interviewerIds: ['interviewer-2'],
        interviewerNames: ['Bob Brown'],
        preparationResources: [
          'Review portfolio',
          'Prepare questions about design process',
        ],
        questions: [
          'Walk us through your design process',
          'How do you handle feedback from stakeholders?',
          "Tell us about a project you're particularly proud of",
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      InterviewModel(
        id: '3',
        applicationId: 'app-3',
        jobId: 'job-3',
        candidateId: 'candidate-3',
        candidateName: 'Michael Wilson',
        jobTitle: 'Product Manager',
        scheduledDate: now.subtract(const Duration(days: 1)),
        duration: 90,
        status: InterviewStatus.completed,
        type: InterviewType.inPerson,
        notes: 'Final round interview',
        location: 'Office - Conference Room A',
        feedback:
            'Strong candidate with excellent product sense. Recommended for hire.',
        interviewerIds: ['interviewer-1', 'interviewer-3'],
        interviewerNames: ['Jane Smith', 'David Lee'],
        preparationResources: [
          'Review product roadmap',
          'Prepare case study discussion',
        ],
        questions: [
          'How do you prioritize features?',
          'Describe how you work with engineering teams',
          'Tell us about a product you launched from concept to completion',
        ],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
