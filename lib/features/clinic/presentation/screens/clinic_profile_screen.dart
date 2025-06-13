import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/features/clinic/presentation/screens/book_appointment_screen.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/features/auth/presentation/screens/account_type_screen.dart';

class ClinicProfileScreen extends StatefulWidget {
  const ClinicProfileScreen({super.key});

  @override
  State<ClinicProfileScreen> createState() => _ClinicProfileScreenState();
}

class _ClinicProfileScreenState extends State<ClinicProfileScreen> {
  final List<Map<String, dynamic>> services = [
    {"name": "Check Up", "imageUrl": "assets/images/asd1.svg"},
    {"name": "Vaccination", "imageUrl": "assets/images/asd2.svg"},
    {"name": "Grooming", "imageUrl": "assets/images/asd3.svg"},
    {"name": "Treatment", "imageUrl": "assets/images/asd4.svg"},
    {"name": "Surgery", "imageUrl": "assets/images/asd5.svg"},
    {"name": "Dental Care", "imageUrl": "assets/images/asd6.svg"},
  ];

  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await UserService.getUserRole();

    if (mounted) {
      setState(() {
        userRole = role;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      await UserService.logout();
      if (!mounted) return;
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AccountTypeScreen()),
        (route) => false, // This removes all previous routes
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: userRole == "veterinaryClinic"
          ? IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: _handleLogout,
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
        title: Text(
          userRole == "veterinaryClinic" ? "Clinic Profile" : "Clinic Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18 * textScaleFactor,
            fontFamily: 'Poppins3',
            fontWeight: FontWeight.w500,
            letterSpacing: 1.08,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            height: size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/clicniphoto3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Column(
            children: [
              SizedBox(height: size.height * 0.3),

              // Clinic Card
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.05),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.05),

                        // Rating
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                          child: Row(
                            children: [
                              ...List.generate(4, (index) => 
                                const Icon(Icons.star, color: Colors.amber, size: 24)
                              ),
                              const Icon(Icons.star_outline, color: Colors.amber, size: 24),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                '4 Stars',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: size.height * 0.03),

                        // Address Section
                        _buildSectionTitle(context, 'Address', textScaleFactor),
                        SizedBox(height: size.height * 0.01),
                        _buildSectionContent(
                          context, 
                          '123 Veterinary Street, Pet City, PC 12345',
                          textScaleFactor,
                        ),

                        SizedBox(height: size.height * 0.03),

                        // Working Hours Section
                        _buildSectionTitle(context, 'Working hours', textScaleFactor),
                        SizedBox(height: size.height * 0.01),
                        _buildSectionContent(
                          context, 
                          'Open: 9 AM - Closed 8 PM',
                          textScaleFactor,
                        ),

                        SizedBox(height: size.height * 0.03),

                        // Services Section
                        _buildSectionTitle(context, 'Services', textScaleFactor),
                        SizedBox(height: size.height * 0.02),

                        // Services Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: size.width * 0.04,
                            mainAxisSpacing: size.width * 0.04,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) => _buildServiceItem(
                            context,
                            services[index]["name"],
                            services[index]["imageUrl"],
                            size,
                            textScaleFactor,
                          ),
                        ),

                        SizedBox(height: size.height * 0.03),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, double textScaleFactor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF222222),
          fontSize: 16 * textScaleFactor,
          fontFamily: 'poppins1',
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, String content, double textScaleFactor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        content,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14 * textScaleFactor,
          fontFamily: 'poppins1',
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    String name,
    String imageUrl,
    Size size,
    double textScaleFactor,
  ) {
    return Column(
      children: [
        Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          decoration: BoxDecoration(
            color: const Color(0xffE1ECE9),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageUrl,
                width: size.width * 0.08,
                height: size.width * 0.08,
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xff4A4A4A),
            fontSize: 12 * textScaleFactor,
            fontFamily: 'Poppins3',
          ),
        ),
      ],
    );
  }
}
