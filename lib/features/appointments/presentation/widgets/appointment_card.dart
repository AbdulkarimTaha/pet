import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final String nameclinic;
  final String serv;
  final String imageclinic;
  final double rating;
  final String date;

  const AppointmentCard(
      {super.key,
      required this.nameclinic,
      required this.serv,
      required this.imageclinic,
      required this.rating,
      required this.date});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String formattedDate = '';
    try {
      if (date.isNotEmpty) {
        final parsedDate = DateTime.parse(date);
        formattedDate = DateFormat('EEE, MMM d, yyyy, h:mm a').format(parsedDate);
      }
    } catch (e) {
      formattedDate = date;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color(0xffE9F1F0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(imageclinic),
                  ),
                  SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameclinic,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: 16,
                          fontFamily: 'poppins3',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ),
                      Text(
                        serv,
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 13,
                          fontFamily: 'poppins3',
                          fontWeight: FontWeight.w500,
                          height: 1.85,
                          letterSpacing: 0.50,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xfff6f6f6)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xffFFC107),
                                size: 12,
                              ),
                              Text(
                                rating.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'poppins3',
                                  fontWeight: FontWeight.w400,
                                  height: 2.40,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: Icon(
                      Icons.more_horiz,
                      color: Color(0xffA0A0A0),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff99DDCC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_outlined),
                      Spacer(),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.71,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
