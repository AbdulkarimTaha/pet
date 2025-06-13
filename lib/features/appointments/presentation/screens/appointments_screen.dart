import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/api/api_service.dart';
import 'dart:convert';

import 'package:petscare/api/user_service.dart';
import 'package:petscare/features/appointments/presentation/widgets/appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Map<String, dynamic>> userAppointments = [];
  bool isLoadingAppointments = false;
  String? appointmentsError;

  @override
  void initState() {
    super.initState();
    fetchUserAppointments();
  }

  Future<void> fetchUserAppointments() async {
    setState(() {
      isLoadingAppointments = true;
      appointmentsError = null;
    });
    try {
      final ownerId = await UserService.getUserId();
      print('DEBUG: ownerId = ' + (ownerId ?? 'NULL'));
      if (ownerId == null) throw Exception('User not logged in');
      final response = await ApiService.getOwnerAppointments(ownerId);
      print('DEBUG: response.body = ' + response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('DEBUG: parsed data = ' + data.toString());
        setState(() {
          userAppointments = List<Map<String, dynamic>>.from(data);
          print('DEBUG: userAppointments = ' + userAppointments.toString());
          isLoadingAppointments = false;
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      setState(() {
        appointmentsError = e.toString();
        isLoadingAppointments = false;
      });
      print('DEBUG: error = ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                children: [
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // START TAB BAR
                          TabBar(
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(width: 1, color: Color(0xff99DDCC)),
                              insets: EdgeInsets.symmetric(horizontal: 120),
                            ),
                            tabs: [
                              Tab(
                                child: Text(
                                  "Upcoming",
                                  style: TextStyle(
                                    color: const Color(0xFF222222),
                                    fontSize: 14,
                                    fontFamily: 'poppins2',
                                    fontWeight: FontWeight.w600,
                                    height: 1.71,
                                    letterSpacing: 0.50,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Canceled",
                                  style: TextStyle(
                                    color: const Color(0xFF222222),
                                    fontSize: 14,
                                    fontFamily: 'poppins2',
                                    fontWeight: FontWeight.w600,
                                    height: 1.71,
                                    letterSpacing: 0.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // START MY 2 TABS
                          Expanded(
                            child: TabBarView(
                              children: [
                                // UPCOMING TAB
                                isLoadingAppointments
                                    ? Center(child: CircularProgressIndicator())
                                    : appointmentsError != null
                                        ? Center(child: Text('Error: ' + appointmentsError!))
                                        : userAppointments.isEmpty
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/calendar.svg",
                                                    colorFilter: ColorFilter.mode(
                                                      Color(0xffA0A0A0),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: size.width * 0.3292,
                                                    top: size.height * 0.4006,
                                                    child: SvgPicture.asset(
                                                      "assets/icons/Vector.svg",
                                                      colorFilter: ColorFilter.mode(
                                                        Color(0xff99DDCC),
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: size.height * 0.4786,
                                                    child: Text(
                                                      "You currently have no appointment",
                                                      style: TextStyle(
                                                        color: const Color(0xFFA0A0A0),
                                                        fontSize: 12,
                                                        fontFamily: 'poppins3',
                                                        fontWeight: FontWeight.w500,
                                                        height: 2,
                                                        letterSpacing: 0.50,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ListView.builder(
                                                itemCount: userAppointments.length,
                                                itemBuilder: (context, index) {
                                                  final appointment = userAppointments[index];
                                                  final clinic = appointment['clinic'] ?? {};
                                                  final nameclinic = clinic['name'] ?? 'Unknown Clinic';
                                                  final serv = appointment['service'] ?? '';
                                                  final date = appointment['date'] ?? '';
                                                  final imageclinic = 'assets/images/photocli.jpg'; // Update if you have image URLs
                                                  final rating = 5.0; // Update if you have rating info
                                                  return AppointmentCard(
                                                    nameclinic: nameclinic,
                                                    serv: serv,
                                                    imageclinic: imageclinic,
                                                    rating: rating,
                                                      date:date
                                                  );
                                                },
                                              ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/calendar.svg",
                                      colorFilter: ColorFilter.mode(
                                        Color(0xffA0A0A0),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Positioned(
                                      right: size.width * 0.3292,
                                      top: size.height * 0.4006,
                                      child: SvgPicture.asset(
                                        "assets/icons/Vector.svg",
                                        colorFilter: ColorFilter.mode(
                                          Color(0xff99DDCC),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: size.height * 0.4786,
                                      child: Text(
                                        "You currently have no canceled",
                                        style: TextStyle(
                                          color: const Color(0xFFA0A0A0),
                                          fontSize: 12,
                                          fontFamily: 'poppins3',
                                          fontWeight: FontWeight.w500,
                                          height: 2,
                                          letterSpacing: 0.50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
