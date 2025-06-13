import 'package:flutter/material.dart';
import 'package:petscare/features/auth/presentation/screens/sign_in_screen.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  String _selectedRole = "petOwner";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Calculate responsive values
    final double horizontalPadding = size.width * 0.08;
    final double titleTopPadding = size.height * 0.23;
    final double optionsTopPadding = size.height * 0.4;
    final double cardWidth = size.width * 0.39;
    final double cardHeight = size.height * 0.25;
    final double cardSpacing = size.width * 0.05;
    final double buttonHeight = size.height * 0.06;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF6F6F6),
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            // Background decorations
            Positioned(
              left: -size.width * 0.5,
              bottom: 0,
              child: Container(
                width: size.width,
                height: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffFFE2E2).withOpacity(0.6),
                      blurRadius: size.width * 0.75,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -size.width * 0.3,
              top: -size.width * 0.8,
              child: Container(
                width: size.width,
                height: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffBAD7DF).withOpacity(0.6),
                      blurRadius: size.width * 0.75,
                    ),
                  ],
                ),
              ),
            ),

            // Title
            Positioned(
              left: horizontalPadding,
              right: horizontalPadding,
              top: titleTopPadding,
              child: Text(
                'Select Your Account Type',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF222222),
                  fontSize: 24 * textScaleFactor,
                  fontFamily: 'Poppins2',
                  letterSpacing: 1.92,
                ),
              ),
            ),

            // Account type options
            Positioned(
              left: horizontalPadding,
              right: horizontalPadding,
              top: optionsTopPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pet Owner Option
                  _buildAccountTypeCard(
                    title: "Pet Owner",
                    role: "petOwner",
                    width: cardWidth,
                    height: cardHeight,
                    textScaleFactor: textScaleFactor,
                    images: [
                      Positioned(
                        left: 0,
                        top: cardHeight * 0.2,
                        child: Image.asset(
                          "assets/images/PhotoBetOwner1.png",
                          width: cardWidth * 1.2,
                          height: cardHeight * 0.9,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        left: cardWidth * 0.05,
                        top: cardHeight * 0.05,
                        child: Image.asset(
                          "assets/images/PhotoBetOwner2.png",
                          width: cardWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  // Veterinary Clinic Option
                  _buildAccountTypeCard(
                    title: "Veterinary Clinic",
                    role: "veterinaryClinic",
                    width: cardWidth,
                    height: cardHeight,
                    textScaleFactor: textScaleFactor,
                    images: [
                      Positioned(
                        left: 0,
                        top: cardHeight * 0.15,
                        child: Image.asset(
                          "assets/images/PhotoVeterinaryClinic.png",
                          width: cardWidth,
                          height: cardHeight * 0.7,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Next button
            Positioned(
              right: horizontalPadding,
              bottom: size.height * 0.05,
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(role: _selectedRole),
                      ),
                    );
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeCard({
    required String title,
    required String role,
    required double width,
    required double height,
    required double textScaleFactor,
    required List<Widget> images,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.23, 0.01),
                end: Alignment(-0.20, 0.99),
                colors: [
                  Color(0xFFE1ECE9),
                  Color(0xFF99DDCC),
                ],
              ),
              borderRadius: BorderRadius.circular(width * 0.25),
              border: _selectedRole == role
                  ? Border.all(
                      color: const Color(0xff99DDCC),
                      width: 3.0,
                    )
                  : null,
            ),
            child: Stack(
              children: images,
            ),
          ),
          SizedBox(height: height * 0.07),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4A4A4A),
              fontSize: 15 * textScaleFactor,
              fontFamily: 'Poppins2',
              letterSpacing: 1.20,
            ),
          ),
        ],
      ),
    );
  }
}
