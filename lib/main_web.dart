// This is a special entry point for web
// It uses the standard Firebase implementation

import 'package:next_gen/app/app.dart';
import 'package:next_gen/bootstrap.dart';
import 'package:next_gen/core/services/logger_service.dart';

Future<void> main() async {
  // Log that we're using the web version
  log.i('Starting Next Gen Udyam Web Version');

  // Use the standard bootstrap process which includes Firebase
  await bootstrap(() => const App());
}
