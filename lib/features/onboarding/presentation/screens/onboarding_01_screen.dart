import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/controller/onboarding_cubit.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/controller/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  final String imagePath = 'assets/images/icon.png';
  final String title = 'Welcome to ChatGPT';
  final String subtitle = 'Ask anything, get your answer';

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Scaffold(
      backgroundColor: Kcolor.mainbackgroundcolor,
      body: BlocProvider(
        create: (context) => OnboardingCubit(),
        child: BlocBuilder<OnboardingCubit, int>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      context.read<OnboardingCubit>().setPage(index);
                    },
                    children: [
                      _buildOnboardingPage(
                        context,
                        sectionTitle: 'Examples',
                        sectionIcon:
                            Icons.lightbulb_outline, // Light icon for Examples
                        examples: [
                          '“Explain quantum computing in simple terms”',
                          '“Got any creative ideas for a 10 year old’s birthday?”',
                          '“How do I make an HTTP request in Javascript?”',
                        ],
                      ),
                      _buildOnboardingPage(
                        context,
                        sectionTitle: 'Capability',
                        sectionIcon: Icons
                            .electrical_services, // Electric icon for Capability
                        examples: [
                          '“What is AI and how does it work?”',
                          '“Tell me a joke!”',
                          '“Explain the theory of relativity”',
                        ],
                      ),
                      _buildOnboardingPage(
                        context,
                        sectionTitle: 'Limitation',
                        sectionIcon: Icons
                            .warning_amber_rounded, // Limit icon for Limitation
                        examples: [
                          '“AI cannot predict the future.”',
                          '“AI does not have human emotions.”',
                          '“Explain the limits of machine learning”',
                        ],
                      ),
                    ],
                  ),
                ),
                // Rectangular Page Indicator + Next Button
                _buildBottomNavigation(context, state, pageController),
              ],
            );
          },
        ),
      ),
    );
  }

  // Onboarding Page Widget
  Widget _buildOnboardingPage(
    BuildContext context, {
    required String sectionTitle,
    required IconData sectionIcon,
    required List<String> examples,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Image (Same for all screens)
          SizedBox(
            height: 80.h,
            width: 80.w,
            child: Image.asset(imagePath),
          ),
          SizedBox(height: 30.h),
          // Title (Same for all screens)
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          // Subtitle (Same for all screens)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 30.h),
          // Section (Examples/Capability/Limitation)
          Column(
            children: [
              // Icon and Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sectionIcon,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    sectionTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Examples or Capability or Limitation Section
              ...examples
                  .map((example) => _buildExampleButton(example))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  // Example Button UI
  Widget _buildExampleButton(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF444654), // Gray background
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white), // White text
        ),
      ),
    );
  }

  // Bottom Navigation with Indicator and Next Button
  Widget _buildBottomNavigation(
      BuildContext context, int state, PageController pageController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        children: [
          // Rectangular Page Indicator (Above Next button)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRectangleIndicator(isActive: state == 0),
              _buildRectangleIndicator(isActive: state == 1),
              _buildRectangleIndicator(isActive: state == 2),
            ],
          ),
          SizedBox(height: 20.h), // Space between indicator and button
          // Next Button
          ElevatedButton(
            onPressed: () {
              if (state < 2) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                // TODO: Navigate to home screen or main app
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomeScreen()), // Replace HomeScreen with your actual home screen
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
            ),
            child: Text(
              state == 2
                  ? 'Let\'s Chat'
                  : 'Next', // Change button text on last screen
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Rectangular Indicator Widget
  Widget _buildRectangleIndicator({required bool isActive}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 6.h,
      width: 20.w, // Make it rectangular
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(3.w), // Slight rounded corners
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Home Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Chat Home Screen!'),
      ),
    );
  }
}

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void setPage(int index) {
    emit(index);
  }

  void nextScreen() {
    emit(state + 1);
  }
}
