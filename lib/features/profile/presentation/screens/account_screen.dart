import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:petscare/api/user_service.dart';
import 'package:petscare/core/presentation/widgets/custom_button.dart';
import 'package:petscare/features/auth/presentation/screens/account_type_screen.dart';
import 'package:petscare/features/profile/presentation/screens/edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = '';
  String userEmail = '';
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await UserService.getUserName() ?? 'Guest';
    final email = await UserService.getUserEmail() ?? 'No email';
    setState(() {
      userName = name;
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> elements = [
      {
        "icon": "assets/icons/user-outline.svg",
        "title": "Edit Profile",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          );
        },
      },
      {
        "icon": "assets/icons/language.svg",
        "title": "Language",
        "onTap": () {},
      },
      {
        "icon": "assets/icons/logout.svg",
        "title": "Sign out",
        "onTap": () async {
          try {
            await UserService.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AccountTypeScreen()),
              (route) => false, // This removes all previous routes
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout failed: ${e.toString()}')),
            );
          }
        },
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        body: Stack(
          children: [
            Positioned(
              left: screenWidth * 0.52,
              top: -screenHeight * 0.38,
              child: Container(
                width: screenWidth * 0.7,
                height: screenWidth * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffBAD7DF).withOpacity(0.3),
                      blurRadius: 300,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: SizedBox(
                height: screenHeight - screenHeight * 0.1809,
                child: Column(
                  children: [
                    // Profile image
                    Container(
                      width: screenWidth * 0.2503,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: const Color(0xffD9DEDF),
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            _selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _selectedImage!,
                                      width: screenWidth * 0.243,
                                      height: screenWidth * 0.243,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: screenWidth * 0.243,
                                    color: Colors.white,
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                child: SvgPicture.asset(
                                  "assets/icons/cameraAdd.svg",
                                  width: screenWidth * 0.09,
                                  height: screenWidth * 0.09,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0224),

                    // User name
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                        fontFamily: "poppins2",
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0044),

                    // User email
                    Text(
                      userEmail,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF222222),
                        fontSize: screenWidth * 0.035,
                        fontFamily: "poppins1",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.12,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0505),

                    // Buttons
                    ...elements.map((item) {
                      return CustomButton(
                        icon: item["icon"],
                        title: item["title"],
                        onTap: item["onTap"],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
