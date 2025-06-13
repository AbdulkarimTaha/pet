import 'package:flutter/material.dart';
import 'package:petscare/features/auth/presentation/screens/account_type_screen.dart';
import 'package:petscare/features/onboarding/presentation/screens/ai_chatbot_screen.dart';
import 'package:petscare/features/onboarding/presentation/screens/find_nearby_vets_screen.dart';
import 'package:petscare/features/onboarding/presentation/screens/get_started_screen.dart';
import 'package:petscare/features/onboarding/presentation/screens/key_features_screen.dart';
import 'package:petscare/features/onboarding/presentation/screens/welcome_message_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  bool isLastPage = false;

  void _toggleLastPage() {
    setState(() {
      isLastPage = !isLastPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final padding = MediaQuery.of(context).padding;

    // Calculate responsive values
    final double bottomPadding = size.height * 0.07;
    final double horizontalPadding = size.width * 0.08;
    final double buttonHeight = size.height * 0.06;
    final double indicatorBottom = bottomPadding + buttonHeight + size.height * 0.05;
    final double skipButtonSpacing = size.width * 0.35;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Page content
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                WelcomeMessageScreen(),
                KeyFeaturesScreen(),
                FindNearbyVetsScreen(),
                AIChatbotScreen(),
                GetStartedScreen(),
              ],
            ),
            
            // Page indicator
            Positioned(
              bottom: indicatorBottom,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 5,
                  effect: const ScaleEffect(
                    dotColor: Color.fromARGB(255, 183, 177, 177),
                    activeDotColor: Color(0XFF99DDCC),
                    dotWidth: 8,
                    dotHeight: 8,
                  ),
                ),
              ),
            ),
            
            // Navigation buttons
            Positioned(
              bottom: bottomPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              child: !isLastPage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _toggleLastPage();
                            _pageController.animateToPage(
                              4,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 14 * textScaleFactor,
                              fontFamily: 'Poppins1',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2.38,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_pageController.page! < 4) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            }
                            if (_pageController.page == 3) {
                              _toggleLastPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff99DDCC),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.12,
                              vertical: size.height * 0.018,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16 * textScaleFactor,
                              fontFamily: 'Poppins1',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2.72,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountTypeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff99DDCC),
                          elevation: 0,
                        ),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * textScaleFactor,
                            fontFamily: 'Poppins1',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2.72,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
