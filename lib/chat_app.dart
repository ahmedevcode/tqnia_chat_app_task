import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tqnia_chat_app_task/core/routes/app_route.dart';
import 'package:tqnia_chat_app_task/core/util/constant.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/screens/onboarding_01_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AppConstants.onBoarding != false
              ? OnboardingScreen()
              : OnboardingScreen(),
          onGenerateRoute: (settings) {
            return AppRouter.onGenerateRoute(settings);
          }),
    );
  }
}
