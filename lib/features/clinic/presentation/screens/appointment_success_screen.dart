import 'package:flutter/material.dart';
import 'package:petscare/features/clinic/presentation/screens/main_clinic_screen.dart';

class AppointmentSuccessScreen extends StatelessWidget {
  final String clinicId;
  const AppointmentSuccessScreen({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Container(
        color: const Color(0xffF6F6F6),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                // Success Image
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Image.asset(
                      "assets/images/appsucc.png",
                      width: size.width * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Success Message
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Appointment Booked\nSuccessfully!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: 24 * textScaleFactor,
                          fontFamily: 'Poppins2',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.92,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        "Your appointment has been\nconfirmed. We look forward to\nseeing you!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF888888),
                          fontSize: 16 * textScaleFactor,
                          fontFamily: 'Poppins1',
                          letterSpacing: 1.28,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // View Appointment Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainClinicScreen(clinicId: clinicId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff99DDCC),
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "View Appointment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16 * textScaleFactor,
                          fontFamily: 'Poppins1',
                          letterSpacing: 1.28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
