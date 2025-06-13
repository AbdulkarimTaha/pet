import 'package:flutter/material.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/features/appointments/presentation/widgets/appointment_card.dart';
import 'dart:convert';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final ownerId = await UserService.getUserId();
      if (ownerId == null) throw Exception('User not logged in');
      final response = await ApiService.getUserNotifications(ownerId);
      if (response.statusCode == 200) {
        final data = response.body;
        final decoded = data != null ? jsonDecode(data) : {};
        final notifList = (decoded['notifications'] as List?) ?? [];
        setState(() {
          notifications = List<Map<String, dynamic>>.from(notifList);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
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
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
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
                      color: const Color(0xffBAD7DF).withOpacity(0.3),
                      blurRadius: 300,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // App Bar
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      const SizedBox(width: 100),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins3',
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color(0xffD9D9D9)),
                  const SizedBox(height: 15),
                  // Body
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : error != null
                            ? Center(child: Text('Error: $error'))
                            : notifications.isEmpty
                                ? Center(child: Text('No notifications'))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    itemCount: notifications.length,
                                    itemBuilder: (context, index) {
                                      final notification = notifications[index];
                                      final petName = notification['petName'] ?? '';
                                      final service = notification['service'] ?? '';
                                      final dateStr = notification['date'] ?? '';
                                      String formattedDate = dateStr;
                                      try {
                                        if (dateStr.isNotEmpty) {
                                          final parsedDate = DateTime.parse(dateStr);
                                          formattedDate = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
                                        }
                                      } catch (_) {}
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: AppointmentCard(
                                          nameclinic: petName,
                                          imageclinic: 'assets/images/photocli.jpg',
                                          serv: service,
                                          rating: 5.0,
                                          date: formattedDate,
                                        ),
                                      );
                                    },
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
