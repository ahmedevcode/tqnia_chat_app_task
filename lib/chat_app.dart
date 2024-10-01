import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tqnia_chat_app_task/core/routes/app_route.dart';
import 'package:tqnia_chat_app_task/features/dashboard/presentation/controller/theme_cubit.dart';
import 'package:tqnia_chat_app_task/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/screens/onboarding_screen.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    setState(() {
      _showOnboarding = !hasSeenOnboarding;
    });
  }

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              theme: themeState.themeData,
              darkTheme: ThemeData.dark(),
              themeMode:
                  themeState is DarkTheme ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: _showOnboarding
                  ? OnboardingScreen(onComplete: _completeOnboarding)
                  : DashboardScreen(toggleTheme: () {
                      context.read<ThemeCubit>().toggleTheme();
                    }),
              onGenerateRoute: (settings) {
                return AppRouter.onGenerateRoute(settings);
              },
            );
          },
        ),
      ),
    );
  }
}
