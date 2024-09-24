import 'package:flutter/material.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
