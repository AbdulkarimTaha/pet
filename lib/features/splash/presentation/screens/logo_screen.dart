import 'package:flutter/material.dart';
import 'package:petscare/features/onboarding/presentation/screens/onboarding_view.dart';
import 'package:petscare/features/home/presentation/screens/main_screen.dart';
import 'package:petscare/features/clinic/presentation/screens/clinic_profile_screen.dart';
import 'package:petscare/api/user_service.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 600),
    );
    _fadingAnimation = Tween<double>(begin: .2, end: 1).animate(_animationController);

    _animationController.repeat(reverse: true);
    _goToNextView();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Container(
        color: const Color(0xff99DDCC),
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: size.height * 0.2,
            ),
            SizedBox(height: size.height * 0.025),
            FadeTransition(
              opacity: _fadingAnimation,
              child: Text(
                "PETS CARE",
                style: TextStyle(
                  color: const Color(0xffF6F6F6),
                  fontFamily: 'montserrat',
                  fontSize: 24 * textScaleFactor,
                  letterSpacing: 4.08,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToNextView() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    // Check if user is logged in
    final isLoggedIn = await UserService.isLoggedIn();
    
    if (!mounted) return;

    if (isLoggedIn) {
      // Get user role
      final userRole = await UserService.getUserRole();
      
      if (!mounted) return;

      // Navigate based on role
      if (userRole == "veterinaryClinic") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ClinicProfileScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      // If not logged in, show onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    }
  }
}
