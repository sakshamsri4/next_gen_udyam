import 'package:hive/hive.dart';

part 'signup_session.g.dart';

/// Model for storing signup session data
@HiveType(typeId: 3)
class SignupSession {
  /// Creates a signup session
  SignupSession({
    required this.email,
    this.name,
    this.step = SignupStep.initial,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a session from a map
  factory SignupSession.fromMap(Map<String, dynamic> map) {
    return SignupSession(
      email: map['email'] as String,
      name: map['name'] as String?,
      step: SignupStep.values[map['step'] as int],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  /// Email address
  @HiveField(0)
  final String email;

  /// User's name
  @HiveField(1)
  final String? name;

  /// Current signup step
  @HiveField(2)
  final SignupStep step;

  /// Timestamp of the session
  @HiveField(3)
  final DateTime timestamp;

  /// Creates a copy of this session with the given fields replaced with the new values
  SignupSession copyWith({
    String? email,
    String? name,
    SignupStep? step,
    DateTime? timestamp,
  }) {
    return SignupSession(
      email: email ?? this.email,
      name: name ?? this.name,
      step: step ?? this.step,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Converts this session to a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'step': step.index,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

/// Signup steps
@HiveType(typeId: 4)
enum SignupStep {
  /// Initial step
  @HiveField(0)
  initial,

  /// Email and password entered
  @HiveField(1)
  credentials,

  /// Account created
  @HiveField(2)
  accountCreated,

  /// Email verification sent
  @HiveField(3)
  verificationSent,

  /// Email verified
  @HiveField(4)
  emailVerified,

  /// Role selected
  @HiveField(5)
  roleSelected,

  /// Profile completed
  @HiveField(6)
  profileCompleted,

  /// Signup completed
  @HiveField(7)
  completed,
}
