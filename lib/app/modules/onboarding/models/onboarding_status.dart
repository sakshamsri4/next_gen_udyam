import 'package:hive/hive.dart';

part 'onboarding_status.g.dart';

/// Type ID for OnboardingStatus in Hive
const int onboardingStatusTypeId = 3;

/// Box name for storing onboarding status
const String onboardingStatusBoxName = 'onboarding_status_box';

/// Model for storing onboarding completion status
@HiveType(typeId: onboardingStatusTypeId)
class OnboardingStatus {
  /// Constructor
  OnboardingStatus({
    this.hasCompletedOnboarding = false,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Whether the user has completed the onboarding flow
  @HiveField(0)
  final bool hasCompletedOnboarding;

  /// When the status was last updated
  @HiveField(1)
  final DateTime lastUpdated;

  /// Create a copy of this object with the given fields replaced
  OnboardingStatus copyWith({
    bool? hasCompletedOnboarding,
    DateTime? lastUpdated,
  }) {
    return OnboardingStatus(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
