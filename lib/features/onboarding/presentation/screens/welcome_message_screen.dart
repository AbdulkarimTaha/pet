import 'package:flutter/material.dart';

class WelcomeMessageScreen extends StatelessWidget {
  const WelcomeMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Calculate responsive values
    final double topPadding = size.height * 0.04;
    final double horizontalPadding = size.width * 0.12;
    final double imageHeight = size.height * 0.3;
    final double circleSize1 = size.width * 0.12;
    final double circleSize2 = size.width * 0.08;
    final double circleSize3 = size.width * 0.05;
    final double titleSpacing = size.height * 0.05;
    final double subtitleSpacing = size.height * 0.03;

    return Scaffold(
      body: Container(
        color: const Color(0xffF6F6F6),
        child: Column(
          children: [
            // Top section with images and decorative circles
            SizedBox(
              height: size.height * 0.45,
              width: double.infinity,
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    right: size.width * 0.2,
                    top: size.height * 0.1,
                    child: Container(
                      width: circleSize1,
                      height: circleSize1,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE1ECE9),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.15,
                    top: size.height * 0.1,
                    child: Container(
                      width: circleSize2,
                      height: circleSize2,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE1ECE9),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Positioned(
                    right: size.width * 0.1,
                    top: size.height * 0.05,
                    child: Container(
                      width: circleSize3,
                      height: circleSize3,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE1ECE9),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  
                  // Main images
                  Positioned(
                    bottom: 0,
                    left: size.width * 0.15,
                    right: size.width * 0.15,
                    child: Image.asset(
                      "assets/images/cat-dog1.png",
                      height: imageHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.05,
                    right: 0,
                    child: Image.asset(
                      "assets/images/bird.png",
                      height: imageHeight * 0.8,
                      width: size.width * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            
            // Text content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: titleSpacing),
                  Text(
                    "Welcome to Pets Care!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF222222),
                      fontSize: 24 * textScaleFactor,
                      fontFamily: 'Poppins2',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.92,
                    ),
                  ),
                  SizedBox(height: subtitleSpacing),
                  Text(
                    "Your one-stop solution for managing your Pet's health.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 16 * textScaleFactor,
                      fontFamily: 'Poppins1',
                      letterSpacing: 2.72,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
