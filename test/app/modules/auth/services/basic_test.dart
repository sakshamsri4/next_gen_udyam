import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  test('Basic mock test', () {
    final mockService = MockAuthService();
    expect(mockService, isA<AuthService>());
  });
}
