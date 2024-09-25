import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';
import 'package:tqnia_chat_app_task/core/util/constant.dart';
import 'package:tqnia_chat_app_task/features/onboarding/presentation/controller/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onComplete;

  OnboardingScreen({super.key, required this.onComplete});

  final String imagePath = AppConstants.imagepath;
  final String title = AppConstants.title;
  final String subtitle = AppConstants.subtitle;

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
                        sectionIcon: Icons.lightbulb_outline,
                        examples: [
                          '“Explain quantum computing in simple terms”',
                          '“Got any creative ideas for a 10 year old’s birthday?”',
                          '“How do I make an HTTP request in Javascript?”',
                        ],
                      ),
                      _buildOnboardingPage(
                        context,
                        sectionTitle: 'Capability',
                        sectionIcon: Icons.electrical_services,
                        examples: [
                          '“Remembers what user said earlier in the conversation”',
                          '“Allows user to provide follow-up corrections”',
                          '“Trained to decline inappropriate requests”',
                        ],
                      ),
                      _buildOnboardingPage(
                        context,
                        sectionTitle: 'Limitation',
                        sectionIcon: Icons.warning_amber_rounded,
                        examples: [
                          '“May occasionally generate incorrect information”',
                          '“May occasionally produce harmful instructions or biased content”',
                          '“Limited knowledge of world and events after 2021”',
                        ],
                      ),
                    ],
                  ),
                ),
                _buildBottomNavigation(context, state, pageController),
              ],
            );
          },
        ),
      ),
    );
  }

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
          SizedBox(
            height: 80.h,
            width: 80.w,
            child: Image.asset(imagePath),
          ),
          SizedBox(height: 30.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
                color: Kcolor.mywhite),
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 30.h),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sectionIcon,
                    color: Kcolor.mywhite,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    sectionTitle,
                    style: TextStyle(
                      color: Kcolor.mywhite,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ...examples.map((example) => _buildExampleButton(example)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF444654),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Kcolor.mywhite),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(
      BuildContext context, int state, PageController pageController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRectangleIndicator(isActive: state == 0),
              _buildRectangleIndicator(isActive: state == 1),
              _buildRectangleIndicator(isActive: state == 2),
            ],
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              if (state < 2) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                if (onComplete != null) {
                  onComplete!();
                }
                Navigator.pushNamed(context, Routes.dashboard);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
            ),
            child: Text(
              state == 2 ? 'Let\'s Chat' : 'Next',
              style: const TextStyle(color: Kcolor.mywhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRectangleIndicator({required bool isActive}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 6.h,
      width: 20.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(3.w),
      ),
    );
  }
}
