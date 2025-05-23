import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
