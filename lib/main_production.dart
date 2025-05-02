import 'package:flutter/widgets.dart'; // Import WidgetsFlutterBinding
import 'package:next_gen/app/app.dart';
import 'package:next_gen/bootstrap.dart';

Future<void> main() async {
  // Make main async
  // Ensure bindings are initialized before calling bootstrap
  WidgetsFlutterBinding.ensureInitialized();
  // Await the bootstrap process to complete before running the app
  await bootstrap(() => const App());
}
