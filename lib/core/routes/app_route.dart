import 'package:flutter/material.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/features/conversition/presentation/screens/conversition.dart';
import 'package:tqnia_chat_app_task/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (context) => DashboardScreen());
      case Routes.conversition:
        return MaterialPageRoute(builder: (context) => Conversition());

      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
