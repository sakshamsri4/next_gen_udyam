import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/modules/auth/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoute = Routes.HOME;

  static final routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: BindingsBuilder<dynamic>(() {
        // Add any bindings needed for home screen
      }),
    ),
    GetPage<dynamic>(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: AuthBinding(),
    ),
  ];
}

// Temporary Home Screen until we implement the actual home module
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Gen Job Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed<dynamic>(_Paths.PROFILE),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Next Gen Job Portal',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
