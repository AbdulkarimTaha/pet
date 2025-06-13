import 'package:flutter/material.dart';

class AIChatbotScreen extends StatelessWidget {
  const AIChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Calculate responsive values
    final double horizontalPadding = size.width * 0.08;
    final double imageHeight = size.height * 0.35;
    final double imageWidth = size.width * 0.7;
    final double titleSpacing = size.height * 0.05;
    final double subtitleSpacing = size.height * 0.03;

    return Scaffold(
      body: Container(
        color: const Color(0xffF6F6F6),
        child: Column(
          children: [
            // Image section
            SizedBox(
              height: size.height * 0.5,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  "assets/images/aibot.jpeg",
                  height: imageHeight,
                  width: imageWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Text content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Instant Pet\n Care Advice.",
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
                    "Our AI chatbot is here to answer your questions 24/7.",
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
