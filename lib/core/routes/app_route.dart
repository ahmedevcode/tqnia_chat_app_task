import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/features/conversition/data/data_sources/Apis/GenerativeChatService.dart';
import 'package:tqnia_chat_app_task/features/conversition/presentation/controller/chat_cubit.dart';
import 'package:tqnia_chat_app_task/features/conversition/presentation/screens/conversition_screen.dart';
import 'package:tqnia_chat_app_task/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        final onComplete = settings.arguments as VoidCallback?;
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(
            onComplete: onComplete ??
                () {
                  // Default onComplete logic here (if null)
                },
          ),
        );

      case Routes.dashboard:
        final toggleTheme = settings.arguments as VoidCallback?;
        return MaterialPageRoute(
          builder: (context) => DashboardScreen(
            toggleTheme: toggleTheme ??
                () {
                  // Default toggleTheme logic here (if null)
                  print('toggleTheme not passed, using default');
                },
          ),
        );

      case Routes.conversition:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ChatCubit>(
            create: (BuildContext context) =>
                ChatCubit(GenerativeChatService()),
            child: Conversition(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
