import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';

// Mock Firebase User
class MockFirebaseUser extends Mock implements firebase.User {
  MockFirebaseUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.phoneNumber,
  });
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;
  @override
  final bool emailVerified;
  @override
  final String? phoneNumber;
}

// Mock Hive classes for testing adapter
class MockBinaryReader extends Mock implements BinaryReader {
  MockBinaryReader(this.fields, this.numOfFields);
  final Map<int, dynamic> fields;
  int position = 0;
  final int numOfFields;

  @override
  int readByte() {
    // For the first call, return numOfFields
    if (position == 0) {
      position++;
      return numOfFields;
    }
    // For subsequent calls, return field indices (0-6)
    if (position <= numOfFields) {
      return position - 1;
    }
    // After that, we'll be looking up values
    return 0;
  }

  @override
  dynamic read([int? typeId]) {
    // Get the field index for the current read
    final fieldIndex = (position - 1) % numOfFields;

    // Critical fix: ensure we always return non-null for required fields
    final value = fields[fieldIndex];

    // Make sure we never return null for non-nullable fields (uid, email)
    if (fieldIndex == 0 && value == null) {
      return ''; // uid cannot be null
    }
    if (fieldIndex == 1 && value == null) {
      return ''; // email cannot be null
    }

    position++;
    return value;
  }
}

// Helper class for mocking Firestore (if needed later)
class MockFirestore extends Mock implements FakeFirebaseFirestore {}

void main() {
  group('UserModel', () {
    final testTime = DateTime(2024, 7, 21, 10, 30);
    final firebaseUser = MockFirebaseUser(
      uid: 'testUid',
      email: 'test@example.com',
      displayName: 'Test User',
      photoURL: 'http://example.com/photo.jpg',
      emailVerified: true,
      phoneNumber: '+1234567890',
    );

    final userModel = UserModel(
      uid: 'testUid',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: 'http://example.com/photo.jpg',
      emailVerified: true,
      phoneNumber: '+1234567890',
      createdAt: testTime,
    );

    test('constructor creates instance with provided values', () {
      final now = DateTime.now();
      final model = UserModel(
        uid: 'uid1',
        email: 'email1@test.com',
        displayName: 'Name 1',
        photoUrl: 'url1',
        emailVerified: true,
        phoneNumber: '111',
        createdAt: now,
      );

      expect(model.uid, 'uid1');
      expect(model.email, 'email1@test.com');
      expect(model.displayName, 'Name 1');
      expect(model.photoUrl, 'url1');
      expect(model.emailVerified, isTrue);
      expect(model.phoneNumber, '111');
      expect(model.createdAt, now);
    });

    test('constructor uses default values correctly', () {
      final model = UserModel(uid: 'uid2', email: 'email2@test.com');
      final timeDiff = DateTime.now().difference(model.createdAt).inSeconds;

      expect(model.uid, 'uid2');
      expect(model.email, 'email2@test.com');
      expect(model.displayName, isNull);
      expect(model.photoUrl, isNull);
      expect(model.emailVerified, isFalse);
      expect(model.phoneNumber, isNull);
      expect(timeDiff, lessThan(2)); // createdAt should be roughly now
    });

    test('fromFirebaseUser factory creates correct UserModel', () {
      final model = UserModel.fromFirebaseUser(firebaseUser);

      expect(model.uid, firebaseUser.uid);
      expect(model.email, firebaseUser.email);
      expect(model.displayName, firebaseUser.displayName);
      expect(model.photoUrl, firebaseUser.photoURL);
      expect(model.emailVerified, firebaseUser.emailVerified);
      expect(model.phoneNumber, firebaseUser.phoneNumber);
      // createdAt should be recent
      expect(DateTime.now().difference(model.createdAt).inSeconds, lessThan(2));
    });

    test('fromFirebaseUser factory handles null email', () {
      final firebaseUserNullEmail = MockFirebaseUser(uid: 'testUid');
      final model = UserModel.fromFirebaseUser(firebaseUserNullEmail);
      expect(model.email, ''); // Should default to empty string
    });

    test('fromMap factory creates correct UserModel', () {
      final map = {
        'uid': 'mapUid',
        'email': 'map@example.com',
        'displayName': 'Map User',
        'photoUrl': 'http://map.com/photo.jpg',
        'emailVerified': false,
        'phoneNumber': '+9876543210',
        'createdAt': testTime.toIso8601String(),
      };
      final model = UserModel.fromMap(map);

      expect(model.uid, 'mapUid');
      expect(model.email, 'map@example.com');
      expect(model.displayName, 'Map User');
      expect(model.photoUrl, 'http://map.com/photo.jpg');
      expect(model.emailVerified, isFalse);
      expect(model.phoneNumber, '+9876543210');
      expect(model.createdAt, testTime);
    });

    test('fromMap factory handles missing optional fields', () {
      final map = {
        'uid': 'mapUid',
        'email': 'map@example.com',
        'emailVerified': true,
        'createdAt': testTime.toIso8601String(),
      };
      final model = UserModel.fromMap(map);

      expect(model.uid, 'mapUid');
      expect(model.email, 'map@example.com');
      expect(model.displayName, isNull);
      expect(model.photoUrl, isNull);
      expect(model.emailVerified, isTrue);
      expect(model.phoneNumber, isNull);
      expect(model.createdAt, testTime);
    });

    test('toMap converts UserModel to correct Map', () {
      final map = userModel.toMap();

      expect(map['uid'], userModel.uid);
      expect(map['email'], userModel.email);
      expect(map['displayName'], userModel.displayName);
      expect(map['photoUrl'], userModel.photoUrl);
      expect(map['emailVerified'], userModel.emailVerified);
      expect(map['phoneNumber'], userModel.phoneNumber);
      expect(map['createdAt'], userModel.createdAt.toIso8601String());
    });

    test('toMap handles null optional fields', () {
      final model = UserModel(uid: 'uid', email: 'email', createdAt: testTime);
      final map = model.toMap();

      expect(map['uid'], 'uid');
      expect(map['email'], 'email');
      expect(map['displayName'], isNull);
      expect(map['photoUrl'], isNull);
      expect(map['emailVerified'], isFalse);
      expect(map['phoneNumber'], isNull);
      expect(map['createdAt'], testTime.toIso8601String());
    });

    test('copyWith creates a copy with updated values', () {
      final newTime = DateTime(2025);
      final copiedModel = userModel.copyWith(
        displayName: 'Updated Name',
        emailVerified: false,
        createdAt: newTime,
      );

      expect(copiedModel.uid, userModel.uid); // Unchanged
      expect(copiedModel.email, userModel.email); // Unchanged
      expect(copiedModel.displayName, 'Updated Name'); // Changed
      expect(copiedModel.photoUrl, userModel.photoUrl); // Unchanged
      expect(copiedModel.emailVerified, isFalse); // Changed
      expect(copiedModel.phoneNumber, userModel.phoneNumber); // Unchanged
      expect(copiedModel.createdAt, newTime); // Changed
    });

    test('copyWith creates an identical copy when no arguments provided', () {
      final copiedModel = userModel.copyWith();

      expect(copiedModel.uid, userModel.uid);
      expect(copiedModel.email, userModel.email);
      expect(copiedModel.displayName, userModel.displayName);
      expect(copiedModel.photoUrl, userModel.photoUrl);
      expect(copiedModel.emailVerified, userModel.emailVerified);
      expect(copiedModel.phoneNumber, userModel.phoneNumber);
      expect(copiedModel.createdAt, userModel.createdAt);
    });
  });

  group('UserModelAdapter', () {
    final adapter = UserModelAdapter();
    final testTime = DateTime(2024, 7, 21, 10, 30);

    test('typeId should be 0', () {
      expect(adapter.typeId, 0);
    });

    test('read should create UserModel from binary data', () {
      // Arrange
      final fields = {
        0: 'test-uid',
        1: 'test@example.com',
        2: 'Test User',
        3: 'http://example.com/photo.jpg',
        4: true,
        5: '+1234567890',
        6: testTime,
      };
      final reader = MockBinaryReader(fields, 7);

      // Act
      final result = adapter.read(reader);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.uid, 'test-uid');
      expect(result.email, 'test@example.com');
      expect(result.displayName, 'Test User');
      expect(result.photoUrl, 'http://example.com/photo.jpg');
      expect(result.emailVerified, true);
      expect(result.phoneNumber, '+1234567890');
      expect(result.createdAt, testTime);
    });

    test('read should handle null optional fields', () {
      // Arrange
      final fields = {
        0: 'test-uid',
        1: 'test@example.com',
        2: null,
        3: null,
        4: false,
        5: null,
        6: testTime,
      };
      final reader = MockBinaryReader(fields, 7);

      // Act
      final result = adapter.read(reader);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.uid, 'test-uid');
      expect(result.email, 'test@example.com');
      expect(result.displayName, null);
      expect(result.photoUrl, null);
      expect(result.emailVerified, false);
      expect(result.phoneNumber, null);
      expect(result.createdAt, testTime);
    });

    test('adapter equality check works correctly', () {
      // Same type
      final adapter1 = UserModelAdapter();
      final adapter2 = UserModelAdapter();
      expect(adapter1 == adapter2, isTrue);

      // Different type
      final otherObject = Object();
      expect(adapter1 == otherObject, isFalse);

      // Same instance
      expect(adapter1 == adapter1, isTrue);
    });

    test('adapter hashCode is based on typeId', () {
      final adapter = UserModelAdapter();
      expect(adapter.hashCode, adapter.typeId.hashCode);
    });
  });
}
