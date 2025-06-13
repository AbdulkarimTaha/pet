import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/features/pets/presentation/screens/add_pet_screen.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: SizedBox(
              height: screenHeight - screenHeight * 0.1809,
              child: Column(
                children: [
                  // START APP BAR
                  Text(
                    'My Pets',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Poppins3',
                      letterSpacing: 1.20,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.0213),
                  SizedBox(
                    height: 1,
                    width: screenWidth,
                    child: Container(
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.3348),
                  // END APP BAR
                  // ###### - - - - - - #####
                  // START ADD PET

                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddPetScreen()));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/fontisto_paw.svg",
                              colorFilter: ColorFilter.mode(
                                Color(0xffA0A0A0),
                                BlendMode.srcIn,
                              ),
                            ),
                            Positioned(
                              bottom: screenHeight * 0.0134,
                              child: Icon(
                                Icons.add,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.0269),
                      Text(
                        "Add Pet",
                        style: TextStyle(
                          color: const Color(0xFFA6A6A6),
                          fontSize: 24,
                          fontFamily: 'Poppins3',
                          letterSpacing: 4.08,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
