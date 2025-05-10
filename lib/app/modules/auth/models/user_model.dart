import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// Enum representing user types in the application
@HiveType(typeId: 20)
enum UserType {
  /// Employee/job seeker user type
  @HiveField(0)
  employee,

  /// Employer/company user type
  @HiveField(1)
  employer,
}

@HiveType(typeId: 0)
class UserModel {
  // Constructor
  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.phoneNumber,
    this.userType,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructors
  factory UserModel.fromFirebaseUser(firebase.User user, {UserType? userType}) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      userType: userType,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    UserType? userType;
    if (map['userType'] != null) {
      final userTypeString = map['userType'] as String;
      if (userTypeString == 'employee') {
        userType = UserType.employee;
      } else if (userTypeString == 'employer') {
        userType = UserType.employer;
      }
    }

    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      emailVerified: map['emailVerified'] as bool,
      phoneNumber: map['phoneNumber'] as String?,
      userType: userType,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Fields
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? displayName;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final bool emailVerified;

  @HiveField(5)
  final String? phoneNumber;

  @HiveField(6)
  final DateTime createdAt;

  /// The type of user (employee or employer)
  @HiveField(7)
  final UserType? userType;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'userType': userType?.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    String? phoneNumber,
    UserType? userType,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
