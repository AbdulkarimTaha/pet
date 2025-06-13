import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/features/pets/presentation/widgets/add_pet_button.dart';
import 'package:petscare/features/medical_records/presentation/screens/medical_records_screen.dart';
import 'package:petscare/core/presentation/widgets/custom_button.dart';
import 'package:petscare/core/presentation/widgets/pet_avatar.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> pets = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final userId = await UserService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await ApiService.getOwnerPets(userId);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          pets = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    
    // Calculate safe area height
    final safeAreaHeight = size.height - padding.top - padding.bottom;
    
    // Calculate responsive sizes
    final titleSize = size.width * 0.05; // 5% of screen width
    final avatarSize = size.width * 0.15; // 15% of screen width
    final cardPadding = size.width * 0.04; // 4% of screen width
    final iconSize = size.width * 0.04; // 4% of screen width
    final textSize = size.width * 0.03; // 3% of screen width

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        body: Stack(
          children: [
            Positioned(
              left: size.width * 0.5,
              top: -size.height * 0.4,
              child: Container(
                width: size.width,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffBAD7DF).withOpacity(0.3),
                      blurRadius: size.width * 0.7,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: safeAreaHeight * 0.03,
                horizontal: size.width * 0.05,
              ),
              child: Column(
                children: [
                  Text(
                    'My Pets',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: titleSize,
                      fontFamily: 'Poppins3',
                      letterSpacing: titleSize * 0.06,
                    ),
                  ),
                  SizedBox(height: safeAreaHeight * 0.02),
                  Container(
                    height: 1,
                    width: size.width,
                    color: const Color(0xffD9D9D9),
                  ),

                  if (isLoading)
                    _buildLoadingState()
                  else if (error != null)
                    _buildErrorState()
                  else if (pets.isEmpty)
                    _buildEmptyState()
                  else ...[
                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaHeight * 0.02,
                        left: size.width * 0.05,
                      ),
                      child: SizedBox(
                        height: safeAreaHeight * 0.15,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pets.length + 1,
                          itemBuilder: (context, index) {
                            if (index < pets.length) {
                              return GestureDetector(
                                onTap: () => setState(() => selectedIndex = index),
                                child: PetAvatar(
                                  name: pets[index]["petName"] ?? "Unknown",
                                  imageUrl: pets[index]["imageUrl"] ?? "assets/images/default_pet.png",
                                  isSelected: index == selectedIndex,
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02,
                                ),
                                child: const AddPetButton(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: size.width,
                      color: const Color(0xffD9D9D9),
                    ),

                    if (pets.isNotEmpty) ...[
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: safeAreaHeight * 0.02,
                          horizontal: size.width * 0.05,
                        ),
                        padding: EdgeInsets.all(cardPadding),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1ECE9),
                          borderRadius: BorderRadius.circular(size.width * 0.04),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: avatarSize * 0.5,
                                  backgroundImage: NetworkImage(
                                    pets[selectedIndex]["imageUrl"] ?? "assets/images/default_pet.png",
                                  ),
                                  onBackgroundImageError: (_, __) {},
                                ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Text(
                                    pets[selectedIndex]["petName"] ?? "Unknown",
                                    style: TextStyle(
                                      color: const Color(0xFF222222),
                                      fontSize: textSize,
                                      fontFamily: 'poppins2',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: textSize * 0.1,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  color: const Color(0xffA0A0A0),
                                  size: iconSize,
                                ),
                              ],
                            ),
                            SizedBox(height: safeAreaHeight * 0.01),
                            Padding(
                              padding: EdgeInsets.only(
                                left: avatarSize + cardPadding,
                                bottom: cardPadding,
                              ),
                              child: GridView.count(
                                childAspectRatio: 5.5,
                                crossAxisCount: 2,
                                mainAxisSpacing: safeAreaHeight * 0.01,
                                crossAxisSpacing: size.width * 0.02,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildInfoItem(
                                    "assets/icons/maleOrfemale.svg",
                                    pets[selectedIndex]["gender"] ?? "Unknown",
                                    iconSize,
                                    textSize,
                                  ),
                                  _buildInfoItem(
                                    "assets/icons/bd.svg",
                                    "${_calculateAge(pets[selectedIndex]["birthDate"])} old",
                                    iconSize,
                                    textSize,
                                  ),
                                  _buildInfoItem(
                                    "assets/icons/dna.svg",
                                    pets[selectedIndex]["breed"] ?? "Unknown",
                                    iconSize,
                                    textSize,
                                  ),
                                  _buildInfoItem(
                                    "assets/icons/lineicons.svg",
                                    "${pets[selectedIndex]["weight"]?.toString() ?? "0"} kg",
                                    iconSize,
                                    textSize,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          bottom: safeAreaHeight * 0.02,
                        ),
                        child: CustomButton(
                          icon: "assets/icons/plus1.svg",
                          title: "Medical Records",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Midicalrecords(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xff99DDCC),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading pets',
              style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            TextButton(
              onPressed: _loadPets,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No pets added yet',
              style: TextStyle(
                color: Colors.grey,
                fontSize: size.width * 0.04,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            const AddPetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String iconPath, String text, double iconSize, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          width: iconSize,
          height: iconSize,
        ),
        SizedBox(width: iconSize * 0.5),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontFamily: 'poppins1',
              fontWeight: FontWeight.w400,
              letterSpacing: fontSize * 0.1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _calculateAge(String? birthDate) {
    if (birthDate == null) return "Unknown";
    
    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      
      int years = now.year - birth.year;
      int months = now.month - birth.month;
      
      if (now.day < birth.day) {
        months--;
      }
      
      if (months < 0) {
        years--;
        months += 12;
      }
      
      if (years > 0) {
        return "$years year${years > 1 ? 's' : ''}";
      } else {
        return "$months month${months > 1 ? 's' : ''}";
      }
    } catch (e) {
      return "Unknown";
    }
  }
}
