import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:next_gen/app/modules/showcase/controllers/showcase_controller.dart';

class ShowcaseView extends GetView<ShowcaseController> {
  const ShowcaseView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowcaseView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShowcaseView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
