import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tqnia_chat_app_task/core/routes/app_route.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';
import 'package:tqnia_chat_app_task/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/screens/onboarding_screen.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!hasSeenOnboarding) {
      setState(() {
        _showOnboarding = true;
      });
    } else {
      setState(() {
        _showOnboarding = false;
      });
    }
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
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Kcolor.mainbackgroundcolorlight,
          primaryColorLight: Colors.black45,
          secondaryHeaderColor: Kcolor.conversitioncolorlight,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Kcolor.conversitioncolor,
          primaryColorLight: Colors.white54,
          secondaryHeaderColor: Kcolor.mainbackgroundcolor,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
          ),
        ),
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        home: _showOnboarding
            ? OnboardingScreen(onComplete: _completeOnboarding)
            : DashboardScreen(toggleTheme: _toggleTheme),
        onGenerateRoute: (settings) {
          return AppRouter.onGenerateRoute(settings);
        },
      ),
    );
  }
}
