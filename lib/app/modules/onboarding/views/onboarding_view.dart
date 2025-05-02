import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:next_gen/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:next_gen/widgets/neopop_loading_indicator.dart';
import 'package:responsive_builder/responsive_builder.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a local key for the IntroductionScreen
    final introKey = GlobalKey<IntroductionScreenState>();

    // Register the key with the controller
    controller.registerIntroKey(introKey);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: NeoPopLoadingIndicator(),
          );
        }

        return SafeArea(
          child: IntroductionScreen(
            key: introKey,
            pages: _buildPages(context),
            onDone: controller.onDone,
            onSkip: controller.onSkip,
            showSkipButton: true,
            skipOrBackFlex: 0,
            nextFlex: 0,
            back: const Icon(Icons.arrow_back),
            skip: Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            next: const Icon(Icons.arrow_forward),
            done: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            dotsDecorator: DotsDecorator(
              size: const Size(10, 10),
              color: Theme.of(context).colorScheme.surface,
              activeSize: const Size(22, 10),
              activeColor: Theme.of(context).colorScheme.primary,
              activeShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            dotsContainerDecorator: ShapeDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withAlpha(51), // 0.2 * 255 = 51
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChange: controller.onPageChanged,
          ),
        );
      }),
    );
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    return controller.pages.map((page) {
      return PageViewModel(
        title: page.title,
        body: page.description,
        image: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            final animationSize = sizingInformation.isMobile ? 250.0 : 350.0;

            // Use a placeholder if the animation file doesn't exist yet
            Widget animationWidget;
            try {
              animationWidget = Lottie.asset(
                page.animationPath,
                width: animationSize,
                height: animationSize,
                fit: BoxFit.contain,
              );
            } catch (e) {
              // Fallback to a placeholder
              animationWidget = Container(
                width: animationSize,
                height: animationSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: animationSize / 3,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            return Center(child: animationWidget);
          },
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withAlpha(204), // 0.8 * 255 = 204
          ),
          bodyPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          imagePadding: const EdgeInsets.only(top: 40),
          pageColor: page.backgroundColor,
        ),
        footer: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            if (sizingInformation.isMobile) {
              return const SizedBox.shrink();
            }

            // Show custom NeoPOP buttons on larger screens
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.currentPage.value > 0)
                    CustomNeoPopButton(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      onTap: controller.goToPreviousPage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Previous',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  CustomNeoPopButton(
                    color: Theme.of(context).colorScheme.primary,
                    onTap: controller.currentPage.value <
                            controller.pages.length - 1
                        ? controller.goToNextPage
                        : controller.onDone,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.currentPage.value <
                                    controller.pages.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            controller.currentPage.value <
                                    controller.pages.length - 1
                                ? Icons.arrow_forward
                                : Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }).toList();
  }
}
