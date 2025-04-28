import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/app/app.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App', () {
    testWidgets('renders AuthView', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(AuthView), findsOneWidget);
    });
  });
}
