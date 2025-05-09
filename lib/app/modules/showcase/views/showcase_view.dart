import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/showcase/controllers/showcase_controller.dart';
import 'package:next_gen/ui/components/showcase/cred_components_showcase.dart';

/// Showcase view that displays CRED-styled components
class ShowcaseView extends GetView<ShowcaseController> {
  /// Creates a showcase view
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    // Simply return the existing CredComponentsShowcase
    return const CredComponentsShowcase();
  }
}
