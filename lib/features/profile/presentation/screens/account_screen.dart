import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/core/presentation/widgets/custom_button.dart';
import 'package:petscare/features/auth/presentation/screens/account_type_screen.dart';
import 'package:petscare/features/auth/presentation/screens/sign_in_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = '';
  String userEmail = '';

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
    final List elements = [
      {
        "icon": "assets/icons/user-outline.svg",
        "title": "Edit Profile",
        "onTap": () {},
      },
      {
        "icon": "assets/icons/language.svg",
        "title": "Language",
        "onTap": () {},
      },
      {
        "icon": "assets/icons/paw-outline.svg",
        "title": "My Pets",
        "onTap": () {},
      },
      {
        "icon": "assets/icons/book.svg",
        "title": "Learning Space",
        "onTap": () {},
      },
      {
        "icon": "assets/icons/logout.svg",
        "title": "Logout",
        "onTap": () async {
          try {
            await UserService.logout();
            print("logout is =+============================");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AccountTypeScreen()),
              (route) => false, // This removes all previous routes
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout failed: ${e.toString()}')),
            );
          }
        }
      },
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      body: Stack(
        children: [
          Positioned(
            left: 207,
            top: -342,
            child: Container(
              width: 399,
              height: 432,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffBAD7DF).withOpacity(0.3),
                      blurRadius: 300,
                    ),
                  ]),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 25),
            child: SizedBox(
              height: screenHeight - screenHeight * 0.1809,
              child: Column(
                children: [
                  // START ACCOUNT DETELS
                  Container(
                    width: screenWidth * 0.2503,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: Color(0xffD9DEDF)),
                    child: Center(
                      child: Stack(
                        children: [
                          Icon(
                            Icons.person,
                            size: screenWidth * 0.2430,
                            color: Colors.white,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child:
                                SvgPicture.asset("assets/icons/cameraAdd.svg"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.0224),
                  Text(
                    "$userName",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "poppins2",
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.50,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.0044),
                  Text(
                    "$userEmail",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF222222),
                      fontSize: 14,
                      fontFamily: "poppins1",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.12,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.0505),
                  // END ACCOUNT DETELS
                  // ###### - - - - - - #####
                  // START MY LIST GENERATE FOR MY BUTTONS
                  ...List.generate(elements.length, (index) {
                    return CustomButton(
                      icon: elements[index]["icon"],
                      title: elements[index]["title"],
                      onTap: elements[index]["onTap"],
                    );
                  }),
                  // END MY LIST GENERATE FOR MY BUTTONS
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
