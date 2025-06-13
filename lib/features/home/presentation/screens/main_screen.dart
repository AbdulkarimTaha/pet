import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:petscare/features/profile/presentation/screens/account_screen.dart';
import 'package:petscare/features/community/presentation/screens/community_screen.dart';
import 'package:petscare/features/home/presentation/screens/home_screen.dart';
import 'package:petscare/features/pets/presentation/screens/my_pets_screen.dart';
import 'package:petscare/features/pets/presentation/screens/pet_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool havepet = true;
  late List<Widget> bottomNavScreens = [
    HomeScreen(),
    CommunityScreen(),
    if (havepet) PetScreen() else MyPetsScreen(),
    AppointmentsScreen(),
    AccountScreen(),
  ];
  int _selectedIndex = 0;

  final List<String> _iconPaths = [
    'assets/icons/family-home.svg',
    'assets/icons/users-outline.svg',
    'assets/icons/paw-outline.svg',
    'assets/icons/calendar-line.svg',
    'assets/icons/user-outline.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      body: SafeArea(
        bottom: false, // Important to prevent overlap with BottomNavigationBar
        child: bottomNavScreens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000).withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xffF0F0F0),
            items: List.generate(
              _iconPaths.length,
              (index) {
                final isSelected = index == _selectedIndex;
                return BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    _iconPaths[index],
                    colorFilter: ColorFilter.mode(
                      isSelected ? Color(0xff99DDCC) : Colors.black,
                      BlendMode.srcIn,
                    ),
                    height: 24, // Fixed size instead of dynamic calculation
                  ),
                  label: "",
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
