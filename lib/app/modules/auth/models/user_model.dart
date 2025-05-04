import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_role.dart';

part 'user_model.g.dart';

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
    this.role = UserRole.employee,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructors
  factory UserModel.fromFirebaseUser(
    firebase.User user, {
    UserRole role = UserRole.employee,
  }) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      role: role,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      emailVerified: map['emailVerified'] as bool,
      phoneNumber: map['phoneNumber'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      role: map['role'] != null
          ? UserRole.values[map['role'] as int]
          : UserRole.employee,
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

  @HiveField(7)
  final UserRole role;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'role': role.index,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    String? phoneNumber,
    DateTime? createdAt,
    UserRole? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
    );
  }
}
