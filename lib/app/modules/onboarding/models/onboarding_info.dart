import 'package:flutter/material.dart';

class OnboardingInfo {
  OnboardingInfo({
    required this.title,
    required this.description,
    required this.animationPath,
    required this.backgroundColor,
  });
  final String title;
  final String description;
  final String animationPath;
  final Color backgroundColor;
}

final List<OnboardingInfo> onboardingPages = [
  OnboardingInfo(
    title: 'Welcome to NextGen',
    description: 'Your next-generation job portal with cutting-edge features',
    animationPath: 'assets/animations/welcome.json',
    backgroundColor: const Color(0xFF1A1A2E),
  ),
  OnboardingInfo(
    title: 'Find Your Dream Job',
    description:
        'Browse thousands of job listings tailored to your skills and preferences',
    animationPath: 'assets/animations/search.json',
    backgroundColor: const Color(0xFF16213E),
  ),
  OnboardingInfo(
    title: 'Apply with Ease',
    description:
        'One-click applications and resume management make job hunting simple',
    animationPath: 'assets/animations/apply.json',
    backgroundColor: const Color(0xFF0F3460),
  ),
  OnboardingInfo(
    title: 'Track Your Progress',
    description:
        'Monitor your applications and get real-time updates on your job search',
    animationPath: 'assets/animations/track.json',
    backgroundColor: const Color(0xFF1A1A2E),
  ),
];
