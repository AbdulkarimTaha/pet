import 'package:flutter/material.dart';
import 'package:petscare/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:petscare/features/home/presentation/widgets/clinics_near_card.dart';
import 'package:petscare/features/profile/presentation/screens/notifications_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petscare/api/user_service.dart';
import 'dart:async';
import 'package:petscare/api/api_service.dart';

/////////////////////main
List<Map<String, dynamic>> searchResults = [];
Map<String, dynamic>? nextAppointment;
List<Map<String, dynamic>> nearbyClinics = [];
List<Map<String, dynamic>> ammanClinics = [];
bool isLoadingAmmanClinics = false;
String ammanClinicsError = '';

List<Map<String, dynamic>> userAppointments = [];
bool isLoadingAppointments = false;
String? appointmentsError;

///////////////////////
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  Timer? _debounce;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  String? _searchError;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNextAppointment();
    _loadNearbyClinics();
    fetchAmmanClinics();
    fetchUserAppointments();
  }

  Future<void> _loadUserData() async {
    final name = await UserService.getUserName() ?? 'Guest';
    setState(() {
      userName = name;
    });
  }

  ////////////////////////mai

  Future<void> _loadNextAppointment() async {
    final ownerId = await UserService.getUserId();
    if (ownerId != null) {
      await fetchNextAppointment(ownerId);
    }
  }

  Future<void> fetchNextAppointment(String ownerId) async {
    final url =
        Uri.parse('https://api.docai.online/api/appointments/next/$ownerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('message')) {
          // No upcoming appointment
          setState(() {
            nextAppointment = null;
          });
        } else {
          setState(() {
            nextAppointment = data;
          });
        }
      } catch (e) {
        print('JSON decode error: $e');
        setState(() {
          nextAppointment = null;
        });
      }
    } else {
      print("Error fetching next appointment: ${response.statusCode}");
    }
  }

  Future<void> fetchClinics(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        searchResults = [];
        _isSearching = false;
      });
      return;
    }

    print("Searching for: '$keyword'");

    try {
      final url = Uri.parse(
          'https://api.docai.online/api/clinics/search?q=${Uri.encodeQueryComponent(keyword)}');
      print("Full URL: $url");

      final response = await http.get(url);

      print("API Response: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // TEMPORARY: Force test data
        // final data = [{
        //   'id': 'test1',
        //   'name': 'Test Clinic',
        //   'address': '123 Test St',
        //   'rating': 4.5,
        //   'image': 'https://example.com/test.jpg'
        // }];

        if (data is List && data.isEmpty) {
          print("No clinics found for search term: '$keyword'");
        }

        setState(() {
          searchResults = List<Map<String, dynamic>>.from(data);
          _isSearching = true;
        });
      }
    } catch (e) {
      print("Search error: $e");
    }
  }

  Future<void> _loadNearbyClinics() async {
    String? userAddress = await UserService.getUserAddress();
    if (userAddress != null) {
      final url =
          Uri.parse('https://api.docai.online/api/clinics/nearby/$userAddress');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            nearbyClinics = List<Map<String, dynamic>>.from(data);
          });
        } catch (e) {
          print('Nearby clinics JSON decode error: $e');
          setState(() {
            nearbyClinics = [];
          });
        }
      } else {
        print("Error fetching nearby clinics: ${response.statusCode}");
      }
    }
  }

  Future<void> fetchAmmanClinics() async {
    setState(() {
      isLoadingAmmanClinics = true;
      ammanClinicsError = '';
    });
    try {
      final userAddress = await UserService.getUserAddress();
      final clinics = await ApiService.getNearbyClinics(userAddress?? "");
      setState(() {
        ammanClinics = clinics;
        isLoadingAmmanClinics = false;
      });
    } catch (e) {
      setState(() {
        ammanClinicsError = e.toString();
        isLoadingAmmanClinics = false;
      });
    }
  }

  Future<void> fetchUserAppointments() async {
    setState(() {
      isLoadingAppointments = true;
      appointmentsError = null;
    });
    try {
      final ownerId = await UserService.getUserId();
      if (ownerId == null) throw Exception('User not logged in');
      final response = await ApiService.getOwnerAppointments(ownerId);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          userAppointments = List<Map<String, dynamic>>.from(data);
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
    }
  }

  String _getValidImageUrl(Map<String, dynamic> clinic) {
    final image = clinic['image'] ?? clinic['imageUrl'] ?? clinic['logo'];
    if (image == null) return 'assets/images/photocli.jpg';
    if (image.toString().startsWith('http')) return image;
    if (image.toString().startsWith('assets/')) return image;
    return 'assets/images/photocli.jpg';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 25, left: 25, bottom: 10, top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // START TITLE AND PHOTO USER
                    Row(
                      children: [
                        SizedBox(
                          height: screenWidth * 0.1531,
                          width: screenWidth * 0.1531,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(180),
                            child: Container(
                              color: Color(0xffD9DEDF),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.0243),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello $userName ",
                              style: TextStyle(
                                color: const Color(0xFF222222),
                                fontSize: 16,
                                fontFamily: 'Poppins1',
                                letterSpacing: 2.72,
                              ),
                            ),
                            Text(
                              " How are you today?",
                              style: TextStyle(
                                color: const Color(0xFFA0A0A0),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 2.04,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          height: screenHeight * 0.0707,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationsScreen()),
                                  );
                                },
                                child: Icon(Icons.notifications_none),
                              ),
                              SizedBox(width: screenWidth * 0.0364),
                              Icon(Icons.more_horiz, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.0179),
                    // END TITLE AND PHOTO USER

                    // START SEARCH FORM
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            child: TextFormField(
                              controller: _searchController,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    searchResults = [];
                                    _isSearching = false;
                                  });
                                  return;
                                }

                                if (_debounce?.isActive ?? false)
                                  _debounce!.cancel();

                                setState(() => _isSearching = true);

                                _debounce =
                                    Timer(Duration(milliseconds: 500), () {
                                  fetchClinics(value);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "  Search",
                                hintStyle: TextStyle(
                                  color: const Color(0xFF49454F),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: 0.50,
                                ),
                                prefixIcon:
                                    Icon(Icons.menu, color: Color(0xff49454F)),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            searchResults = [];
                                            _isSearching = false;
                                          });
                                        },
                                      )
                                    : Icon(Icons.search,
                                        color: Color(0xff49454F)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffDBDEDF)),
                                    borderRadius: BorderRadius.circular(28)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffDBDEDF)),
                                    borderRadius: BorderRadius.circular(28)),
                                fillColor: Color(0xffDADEE0),
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.0337),
                    // END SEARCH FORM

                    // START UPCOMING APPOINTMENTS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upcoming appointments",
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontSize: 16,
                              fontFamily: 'Poppins2',
                              height: 1.50,
                              letterSpacing: 0.50,
                            ),
                          ),
                          // TextButton(
                          //   style: TextButton.styleFrom(
                          //     padding: EdgeInsets.zero,
                          //     minimumSize: Size(0, 0),
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //   ),
                          //   onPressed: () {},
                          //   child: Text(
                          //     "See All",
                          //     style: TextStyle(
                          //       color: const Color(0xFF99DDCC),
                          //       fontSize: 14,
                          //       fontFamily: 'Poppins',
                          //       fontWeight: FontWeight.w500,
                          //       height: 1.71,
                          //       letterSpacing: 0.50,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // UPCOMING APPOINTMENTS CARDS
                    SizedBox(
                      height: screenHeight * 0.2325,
                      child: nextAppointment != null
                          ? AppointmentCard(
                              nameclinic: nextAppointment!['clinicName'] ?? '',
                              imageclinic: (nextAppointment!['clinicImage']?.toString().startsWith('http') ?? false)
                                  ? nextAppointment!['clinicImage']
                                  : 'assets/images/photocli.jpg',
                              serv: nextAppointment!['service'] ?? '',
                              rating: double.tryParse(nextAppointment!['rating']?.toString() ?? '0') ?? 0.0,
                              date: nextAppointment!['date'] ?? '',
                            )
                          : Center(
                              child: Text(
                                "No upcoming appointments",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                    ),

                    // START CLINICS NEAR YOU
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isSearching
                                ? "Search Results"
                                : "Clinics near you",
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontSize: 16,
                              fontFamily: 'Poppins2',
                              height: 1.50,
                              letterSpacing: 0.50,
                            ),
                          ),
                          // TextButton(
                          //   style: TextButton.styleFrom(
                          //     padding: EdgeInsets.zero,
                          //     minimumSize: Size(0, 0),
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //   ),
                          //   onPressed: () {},
                          //   child: Text(
                          //     "See All",
                          //     style: TextStyle(
                          //       color: const Color(0xFF99DDCC),
                          //       fontSize: 14,
                          //       fontFamily: 'Poppins',
                          //       fontWeight: FontWeight.w500,
                          //       height: 1.71,
                          //       letterSpacing: 0.50,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // CLINICS NEAR YOU CARDS
                    isLoadingAmmanClinics
                        ? Center(child: CircularProgressIndicator())
                        : ammanClinicsError.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  ammanClinicsError,
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : (!_isSearching && ammanClinics.isNotEmpty)
                                ? Column(
                                    children: ammanClinics
                                        .map((clinic) => ClinicsNearCard(
                                              nameclinic: clinic['userName'] ?? '',
                                              imageclinic: 'assets/images/photocli1.jpg',
                                              cliniclocation: clinic['address'] ?? '',
                                              rating: 5.0,
                                              clinicId: clinic['id'] ?? '',
                                            ))
                                        .toList(),
                                  )
                                : (_isSearching ? searchResults : nearbyClinics)
                                        .isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          _isSearching
                                              ? "No matching clinics found"
                                              : "No nearby clinics available",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    : Column(
                                        children: (_isSearching ? searchResults : nearbyClinics)
                                            .map((clinic) => ClinicsNearCard(
                                                  nameclinic: clinic['username'] ?? clinic['userName'] ?? 'Unknown Clinic',
                                                  imageclinic: 'assets/images/photocli1.jpg',
                                                  cliniclocation: clinic['address'] ?? 'Location not available',
                                                  rating: 5.0,
                                                  clinicId: clinic['id'] ?? '',
                                                ))
                                            .toList(),
                                      ),
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
