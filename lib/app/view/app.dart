import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // For tests, we'll use a simpler version that directly shows the AuthView
    return GetMaterialApp(
      title: 'Next Gen Job Portal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthView(),
      initialBinding: AuthBinding(),
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
